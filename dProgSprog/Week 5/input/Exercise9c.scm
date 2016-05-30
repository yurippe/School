;;;;;;;
;;9c)
;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Syntax checker for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define check-arithmetic-expression
  (lambda (e)
    (cond
      [(is-literal? e)
       (integer? (literal-1 e))]
      [(is-plus? e)
       (and (check-arithmetic-expression (plus-1 e))
            (check-arithmetic-expression (plus-2 e)))]
      [(is-times? e)
       (and (check-arithmetic-expression (times-1 e))
            (check-arithmetic-expression (times-2 e)))]
      [(is-minus? e)
       (and (check-arithmetic-expression (minus-1 e))
            (check-arithmetic-expression (minus-2 e)))]
      [(is-quotient? e)
       (and (check-arithmetic-expression (quotient-1 e))
            (check-arithmetic-expression (quotient-2 e)))]
      [(is-remainder? e)
       (and (check-arithmetic-expression (remainder-1 e))
            (check-arithmetic-expression (remainder-2 e)))]
      [else
       #f])))
;;TODO verify that they pass the positive and negative unit tests.

;(test-check-arithmetic-expression check-arithmetic-expression)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Syntax checker for target language (Byte-code programs)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define check-byte-code-instruction
  (lambda (v)
    (cond
      [(is-PUSH? v)
       (integer? (PUSH-1 v))]
      [(is-ADD? v)
       #t]
      [(is-MUL? v)
       #t]
      [(is-SUB? v)
        #t]
      [(is-QUO? v)
        #t]
      [(is-REM? v)
        #t]
      [else
       #f])))

(define check-byte-code-program
  (lambda (v)
    (if (is-byte-code-program? v)
        (letrec ([loop (lambda (v)
                         (cond
                           [(null? v)
                            #t]
                           [(pair? v)
                            (and (check-byte-code-instruction (car v))
                                 (loop (cdr v)))]
                           [else
                            #f]))])
          (loop (byte-code-program-1 v)))
        #f)))

;(test-check-byte-code-programs check-byte-code-program)
;#t
