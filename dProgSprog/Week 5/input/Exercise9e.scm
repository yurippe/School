;;;;;;;
;;9e)
;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Compiler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define compile-arithmetic-expression
  (lambda (e_init)
    (letrec ([process (lambda (e)
                         (cond
                          [(is-literal? e)
                           (list (make-PUSH (literal-1 e)))]
                          [(is-plus? e)
                           (append (process (plus-1 e))
                                   (process (plus-2 e))
                                   (list (make-ADD)))]
                          [(is-times? e)
                           (append (process (times-1 e))
                                   (process (times-2 e))
                                   (list (make-MUL)))]
                          [(is-minus? e)
                           (append (process (minus-1 e))
                                   (process (minus-2 e))
                                   (list (make-SUB)))]
                          [(is-quotient? e)
                           (append (process (quotient-1 e))
                                   (process (quotient-2 e))
                                   (list (make-QUO)))]
                          [(is-remainder? e)
                           (append (process (remainder-1 e))
                                   (process (remainder-2 e))
                                   (list (make-REM)))]
                           [else
                            (errorf 'compile-arithmetic-expression
                                    "unrecognized expression: ~s"
                                    e)]))])
      (make-byte-code-program (process e_init)))))
