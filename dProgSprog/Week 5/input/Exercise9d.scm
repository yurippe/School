;;;;;;;
;;9d)
;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Source interpreter (Arithmetic expression interpreter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define interpret-arithmetic-expression
  (lambda (e_init)
    (letrec ([process (lambda (e)
                        (cond
                          [(is-literal? e)
                           (literal-1 e)]
                          [(is-plus? e)
                           (+ (process (plus-1 e))
                              (process (plus-2 e)))]
                         [(is-times? e)
                          (* (process (times-1 e))
                             (process (times-2 e)))]
                         [(is-minus? e)
                          (- (process (minus-1 e))
                             (process (minus-2 e)))]
                         [(is-quotient? e)
                          (quotient (process (quotient-1 e))
                                    (process (quotient-2 e)))]
                         [(is-remainder? e)
                          (remainder (process (remainder-1 e))
                                     (process (remainder-2 e)))]
                         [else
                          (errorf 'interpret-arithmetic-expression
                                  "unrecognized expression: ~s"
                                  e)]))])
      (process e_init))))
