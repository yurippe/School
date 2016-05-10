;;;;;;;;;;

(define check-silently
  #t)

;;;;;;;;;;

(define proper-list-of-given-length?
  (lambda (v n)
    (or (and (null? v)
             (= n 0))
        (and (pair? v)
             (> n 0)
             (proper-list-of-given-length? (cdr v)
                                           (1- n))))))


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

;;;;;;;;;;

(define check-toplevel-form
  (lambda (v)
    (cond
      [(is-definition? v)
       (check-definition (define-1 v) (define-2 v))]
      [else
       (check-expression v)])))

;;;;;;;;;;

;;;;;;;;;;
;;; basic predicates and accessors for definitions:
;;;;;;;;;;

;;; predicate:
(define is-definition?
  (lambda (v)
    (and (proper-list-of-given-length? v 3)
         (equal? (car v) 'define))))

;;; 1st accessor:
(define define-1
  (lambda (v)
    (list-ref v 1)))

;;; 2nd accessor:
(define define-2
  (lambda (v)
    (list-ref v 2)))

;;;;;;;;;;
;;; the syntax checker proper for definitions:
;;;;;;;;;;

(define check-definition
  (lambda (name definiens)
    (and (check-variable name)
         (check-expression definiens))))

;;;;;;;;;;

;;;;;;;;;;
;;; basic predicates and accessors for expressions:
;;;;;;;;;;

;;;;;

;;; predicate:
(define is-number?
  (lambda (v)
    (number? v)))

;;;;;

;;; predicate:
(define is-boolean?
  (lambda (v)
    (boolean? v)))

;;;;;

;;; predicate:
(define is-character?
  (lambda (v)
    (char? v)))

;;;;;

;;; predicate:
(define is-string?
  (lambda (v)
    (string? v)))

;;;;;

;;; predicate:
(define is-variable?
  (lambda (v)
    (char? v)))

;;;;;

;;; predicate:
(define is-time?
  (lambda (v)
    (and (proper-list-of-given-length? v 2)
         (equal? (car v) 'time))))

;;; 1st accessor:
(define time-1
  (lambda (v)
    (list-ref v 1)))

;;;;;

;;; predicate:
(define is-if?
  (lambda (v)
    (and (proper-list-of-given-length? v 4)
         (equal? (car v) 'if))))

;;; 1st accessor:
(define if-1
  (lambda (v)
    (list-ref v 1)))

;;; 2nd accessor:
(define if-2
  (lambda (v)
    (list-ref v 2)))

;;; 3rd accessor:
(define if-3
  (lambda (v)
    (list-ref v 3)))

;;;;;

;;; predicate:
(define is-unless?
  (lambda (v)
    (and (proper-list-of-given-length? v 3)
         (equal? (car v) 'unless))))

;;; 1st accessor:
(define unless-1
  (lambda (v)
    (list-ref v 1)))

;;; 2nd accessor:
(define unless-2
  (lambda (v)
    (list-ref v 2)))

;;;;;

;;; predicate:
(define is-quote?
  (lambda (v)
    (and (proper-list-of-given-length? v 2)
         (equal? (car v) 'quote))))

;;; 1st accessor:
(define quote-1
  (lambda (v)
    (list-ref v 1)))

;;;;;

;;; predicate:
(define is-application?
  (lambda (v)
    (and (pair? v)
         (let ([w (car v)])
           (if (symbol? w)
               (not (keyword? w))
               #t)))))

;;; 1st accessor:
(define application-operator
  car)

;;; 2nd accessor:
(define application-operands
  cdr)

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
      [(is-time? v)
       (check-time-expression (time-1 v))]
      [(is-if? v)
       (check-if-expression (if-1 v) (if-2 v) (if-3 v))]
      ;;; and
      ;;; or
      ;;; cond
      ;;; etc.
      [(is-unless? v)
       (check-unless-expression (unless-1 v) (unless-2 v))]
      [(is-quote? v)
       (check-quote-expression (quote-1 v))]
      [(is-lambda? v)
       (errorf 'check-expression "not implemented yet")]
      [(is-trace-lambda? v)
       (errorf 'check-expression "not implemented yet")]
      [(is-application? v)
       (check-application (application-operator v) (application-operands v))]
      [else
       (begin
         (unless check-silently
           (printf "check-expression -- unrecognized input: ~s~n" v))
         #f)])))

(define check-number
  (lambda (n)
    #t))

(define check-boolean
  (lambda (b)
    #t))

(define check-character
  (lambda (c)
    (char? c)))

(define check-string
  (lambda (s)
    (string? s)))

(define check-variable
  (lambda (v)
    (and (symbol? v) (not (keyword? v)))))

(define check-time-expression
  (lambda (v)
    (check-expression v)))

(define check-if-expression
  (lambda (test consequent alternative)
    (and (check-expression test)
         (check-expression consequent)
         (check-expression alternative))))

(define check-unless-expression
  (lambda (test consequent)
    (and (check-expression test)
         (check-expression consequent))))

(define check-quote-expression
  (lambda (v)
    (errorf 'check-quote-expression "not implemented yet")))

(define check-application
  (lambda (v vs)
    (errorf 'check-application "not implemented yet")))

;;;;;;;;;;
;;; auxiliaries:
;;;;;;;;;;

(define keyword?
  (lambda (w)
    (member w '(define time if cond else case and or let let* letrec begin unless quote lambda trace-lambda))))

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
