;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Checkers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
				#f]
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
			(check-else-clause (car v))]
		[(pair? v)
			(and (check-cond-clause (car v))
					 (check-cond-clauses (cdr v)))]
		[else
			#f]
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
			#f]
		)))

;;Done
(define check-else-clause
	(lambda (v)
	(cond
		[(pair? v)
			(check-expression (else-clause-1 v))]
		[else
			#f]
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
			(check-else-clause (car v))]
		[(pair? v)
			(and (check-case-clause (car v))
					 (check-case-clauses (cdr v)))]
		[else
			#f]
		)))

;;TODO hmmmm
(define check-case-clause
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 2)
			(and (check-quotations (case-clause-0 v))
					 (check-expression (case-clause-1 v)))]
		[else
			#f]
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
			#f]
		)))

;;Done
(define check-let-expression
	(lambda (bindings exp)
		(and (check-let-bindings bindings)
				 (check-expression exp)
)))

;;Done
(define check-let-bindings
	(lambda (v)
	(cond
		[(null? v)
			#t]
		[(pair? v)
			(and (check-let-binding (car v))
					 (check-let-bindings (cdr v)))]
		[else
			#f]
		)))

;;Done
(define check-let-binding
	(lambda (v)
		(and (check-variable (let-binding-0 v)) (check-expression (let-binding-1 v))
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
			#f]
		)))

;;Done
(define check-letstar-binding
	(lambda (v)
	(and (check-variable (letstar-binding-0 v)) (check-expression (letstar-binding-1 v))
)))

;;Done
(define check-letrec-expression
	(lambda (bindings exp)
			(and (check-letrec-bindings bindings)
			 		 (check-expression exp))))

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
			#f]
		)))

;;Done
(define check-letrec-binding
	(lambda (v)
		(and (check-variable (letrec-binding-0 v)) (check-lambda-abstraction (letrec-binding-1 v)))))

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

		[else #f])))

;;Done
(define check-lambda-abstraction
	(lambda (v)
	(cond
		[(proper-list-of-given-length? v 3)
			(and (check-lambda-formals (list-ref v 1))
					 (check-expression (list-ref v 2)))]
		[(proper-list-of-given-length? v 4)
			(and (check-variable (list-ref v 1))
				 	 (check-lambda-formals (list-ref v 2))
					 (check-expression (list-ref v 3)))]
		[else
			#f]
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
			#f]
		)))

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