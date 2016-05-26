;;; self-interpreter.scm
;;; dProgSprog 2015-2016, Q4
;;; Olivier Danvy <danvy@cs.au.dk>
;;; a deliberately unreadable self-interpreter in direct style for (a subset of) Scheme
;;; Version 2.0 -- 06 April 2014

;;; Use: start Petite Chez Scheme and load "self-interpreter.scm"
;;; then type (start-the-interpreter ">> ")
;;
;;; This interpreter is totally meta-circular.
;;; It can be loaded in a session with
;;;       (load "self-interpreter.scm")
;;; and started with
;;;       (start-the-interpreter ">>> ")
;;; at the price of a measurable slowness.
;;; NB. We make the prompts grow
;;;     to reflect the growing layers of interpretation.
;;; 
;;; To exit, type
;;;       (exit)
;;; at the toplevel.

;;; Syntax:
;;; 
;;;       <toplevel-form> ::= (define <identifier> <expression>)
;;;                         | (load <string>)
;;;                         | (exit)
;;;                         | <expression>
;;;      
;;;          <expression> ::= <integer>
;;;                         | <string>
;;;                         | <boolean>
;;;                         | <identifier>
;;;                         | (quote <representable-value>)
;;;                         | <lambda-expression>
;;;                         | (if <expression> <expression> <expression>)
;;;                         | (cond
;;;                             {[<expression> <expression>]}*
;;;                             [else <expression>])
;;;                         | (set! <identifier> <expression>)
;;;                         | (and <expression>*)
;;;                         | (or <expression>*)
;;;                         | (begin {<expression>}+)
;;;                         | (case <expression>
;;;                             {[({<representable-value>}*) <expression>]}*
;;;                             [else <expression>])
;;;                         | (let ({[<identifier> <expression>]}*)
;;;                             <expression>)
;;;                         | (let* ({[<identifier> <expression>]}*)
;;;                             <expression>)
;;;                         | (letrec ({[<identifier> <lambda-expression>]}*)
;;;                             <expression>)
;;;                         | (time <expression>)
;;;                         | (<expression> {<expression>}*)
;;;   
;;;   <lambda-expression> ::= (lambda ({<identifier>}*) <expression>)
;;; 
;;;          <identifier> ::= <symbol>
;;;                           that is not a keyword
;;; 
;;; <representable-value> ::= <integer>
;;;                         | <string>
;;;                         | <boolean>
;;;                         | <symbol>
;;;                         | ()
;;;                         | (<representable-value> . <representable-value>)
;;; 
;;; where <symbol>, <integer>, <string>, and <boolean> are the usual
;;; non-terminals:
;;; 
;;;             <boolean> ::= #t
;;;                         | #f
;;; 
;;; etc.

;;; predefined procedures:
;;;     < <= = >= >
;;;     car cdr
;;;     caar cadr
;;;     cdar cddr
;;;     caddr cdddr
;;;     list-tail
;;;     last-pair
;;;     null? pair?
;;;     integer? string? symbol?
;;;     zero?
;;;     + - *
;;;     cons equal?
;;;     boolean?
;;;     procedure?
;;;     list
;;;     set-car! set-cdr!
;;;     display print
;;;     pretty-print newline
;;;     not length
;;;     read
;;;     open-input-file eof-object?
;;;     close-input-port
;;;     member
;;;     errorf

;;; Semantics:
;;;
;;; Values:
;;; Val = Integer + String + Symbol + Pair + Procedure + Subroutine
;;;
;;; Environments -- lexical extensions, then global, then pre-defined:
;;; Env = (Ide* x Val*)*
;;;
;;; User-defined and primitive procedures:
;;; Proc =  Val* -> val
;;; Subr = Val* -> Val

;;; ------ auxiliaries ------------------------------------------------------

