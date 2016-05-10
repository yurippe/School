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
