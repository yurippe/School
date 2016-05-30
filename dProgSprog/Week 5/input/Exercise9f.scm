;;;;;;;
;;9f)
;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;VM (target interpreter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define verify-byte-code-program
  (lambda (p)
    (if (is-byte-code-program? p)
        (letrec ([loop (lambda (is n)
                         (cond
                           [(null? is)
                            n]
                           [(pair? is)
                            (let ([i (car is)]
                                  [is (cdr is)])
                              (cond
                                [(is-PUSH? i)
                                 (loop is (1+ n))]
                                [(is-ADD? i)
                                 (and (>= n 2)
                                      (loop is (1- n)))]
                                [(is-MUL? i)
                                 (and (>= n 2)
                                      (loop is (1- n)))]
                                [(is-SUB? i)
                                 (and (>= n 2)
                                      (loop is (1- n)))]
                                [(is-QUO? i)
                                 (and (>= n 2)
                                      (loop is (1- n)))]
                                [(is-REM? i)
                                 (and (>= n 2)
                                      (loop is (1- n)))]
                                [else
                                 (errorf 'verify-byte-code-program
                                         "unrecognized byte code: ~s"
                                         i)]))]
                           [else
                            (errorf 'verify-byte-code-program
                                    "ill-formed list of byte-code instructions: ~s"
                                    is)]))])
          (let ([result (loop (byte-code-program-1 p) 0)])
            (and result
                 (= result 1))))
        (errorf 'verify-byte-code-program
                "not a byte-code program: ~s"
                p))))

(define run-verified-byte-code-program
  (lambda (p)
    (letrec ([loop (lambda (is vs)
                     (if (null? is)
                         vs
                         (let ([i (car is)]
                               [is (cdr is)])
                           (cond
                             [(is-PUSH? i)
                              (loop is
                                    (cons (PUSH-1 i) vs))]
                             [(is-ADD? i)
                              (let* ([operand_2 (car vs)]
                                     [vs (cdr vs)]
                                     [operand_1 (car vs)]
                                     [vs (cdr vs)])
                                (loop is
                                      (cons (+ operand_1 operand_2)
                                            vs)))]
                            [(is-MUL? i)
                             (let* ([operand_2 (car vs)]
                                    [vs (cdr vs)]
                                    [operand_1 (car vs)]
                                    [vs (cdr vs)])
                               (loop is
                                     (cons (* operand_1 operand_2)
                                           vs)))]
                             [(is-SUB? i)
                              (let* ([operand_2 (car vs)]
                                     [vs (cdr vs)]
                                     [operand_1 (car vs)]
                                     [vs (cdr vs)])
                                (loop is
                                      (cons (- operand_1 operand_2)
                                            vs)))]
                              [(is-QUO? i)
                               (let* ([operand_2 (car vs)]
                                      [vs (cdr vs)]
                                      [operand_1 (car vs)]
                                      [vs (cdr vs)])
                                 (loop is
                                       (cons (quotient operand_1 operand_2)
                                             vs)))]
                               [(is-REM? i)
                                (let* ([operand_2 (car vs)]
                                       [vs (cdr vs)]
                                       [operand_1 (car vs)]
                                       [vs (cdr vs)])
                                  (loop is
                                        (cons (remainder operand_1 operand_2)
                                              vs)))]
                             [else
                              (let* ([operand_2 (car vs)]
                                     [vs (cdr vs)]
                                     [operand_1 (car vs)]
                                     [vs (cdr vs)])
                                (loop is
                                      (cons (* operand_1 operand_2)
                                            vs)))]))))])
      (car (loop (byte-code-program-1 p) '())))))

(define run-byte-code-program
  (lambda (p)
    (if (verify-byte-code-program p)
        (run-verified-byte-code-program p)
        (errorf 'run-byte-code-program "not a valid byte code program: ~s" p))))
