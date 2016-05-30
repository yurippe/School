;;;;;;;;;;;;;;;;;;;
;;Exercise 4
;;;;;;;;;;;;;;;;;;;

(define compile-arithmetic-expression-accumulator
        (lambda (e_init)
          (letrec ([process (lambda (e a)
                               (cond
                                 [(is-literal? e)
                                  (cons (make-PUSH (literal-1 e)) a)]
                                 [(is-plus? e)
                                  (process (plus-1 e)
                                    (process (plus-2 e) (cons (make-ADD) a)))
                                 ]
                                 [(is-times? e)
                                  (process (times-1 e)
                                    (process (times-2 e) (cons (make-MUL) a)))
                                 ]
                                 [else
                                  (errorf 'compile-arithmetic-expression
                                          "unrecognized expression: ~s"
                                          e)]))])
            (make-byte-code-program (process e_init '())))))
;;b) The version with the accumulator is more efficient, since it does not make
;;big intermediate lists in every stack frame / call frame. Also using cons is
;;more efficient than using append.
