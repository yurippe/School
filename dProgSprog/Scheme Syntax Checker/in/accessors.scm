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