(define _proper-list?
  (lambda (e)
    (letrec ([visit (lambda (e n)
                      (cond
                       [(null? e)
                        n]
                       [(pair? e)
                        (visit (cdr e) (+ n 1))]
                       [else
                        #f]))])
      (visit e 0))))

(define _constant?
  (lambda (exp)
    (or (integer? exp)
        (string? exp)
        (boolean? exp))))

(define _list-of-keywords
  '(define load exit quote lambda if cond set! and or begin case let let* letrec time))

(define _keyword?
  (lambda (exp)
    (and (symbol? exp)
         (member exp _list-of-keywords))))

(define _identifier?
  (lambda (exp)
    (and (symbol? exp)
         (not (member exp _list-of-keywords)))))

(define _all-distinct-identifiers?
  (lambda (xs-given origin)
    (letrec ([visit (lambda (x xs)
                      (cond
		       [(null? xs)
			#t]
		       [(_identifier? x)
			(if (member x xs)
			    (errorf origin
				    "non-distinct identifiers: ~s"
				    xs-given)
			    (visit (car xs) (cdr xs)))]
		       [else
			(errorf origin
				"illegal identifier: ~s"
				x)]))])
      (or (null? xs-given)
          (visit (car xs-given) (cdr xs-given))))))

(define _make-procedure
  (lambda (n a)
    (list 'proc n a)))

(define _make-subroutine
  (lambda (n a)
    (list 'subr n a)))

(define _fetch-kind car)
(define _fetch-arity cadr)
(define _fetch-value caddr)

(define _applicable?
  (lambda (v)
    (and (equal? (_proper-list? v) 3)
         (case (_fetch-kind v)
           [(subr proc)
            (and (integer? (_fetch-arity v))
                 (procedure? (_fetch-value v)))]
           [else
            #f]))))

;;; Basic lexical environment extension:
(define _extend-env
  (lambda (xs vs env)
    (cons (cons xs vs) env)))

(define _access
  car)

(define _update
  set-car!)

(define _index
  (lambda (i is)
    (letrec ([loop
              (lambda (n is)
                (cond
                  [(null? is)
                   -1]
                  [(equal? i (car is))
                   n]
                  [else
                   (loop (+ n 1) (cdr is))]))])
      (loop 0 is))))

;;; ----- the core -----------------------------------------------------------

(define _eval   ;;; Expr * Env -> Val
  (lambda (exp env)
    (cond
      [(_constant? exp)
       exp]
      [(_identifier? exp)
       (_lookup exp env)]
      [(pair? exp)
       (if (_keyword? (car exp))
           (_eval-special-form (car exp) (cdr exp) env)
           (_apply (_eval (car exp) env) (cdr exp) env))]
      [else
       (errorf '_eval "unknown input: ~s" exp)])))

(define _lookup   ;;; Ide * Env -> Val
  (lambda (i env)
    (cond
     [(null? env)
      (let ([pos (_index i table-toplevel-identifiers)])
        (if (>= pos 0)
            (_access (list-tail table-toplevel-values pos))
            (errorf '_lookup "undeclared identifier: ~s" i)))]
     [(pair? env)
      (let ([frame (car env)]
            [rest (cdr env)])
        (let ([names (car frame)]
              [denotations (cdr frame)])
          (let ([pos (_index i names)])
            (if (>= pos 0)
                (_access (list-tail denotations pos))
                (_lookup i rest)))))]
     [else
      (errorf '_lookup "illegal environment: ~s" env)])))

(define _apply   ;;; Val * List-of-Expr * Env -> Val
  (lambda (v actuals env)
    (if (_applicable? v)
        (case (_fetch-kind v)
          [(subr)
           (_apply-subroutine v actuals env)]
          [(proc)
           (_apply-procedure v actuals env)]
          [else
           (errorf '_apply "Unknown Functional Object: ~s" v)])
        (errorf '_apply "unapplicable value: ~s" v))))

(define _apply-subroutine   ;;; Subr * List-of-Expr * Env -> Val
  (lambda (v actuals env)
    (let ([arity-actuals (_proper-list? actuals)])
      (if arity-actuals
          (case (_fetch-arity v)
            [(0)
             (if (= 0 arity-actuals)
                 ((_fetch-value v))
                 (errorf '_apply-subroutine
                         "not 0 actuals: ~s"
                         arity-actuals))]
            [(1)
             (if (= 1 arity-actuals)
                 ((_fetch-value v)
                  (_eval (car actuals) env))
                 (errorf '_apply-subroutine
                         "not 1 actual: ~s"
                         arity-actuals))]
            [(2)
             (if (= 2 arity-actuals)
                 ((_fetch-value v)
                  (_eval (car actuals) env)
                  (_eval (cadr actuals) env))
                 (errorf '_apply-subroutine
                         "not 2 actuals: ~s"
                         arity-actuals))]
            [(3)
             (if (= 3 arity-actuals)
                 ((_fetch-value v)
                  (_eval (car actuals) env)
                  (_eval (cadr actuals) env)
                  (_eval (caddr actuals) env))
                 (errorf '_apply-subroutine
                         "not 3 actuals: ~s"
                         arity-actuals))]
            [(-1)
             ((_fetch-value v)
              (_evlis actuals env))]
            [else
             (errorf '_apply-subroutine
                     "illegal arity: ~s"
                     arity-formals)])
          (errorf '_apply-subroutine
                  "improper actuals: ~s"
                  actuals)))))

(define _apply-procedure   ;;; Proc * List-of-Expr * Env -> Val
  (lambda (v actuals env)
    (let ([arity-actuals (_proper-list? actuals)])
      (if arity-actuals
          (if (= (_fetch-arity v) arity-actuals)
              ((_fetch-value v) (_evlis actuals env))
              (errorf '_apply_procedure "arity mismatch: ~s" actuals))
          (errorf '_apply-procedure
                  "improper actuals: ~s"
                  actuals)))))

(define _evlis   ;;; List-of-Expr * Env -> Val
  (lambda (actuals env)
    (if (null? actuals)
        '()
        ;;; left-to-right evaluation:
        (let ([v (_eval (car actuals) env)])
          (cons v (_evlis (cdr actuals) env))))))

(define _eval-special-form   ;;; Keyword * List-of-Expr * Env -> Val
  (lambda (keyword rest env)
    (let ([arity-rest (_proper-list? rest)])
      (if arity-rest
          (case keyword
            [(quote)
             (if (= arity-rest 1)
                 (_quote (car rest) env)
                 (errorf '_eval-special-form
                         "improper quote: ~s"
                         rest))]
            [(lambda)
             (if (= arity-rest 2)
                 (_lambda (car rest) (cadr rest) env)
                 (errorf '_eval-special-form
                         "improper lambda: ~s"
                         rest))]
            [(if)
             (if (= arity-rest 3)
                 (_if (car rest) (cadr rest) (caddr rest) env)
                 (errorf '_eval-special-form
                         "improper if: ~s"
                         rest))]
            [(cond)
             (if (>= arity-rest 1)
                 (_cond (car rest) (cdr rest) env)
                 (errorf '_eval-special-form
                         "improper cond: ~s"
                         rest))]
            [(set!)
             (if (= arity-rest 2)
                 (_set! (car rest) (cadr rest) env)
                 (errorf '_eval-special-form
                         "improper set!: ~s"
                         rest))]
            [(and)
             (_and rest env)]
            [(or)
             (_or rest env)]
            [(begin)
             (if (>= arity-rest 1)
                 (_begin (car rest) (cdr rest) env)
                 (errorf '_eval-special-form
                         "improper begin: ~s"
                         rest))]
            [(case)
             (if (>= arity-rest 2)
                 (_case (car rest) (cadr rest) (cddr rest) env)
                 (errorf '_eval-special-form
                         "improper case: ~s"
                         rest))]
            [(let)
             (if (= arity-rest 2)
                 (_let (car rest) (cadr rest) env)
                 (errorf '_eval-special-form
                         "improper let: ~s"
                         rest))]
            [(let*)
             (if (= arity-rest 2)
                 (_let* (car rest) (cadr rest) env)
                 (errorf '_eval-special-form
                         "improper let*: ~s"
                         rest))]
            [(letrec)
             (if (= arity-rest 2)
                 (_letrec (car rest) (cadr rest) env)
                 (errorf '_eval-special-form
                         "improper letrec: ~s"
                         rest))]
            [(time)
             (if (= arity-rest 1)
                 (_time (car rest) env)
                 (errorf '_eval-special-form
                         "improper time: ~s"
                         rest))]
            [else
             (errorf '_eval-special-form
                     "improper keyword: ~s"
                     keyword)])
          (errorf '_eval-special-form
                  "improper form: ~s"
                  rest)))))

(define _quote
  (lambda (quoted-value env)
    quoted-value))

(define _lambda
  (lambda (formals body env)
    (let ([arity (_proper-list? formals)])
      (if arity
          (and (_all-distinct-identifiers? formals '_lambda)
               (_make-procedure arity
                                (lambda (actuals)
                                  (_eval body (_extend-env formals actuals env)))))
          (errorf '_lambda
                  "improper formals: ~s"
                  formals)))))

(define _if
  (lambda (test consequent alternative env)
    (if (_eval test env)
        (_eval consequent env)
        (_eval alternative env))))

(define _cond
  (lambda (clause clauses env)
    (let ([two (_proper-list? clause)])
      (if (and two (= two 2))
          (cond
           [(null? clauses)
            (if (equal? (car clause) 'else)
                (_eval (cadr clause) env)
                (errorf '_cond
                        "illegal last clause: ~s"
                        clause))]
           [(pair? clauses)
            (if (_eval (car clause) env)
                (_eval (cadr clause) env)
                (_cond (car clauses) (cdr clauses) env))]
           [else
            (errorf '_cond
                  "improper clauses: ~s"
                  clauses)])
          (errorf '_cond
                  "improper clause: ~s"
                  clause)))))

(define _set!
  (lambda (x e current-env)
    (if (_identifier? x)
        (let ([v (_eval e current-env)])
          (letrec ([visit (lambda (env)
                            (let ([frame (car env)]
                                  [rest (cdr env)])
                              (let ([names (car frame)]
                                    [denotations (cdr frame)])
                                (let ((pos (_index x names)))
                                  (cond
                                   [(>= pos 0)
                                    (let* ([location (list-tail denotations pos)]
                                           [previous-value (_access location)])
                                      (begin
                                        (_update location v)
                                        previous-value))]
                                   [(null? rest)
                                    (let ([pos (_index x table-toplevel-identifiers)])
                                      (if (>= pos 0)
                                          (begin
                                            (set-car! frame (cons x names))
                                            (set-cdr! frame (cons v denotations))
                                            (_access (list-tail table-toplevel-values pos)))
                                          (errorf 'set! "undefined variable: ~s" x)))]
                                   [else
                                    (visit (cdr env))])))))])
            (visit current-env)))
        (errorf '_set!
                "not an identifier: ~s"
                x))))

(define _and
  (lambda (es env)
    (letrec ([visit (lambda (e es)
                      (if (null? es)
                          (_eval e env)
                          (case (_eval e env)
                            [(#f)
                             #f]
                            [else
                             (visit (car es) (cdr es))])))])
      (if (null? es)
          #t
          (visit (car es) (cdr es))))))

(define _or
  (lambda (es env)
    (letrec ([visit (lambda (e es)
                      (if (null? es)
                          (_eval e env)
                          (let ([v (_eval e env)])
                            (case v
                              [(#f)
                               (visit (car es) (cdr es))]
                              [else
                               v]))))])
      (if (null? es)
          #f
          (visit (car es) (cdr es))))))

(define _begin
  (lambda (e es env)
    (letrec ([visit (lambda (e es)
                      (if (null? es)
                          (_eval e env)
                          (begin
                            (_eval e env)
                            (visit (car es) (cdr es)))))])
      (visit e es))))

(define _case 
  (lambda (test clause clauses env)
    (let ([v (_eval test env)])
      (letrec ([visit (lambda (clause clauses)
                        (let ([two (_proper-list? clause)])
                          (if (and two (= two 2))
                              (cond
                               [(null? clauses)
                                (if (equal? (car clause) 'else)
                                    (_eval (cadr clause) env)
                                    (errorf '_case
                                            "illegal last clause: ~s"
                                            clause))]
                               [(_proper-list? (car clause))
                                (if (member v (car clause))
                                    (_eval (cadr clause) env)
                                    (visit (car clauses) (cdr clauses)))]
                               [else
                                (errorf '_case
                                        "improper constant list: ~s"
                                        (car clause))])
                              (errorf '_case
                                      "illegal clause: ~s"
                                      clause))))])
        (visit clause clauses)))))

(define _proper-header?
  (lambda (header origin)
    (case (_proper-list? header)
      [(2)
       (or (_identifier? (car header))
           (errorf origin
                   "illegal formal: ~s"
                   (car header)))]
      [(#f)
       (errorf origin
               "improper header: ~s"
               header)]
      [else
       (errorf origin
               "illegal header: ~s"
               header)])))

(define _proper-headers?
  (lambda (headers origin)
    (letrec ([visit (lambda (headers)
                      (or (null? headers)
                          (and (_proper-header? (car headers) origin)
                               (visit (cdr headers)))))])
      (visit headers))))

(define _let-idlis
  (lambda (headers)
    (if (null? headers)
        '()
        (cons (car (car headers)) (_let-idlis (cdr headers))))))

(define _let-evlis
  (lambda (headers env)
    (letrec ([visit (lambda (headers)
                      (if (null? headers)
                          '()
                          ;;; left-to-right evaluation:
                          (let ([v (_eval (cadr (car headers)) env)])
                            (cons v (visit (cdr headers))))))])
      (visit headers))))

(define _let
  (lambda (headers body env)
    (case (_proper-list? headers)
      [(0)
       (_eval body env)]
      [(#f)
       (errorf '_let
               "improper headers: ~s"
               headers)]
      [else
       (and (_proper-headers? headers '_let)
            (let ([xs (_let-idlis headers)])
              (and (_all-distinct-identifiers? xs '_let)
                   (_eval body (_extend-env xs
                                            (_let-evlis headers env)
                                            env)))))])))

(define _let*
  (lambda (headers body env)
    (case (_proper-list? headers)
      [(0)
       (_eval body env)]
      [(#f)
       (errorf '_let*
               "improper headers: ~s"
               headers)]
      [else
       (and (_proper-headers? headers '_let*)
            (letrec ([visit (lambda (headers env)
                              (if (null? headers)
                                  (_eval body env)
                                  (visit (cdr headers)
                                         (_extend-env (list (car (car headers)))
                                                      (list (_eval (cadr (car headers)) env))
                                                      env))))])
              (visit headers env)))])))

(define _letrec-evlis
  (lambda (headers env)
    (letrec ([visit (lambda (headers)
                      (if (null? headers)
                          '()
                          (let ([definiens (cadr (car headers))])
                            (if (and (pair? definiens)
                                     (equal? (car definiens) 'lambda))
                                (cons (_eval definiens env)
                                      (visit (cdr headers)))
                                (errorf '_letrec
                                        "improper header: ~s"
                                        (car headers))))))])
      (visit headers))))

(define _letrec
  (lambda (headers body env)
    (case (_proper-list? headers)
      [(0)
       (_eval body env)]
      [(#f)
       (errorf '_letrec
               "improper headers: ~s"
               headers)]
      [else
       (and (_proper-headers? headers '_letrec)
            (let ([xs (_let-idlis headers)])
              (and (_all-distinct-identifiers? xs '_letrec)
                   (let* ([env (_extend-env xs '() env)]
                          [vs (_letrec-evlis headers env)])
                     (begin
                       (set-cdr! (car env) vs)
                       (_eval body env))))))])))

(define _time
  (lambda (exp env)
    (time (_eval exp env))))

;;; ----- the predefined procedures ------------------------------------------

(define _list
  (lambda (vs) vs))

(define _read
  (lambda (actuals)
    (cond
      [(null? actuals)
       (read)]
      [(and (pair? actuals)
            (null? (cdr actuals)))
       (read (car actuals))]
      [else
       (errorf '_read "too many actuals: ~s" actuals)])))

; ----- the initial environment -----------------------------------------------

(define table-toplevel-identifiers
      '(< <= = >= >
        car cdr
        caar cadr
        cdar cddr
        caddr cdddr
        list-tail
        last-pair
        null? pair?
        integer? string? symbol?
        zero?
        + - *
        cons equal?
        boolean?
        procedure?
        list
        set-car! set-cdr!
        display print
        pretty-print newline
        not length
        read
        open-input-file eof-object?
        close-input-port
        member
        errorf
        ))

(define table-toplevel-values
  (list (_make-subroutine 2 <) (_make-subroutine 2 <=) (_make-subroutine 2 =) (_make-subroutine 2 >=) (_make-subroutine 2 >)
        (_make-subroutine 1 car) (_make-subroutine 1 cdr)
        (_make-subroutine 1 caar) (_make-subroutine 1 cadr)
        (_make-subroutine 1 cdar) (_make-subroutine 1 cddr)
        (_make-subroutine 1 caddr) (_make-subroutine 1 cdddr)
        (_make-subroutine 2 list-tail)
        (_make-subroutine 1 last-pair)
        (_make-subroutine 1 null?) (_make-subroutine 1 pair?)
        (_make-subroutine 1 integer?) (_make-subroutine 1 string?) (_make-subroutine 1 symbol?)
        (_make-subroutine 1 zero?)
        (_make-subroutine 2 +) (_make-subroutine 2 -) (_make-subroutine 2 *)
        (_make-subroutine 2 cons) (_make-subroutine 2 equal?)
        (_make-subroutine 1 boolean?)
        (_make-subroutine 1 _applicable?)
        (_make-subroutine -1 _list)
        (_make-subroutine 2 set-car!) (_make-subroutine 2 set-cdr!)
        (_make-subroutine 1 display) (_make-subroutine 1 pretty-print)
        (_make-subroutine 1 pretty-print) (_make-subroutine 0 newline)
        (_make-subroutine 1 not) (_make-subroutine 1 length)
        (_make-subroutine -1 _read)
        (_make-subroutine 1 open-input-file) (_make-subroutine 1 eof-object?)
        (_make-subroutine 1 close-input-port)
        (_make-subroutine 2 member)
        (_make-subroutine 3 errorf)
        ))

;;; ----- the read-eval-print toplevel loop ----------------------------------

(define _banner
  "There we go again.")

;;; treatment of a definition at the toplevel
(define _define
  (lambda (x e toplevel-environment)
    (if (_identifier? x)
        (let ([v (_eval e toplevel-environment)]
              [toplevel-names (car (car toplevel-environment))]
              [toplevel-values (cdr (car toplevel-environment))])
          (let* ([pos (_index x toplevel-names)])
            (if (>= pos 0)
                (begin
                  (_update (list-tail toplevel-values pos) v)
                  x)
                (begin
                  (set-car! (car toplevel-environment)
                            (cons x toplevel-names))
                  (set-cdr! (car toplevel-environment)
                            (cons v toplevel-values))
                  x))))
        (errorf '_define "not an identifier: ~s" x))))

;;; treatment of a definition in a loaded file
(define _load-define
  (lambda (x e env)
    (if (_identifier? x)
        (let ([v (_eval e env)])
          (let* ([global-env (car (last-pair env))]
                 [pos (_index x (car global-env))])
            (if (>= pos 0)
                (begin
                  (_update (list-tail (cdr global-env) pos) v)
                  x)
                (begin
                  (set-car! global-env
                            (cons x (car global-env)))
                  (set-cdr! global-env
                            (cons v (cdr global-env)))
                  x))))
        (errorf '_define "not an identifier: ~s" x))))

;;; treatment of a file to load
(define _load
  (lambda (filename toplevel-environment filenames)
    (if (string? filename)
        (if (member filename filenames)
            (errorf '_load
                    "circular loading: ~s"
                    (cons filename filenames))
            (letrec ([loop
                      (lambda (port)
                        (let ([e (read port)])
                          (cond
                           [(eof-object? e)
                            (begin
                              (close-input-port port)
                              filename)]
                           [(and (pair? e)
                                 (equal? (car e) 'exit))
                            (case (_proper-list? (cdr e))
                              [(#f)
                               (errorf 'exit "improper actuals: ~s" (cdr e))]
                              [(0)
                               (begin
                                 (close-input-port port)
                                 filename)]
                              [else
                               (begin
                                 (close-input-port port)
                                 (_evlis (cdr e) toplevel-environment))])]
                           [(and (pair? e)
                                 (equal? (car e) 'define))
                            (case (_proper-list? (cdr e))
                              [(#f)
                               (errorf 'define "improper form: ~s" e)]
                              [(2)
                               (begin
                                 (_load-define (cadr e) (caddr e) toplevel-environment)
                                 (loop port))]
                              [else
                               (errorf 'define "illegal form: ~s" e)])]
                           [(and (pair? e)
                                 (equal? (car e) 'load))
                            (case (_proper-list? (cdr e))
                              [(#f)
                               (errorf 'load "improper form: ~s" e)]
                              [(1)
                               (begin
                                 (_load (cadr e) toplevel-environment (cons filename filenames))
                                 (loop port))]
                              [else
                               (errorf '_load "illegal form: ~s" e)])]
                           [else
                            (begin
                              (_eval e toplevel-environment)
                              (loop port))])))])
              (loop (open-input-file filename))))
        (errorf '_load "not a string: ~s" filename))))

;;; toplevel loop
(define start-the-interpreter
  (lambda (prompt)
    (let ([toplevel-environment (list (cons '() '()))])
      (letrec ([read-eval-print-loop
                (lambda ()
                  (begin
                    (display prompt)
                    (let ([e (read)])
                      (cond
                       [(eof-object? e)
                        (begin
                          (newline)
                          "So long.")]
                       [(and (pair? e)
                             (equal? (car e) 'exit))
                        (case (_proper-list? (cdr e))
                          [(#f)
                           (errorf 'exit "improper actuals: ~s" (cdr e))]
                          [(0)
                           "So long."]
                          [else
                           (_evlis (cdr e) toplevel-environment)])]
                       [(and (pair? e)
                             (equal? (car e) 'define))
                        (case (_proper-list? (cdr e))
                          [(#f)
                           (errorf 'define "improper form: ~s" e)]
                          [(2)
                           (begin
                             (_define (cadr e) (caddr e) toplevel-environment)
                             (read-eval-print-loop))]
                          [else
                           (errorf 'define "illegal form: ~s" e)])]
                       [(and (pair? e)
                             (equal? (car e) 'load))
                        (case (_proper-list? (cdr e))
                          [(#f)
                           (errorf 'load "improper form: ~s" e)]
                          [(1)
                           (begin
                             (_load (cadr e) toplevel-environment '())
                             (read-eval-print-loop))]
                          [else
                           (errorf 'load "illegal form: ~s" e)])]
                       [else
                        (begin
                          (pretty-print
                            (_eval e toplevel-environment))
                          (read-eval-print-loop))]))))])
        (begin
          (display _banner)
          (newline)
          (read-eval-print-loop))))))

;;; ----- end of "self-interpreter.scm" --------------------------------------
