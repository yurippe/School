;;;Resume of scientific article:

;Isaac Asimov says that there is no theory that is either 100% right or 100%
;wrong. He says that theories are fuzzy. One must refine theories to make them
;better and more accurate, but one should not dismiss something as wrong,
;rather incomplete.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Help methods
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define check-silently #f)
;;;;;;;;;;;;;



(define list-strictly-longer-than?
  (lambda (v n)
    (letrec ([visit (lambda (v i)
                      (and (pair? v)
                           (or (= i 0)
                               (visit (cdr v)
                                      (- i 1)))))])
      (if (>= n 0)
          (visit v n)
          (errorf 'list-strictly-longer-than? "negative length: ~s" n)))))

;;; reads an entire file as a list of Scheme data
;;; use: (read-file "filename.scm")
(define read-file
  (lambda (filename)
    (call-with-input-file filename
      (lambda (p)
        (letrec ([visit (lambda ()
                          (let ([in (read p)])
                            (if (eof-object? in)
                                '()
                                (cons in (visit)))))])
          (visit))))))

;;; interface:
(define check-file
  (lambda (filename)
    (if (string? filename)
        (check-program (read-file filename))
        (errorf 'check-file "not a string: ~s" filename))))

;;;;;;;;;;

(define proper-list-of-given-length?
  (lambda (v n)
    (or (and (null? v)
             (= n 0))
        (and (pair? v)
             (> n 0)
             (proper-list-of-given-length? (cdr v)
                                           (1- n))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Constructors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;Done
(define is-definition?
  (lambda (v)
    (and (proper-list-of-given-length? v 3)
         (equal? (car v) 'define))))


;;Done
(define is-time-expression?
	(lambda (v)
    (and (proper-list-of-given-length? v 2)
         (equal? (car v) 'time))))

;;Done
(define is-if-expression?
	(lambda (v)
    (and (proper-list-of-given-length? v 4)
         (equal? (car v) 'if))))

;;Done
(define is-and-expression?
	(lambda (v)
		(and (pair? v)
				 (equal? (car v) 'and)
)))

;;Done
(define is-or-expression?
	(lambda (v)
		(and (pair? v)
				 (equal? (car v) 'or)
)))

;;Done
(define is-cond-expression?
	(lambda (v)
		(and (pair? v)
			(equal? (car v) 'cond)
)))


;;Done
(define is-else-clause?
	(lambda (v)
		(and
			(pair? v)
			(equal? (car v) 'else)
)))

;;Done
(define is-case-expression?
	(lambda (v)
		(and (list-strictly-longer-than? v 2)
		(equal? (car v) 'case)
)))

;;Done
(define is-let-expression?
	(lambda (v)
		(and (proper-list-of-given-length? v 3)
					(equal? (car v) 'let)
)))

;;Done
(define is-letstar-expression?
	(lambda (v)
		(and (proper-list-of-given-length? v 3)
				 (equal? (car v) 'let*)
)))

;;Done
(define is-letrec-expression?
	(lambda (v)
		(and (proper-list-of-given-length? v 3)
				 (equal? (car v) 'letrec)
)))

;;Done
(define is-begin-expression?
	(lambda (v)
		(and (pair? v)
				 (equal? (car v) 'begin)
         (pair? (cdr v))
)))

;;Done
(define is-unless-expression?
	(lambda (v)
    (and (proper-list-of-given-length? v 3)
         (equal? (car v) 'unless))))

;;Done
(define is-quote-expression?
	(lambda (v)
    (and (proper-list-of-given-length? v 2)
         (equal? (car v) 'quote))))


;;Done
(define is-lambda-abstraction?
	(lambda (v)
		(or
			(and (proper-list-of-given-length? v 3)
					 (equal? (car v) 'lambda))
			(and (proper-list-of-given-length? v 4)
			 	   (equal? (car v) 'trace-lambda))
)))

;;Done
(define is-application?
	(lambda (v)
    (and (pair? v)
         (let ([w (car v)])
           (if (symbol? w)
               (not (keyword? w))
               #t)))))


;;Bases:
;;Done
(define is-number?
  (lambda (v)
    (number? v)))
;;Done
(define is-boolean?
  (lambda (v)
    (boolean? v)))

;;Done
(define is-character?
  (lambda (v)
    (char? v)))

;;Done
(define is-symbol?
	(lambda (v)
		(symbol? v)))

;;Done
(define is-string?
  (lambda (v)
    (string? v)))

;;Done
(define is-variable?
  (lambda (v)
    (and (is-symbol? v) (not (keyword? v)))))

;;Done
(define keyword?
	(lambda (v)
		(member v '(define time if cond else case and or let let* letrec begin unless quote lambda trace-lambda))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Accessors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define program-1
	(lambda (v)
		(list-ref v 1)))

(define toplevel-forms-1
	(lambda (v)
		(list-ref v 1)))

(define toplevel-form-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define definition-1
	(lambda (v)
		(list-ref v 1)))
;;Done
(define definition-2
	(lambda (v)
		(list-ref v 2)))

(define expressions-1
	(lambda (v)
		(list-ref v 1)))

(define expression-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define time-expression-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define if-expression-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define if-expression-2
	(lambda (v)
		(list-ref v 2)))

;;Done
(define if-expression-3
	(lambda (v)
		(list-ref v 3)))

;;Done
(define and-expression-1
	(lambda (v)
		(cdr v)))

;;Done
(define or-expression-1
	(lambda (v)
		(cdr v)))
;;Done
(define cond-expression-1
	(lambda (v)
		(cdr v)))

(define cond-clauses-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define cond-clause-0
	(lambda (v)
		(list-ref v 0)))
;;Done
(define cond-clause-1
	(lambda (v)
		(list-ref v 1)))
;;Done
(define cond-clause-2
	(lambda (v)
		(list-ref v 2)))

;;Done
(define else-clause-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define case-expression-1
	(lambda (v)
		(car (cdr v))))

;;Done
(define case-expression-2
			(lambda (v)
				(cdr (cdr v))))


(define case-clauses-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define case-clause-0
	(lambda (v)
		(list-ref v 0)))
;;Done
(define case-clause-1
	(lambda (v)
		(list-ref v 1)))

(define quotations-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define let-expression-1
	(lambda (v)
		(list-ref v 1)))
;;Done
(define let-expression-2
			(lambda (v)
				(list-ref v 2)))

(define let-bindings-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define let-binding-0
	(lambda (v)
		(list-ref v 0)))
;;Done
(define let-binding-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define letstar-expression-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define letstar-expression-2
	(lambda (v)
		(list-ref v 2)))

(define letstar-bindings-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define letstar-binding-0
	(lambda (v)
		(list-ref v 0)))
;;Done
(define letstar-binding-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define letrec-expression-1
	(lambda (v)
		(list-ref v 1)))
;;Done
(define letrec-expression-2
	(lambda (v)
		(list-ref v 2)))

(define letrec-bindings-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define letrec-binding-0
	(lambda (v)
		(list-ref v 0)))
;;Done
(define letrec-binding-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define begin-expression-1
	(lambda (v)
		(cdr v)))

;;Done
(define begin-expression-2
			(lambda (v)
				(cdr (cdr v))))

;;Done
(define unless-expression-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define unless-expression-2
	(lambda (v)
		(list-ref v 2)))

;;Done
(define quote-expression-1
	(lambda (v)
		(list-ref v 1)))

(define quotation-1
	(lambda (v)
		(list-ref v 1)))

(define lambda-abstraction-1
	(lambda (v)
		(list-ref v 1)))

(define lambda-formals-1
	(lambda (v)
		(list-ref v 1)))

(define application-1
	(lambda (v)
		(list-ref v 1)))

;;Done
(define application-operator
		  car)

;;Done
(define application-operands
		  cdr)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checkers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Done
(define check-bindings-duplicates
  (lambda (bindings)
    (letrec ([visit (lambda (remaining visited)

        ;;We can assume that the bindings are valid, because they passed check-bindings
        ;;bindings is a list of with binding elements
        ;;a binding element is a pair, where the car is the vairable, this cant be duplicated
        (cond
        [(null? remaining) #t]
        [(pair? remaining)
         (let ([binding (car remaining)])
          (cond
            [(pair? binding)
            (if (member (car binding) visited)
                #f
                (visit (cdr remaining) (cons (car binding) visited)))]
            [(null? binding) #f] ;;Do we need this condition? if not remove cond
            [else #f]
            )

         )

        ]
        [else
          (begin
            (unless check-silently
                (printf "check-bindings-duplicates -- expected pair: ~s~n" bindings))
              #f)]

      ))])

    (visit bindings '())

  )))


;;Done
(define check-program
  (lambda (v)
    (cond
      [(null? v)
       #t]
      [(pair? v)
       (and (check-toplevel-form (car v))
            (check-program (cdr v)))]
      [else
       (begin
         (unless check-silently
           (printf "check-program -- unrecognized input: ~s~n" v))
         #f)])))

;;Done
(define check-toplevel-forms
	(lambda (v)
	(cond
		[(null? v) #t]
		[(pair? v)
			(and (check-toplevel-form (car v))
					 (check-toplevel-forms (cdr v)))]
		[else
		(begin
			(unless check-silently
				(printf "check-program -- unrecognized input: ~s~n" v))
			#f)]

)))

;;Done
(define check-toplevel-form
		  (lambda (v)
		    (cond
		      [(is-definition? v)
		       (check-definition (definition-1 v) (definition-2 v))]
		      [else
		       (check-expression v)])))

;;Done
(define check-definition
 (lambda (name definiens)
   (and (check-variable name)
        (check-expression definiens))))

;;Done
(define check-expressions
	(lambda (v)
		(cond
			[(null? v)
				#t]
			[(pair? v)
				(and (check-expression (car v))
						 (check-expressions (cdr v)))]
			[else
      (begin
        (unless check-silently
          (printf "check-expressions -- expected pair: ~s~n" v))
        #f)]
			)))

;;Done
(define check-time-expression
  (lambda (v)
    (check-expression v)))

;;Done
(define check-if-expression
  (lambda (test consequent alternative)
    (and (check-expression test)
         (check-expression consequent)
         (check-expression alternative))))
;;Done
(define check-and-expression
	(lambda (v)
		(check-expressions v)))
;;Done
(define check-or-expression
	(lambda (v)
		(check-expressions v)))

;;Done
(define check-cond-expression
	(lambda (v)
		(check-cond-clauses v)))

;;Done
(define check-cond-clauses
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 1)
			(if (and (is-else-clause? (car v)) (check-else-clause (car v)))
        #t
        (begin
  			 (unless check-silently
  				(printf "check-cond-clauses -- expected else clause ~s~n" v))
  			#f))]
		[(pair? v)
			(and (check-cond-clause (car v))
					 (check-cond-clauses (cdr v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-cond-clauses -- expected pair ~s~n" v))
      #f)]
		)))

;;Done
(define check-cond-clause
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 1)
			(check-expression (cond-clause-0 v))]
		[(proper-list-of-given-length? v 2)
			(and (check-expression (cond-clause-0 v))
					 (check-expression (cond-clause-1 v)))]
		[(proper-list-of-given-length? v 3)
				 			(and (check-expression (cond-clause-0 v))
									 (equal? (cond-clause-1 v) '=>)
				 					 (check-expression (cond-clause-2 v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-cond-clause -- unrecognized input: ~s~n" v))
      #f)]
		)))

;;Done
(define check-else-clause
	(lambda (v)
	(cond
		[(pair? v)
			(check-expression (else-clause-1 v))]
		[else
    (begin
      (unless check-silently
        (printf "check-else-clause -- expected (else <expression>): ~s~n" v))
      #f)]
		)))

;;Done
(define check-case-expression
	(lambda (exp cclauses)
			(and (check-expression exp)
					 (check-case-clauses cclauses))
	))

;;Done
(define check-case-clauses
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 1)
			(if (check-else-clause (car v)) #t (begin
  			(unless check-silently
  				(printf "check-case-clauses -- expected else clause: ~s~n" v))
  			#f))]
		[(pair? v)
			(and (check-case-clause (car v))
					 (check-case-clauses (cdr v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-case-clauses -- expected pair: ~s~n" v))
      #f)]
		)))

;;TODO hmmmm
(define check-case-clause
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 2)
			(and (check-quotations (case-clause-0 v))
					 (check-expression (case-clause-1 v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-case-clause -- expected: (<quotations> <expression>): ~s~n" v))
      #f)]
		)))

;;Done
(define check-quotations
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(pair? v)
			(and (check-quotation (car v))
					 (check-quotations (cdr v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-quotations -- expected pair: ~s~n" v))
      #f)]
		)))

;;Done
(define check-let-expression
	(lambda (bindings exp)
		(and (check-let-bindings bindings)
				 (check-expression exp)
         (check-bindings-duplicates bindings) ;;TODO
)))

;;Done
(define check-let-bindings
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(pair? v)
			(and (check-let-binding (car v))
					 (check-let-bindings (cdr v)))] ;;TODO
		[else
    (begin
      (unless check-silently
        (printf "check-let-bindings -- expected pair: ~s~n" v))
      #f)]
		)))

;;Done
(define check-let-binding
	(lambda (v)
		(and (proper-list-of-given-length? v 2) (check-variable (let-binding-0 v)) (check-expression (let-binding-1 v))
)))

;;Done
(define check-letstar-expression
	(lambda (bindings exp)
			(and (check-letstar-bindings bindings)
			 		 (check-expression exp))))

;;Done
(define check-letstar-bindings
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(pair? v)
			(and (check-letstar-binding (car v))
					 (check-letstar-bindings (cdr v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-letstar-bindings -- expected pair: ~s~n" v))
      #f)]
		)))

;;Done
(define check-letstar-binding
	(lambda (v)
	(and (proper-list-of-given-length? v 2) (check-variable (letstar-binding-0 v)) (check-expression (letstar-binding-1 v))
)))

;;Done
(define check-letrec-expression
	(lambda (bindings exp)
			(and (check-letrec-bindings bindings)
			 		 (check-expression exp)
           (check-bindings-duplicates bindings))))

;;Done
(define check-letrec-bindings
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(pair? v)
			(and (check-letrec-binding (car v))
					 (check-letrec-bindings (cdr v)))]
		[else
    (begin
      (unless check-silently
        (printf "check-letrec-bindings -- expected pair: ~s~n" v))
      #f)]
		)))

;;Done
(define check-letrec-binding
	(lambda (v)
		(and (proper-list-of-given-length? v 2) (check-variable (letrec-binding-0 v)) (check-lambda-abstraction (letrec-binding-1 v)))))

;;Done
(define check-begin-expression
	(lambda (exp exps)
			(and (check-expression exp)
					 (check-expressions exps))
		))

;;Done
(define check-unless-expression
  (lambda (test consequent)
    (and (check-expression test)
         (check-expression consequent))))

;;Done
(define check-quote-expression
	(lambda (v)
		 (check-quotation v)))

;;Done
(define check-quotation
	(lambda (v)
	(cond
		[(is-number? v)
		 (check-number v)]
		[(is-boolean? v)
		 (check-boolean v)]
		[(is-character? v)
		 (check-character v)]
		[(is-string? v)
		 (check-string v)]
		[(is-symbol? v)
		 (check-symbol v)]
		[(null? v) #t]

		[(pair? v)
		 (and (check-quotation (car v)) (check-quotation (cdr v)))
		]

		[else     (begin
          (unless check-silently
            (printf "check-quotation -- not a quotation: ~s~n" v))
          #f)])))

;;Done
(define check-lambda-abstraction
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 3)
			(and (check-lambda-formals (list-ref v 1))
					 (check-expression (list-ref v 2))
           (check-lambda-formals-unique (list-ref v 1)))]
		[(proper-list-of-given-length? v 4)
			(and (check-variable (list-ref v 1))
				 	 (check-lambda-formals (list-ref v 2))
					 (check-expression (list-ref v 3))
           (check-lambda-formals-unique (list-ref v 2)))]
		[else
    (begin
      (unless check-silently
        (printf "check-lambda-abstraction -- not a valid lambda abstraction: ~s~n" v))
      #f)]
		)))

;;Done
(define check-lambda-formals
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(is-variable? v)
			(check-variable v)]
		[(pair? v)
			(and (check-variable (car v)) (check-lambda-formals (cdr v)))
		]

		[else
    (begin
      (unless check-silently
        (printf "check-lambda-formals -- expected pair: ~s~n" v))
      #f)]
		)))

(define check-lambda-formals-unique
  (lambda (v)
    (letrec ([visit (lambda (rem checked)
      (cond

        [(null? rem) #t]
        [(pair? rem)
          (if (member (car rem) checked)
            (begin
              (unless check-silently
                (printf "check-lambda-formals-unique -- Non unique: ~s~n" (car rem)))
            #f)
            (visit (cdr rem) (cons (car rem) checked)))]
        [(is-variable? rem) (check-variable rem)]

        [else
          (begin
            (unless check-silently
              (printf "hmm -- Non unique: ~s~n" rem))
                    #f)]

      ))])

      (visit v '())

      )

  ))


;;Done
(define check-application
  (lambda (v vs)
			(and (check-expression v) (check-expressions vs))
))

;;;Bases
;;Done
(define check-number
  (lambda (n)
    #t))
;;Done
(define check-boolean
  (lambda (b)
    #t))

(define check-character
  (lambda (c)
    (char? c)))

(define check-string
  (lambda (s)
    (string? s)))

(define check-symbol
	(lambda (s)
		(symbol? s)))

(define check-variable
  (lambda (v)
    (and (symbol? v) (not (keyword? v)))))

;;;;;;;;;;
;;; the syntax checker proper for expressions:
;;;;;;;;;;

(define check-expression
  (lambda (v)
    (cond
      [(is-number? v)
       (check-number v)]
      [(is-boolean? v)
       (check-boolean v)]
      [(is-character? v)
       (check-character v)]
      [(is-string? v)
       (check-string v)]
      [(is-variable? v)
       (check-variable v)]

      [(is-time-expression? v)
       (check-time-expression (time-expression-1 v))]
      [(is-if-expression? v)
       (check-if-expression (if-expression-1 v) (if-expression-2 v) (if-expression-3 v))]

			[(is-and-expression? v)
			(check-and-expression (and-expression-1 v))]

			[(is-or-expression? v)
			(check-or-expression (or-expression-1 v))]

			[(is-cond-expression? v)
			(check-cond-expression (cond-expression-1 v))
			]

			[(is-case-expression? v)
			 (check-case-expression (case-expression-1 v) (case-expression-2 v))
			]

			[(is-let-expression? v)
			 (check-let-expression (let-expression-1 v) (let-expression-2 v))
			]

			[(is-letstar-expression? v)
			 (check-letstar-expression (letstar-expression-1 v) (letstar-expression-2 v))
			]

			[(is-letrec-expression? v)
			 (check-letrec-expression (letrec-expression-1 v) (letrec-expression-2 v))
			]

			[(is-begin-expression? v)
			  (check-begin-expression (begin-expression-1 v) (begin-expression-2 v))
			]

      [(is-unless-expression? v)
       (check-unless-expression (unless-expression-1 v) (unless-expression-2 v))]
      [(is-quote-expression? v)
       (check-quote-expression (quote-expression-1 v))]
      [(is-lambda-abstraction? v)
       (check-lambda-abstraction v)]
      [(is-application? v)
       (check-application (application-operator v) (application-operands v))]
      [else
       (begin
         (unless check-silently
           (printf "check-expression -- unrecognized input: ~s~n" v))
         #f)])))


