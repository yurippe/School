;;;;;;;;;;;;;;;;;;;
;;Help Methods
;;;;;;;;;;;;;;;;;;;
(define proper-list-of-given-length?
  (lambda (v n)
    (or (and (null? v)
             (= n 0))
        (and (pair? v)
             (> n 0)
             (proper-list-of-given-length? (cdr v)
                                           (1- n))))))

(define make-literal
  (lambda (n)
    (list 'literal n)))

(define make-plus
  (lambda (e1 e2)
    (list 'plus e1 e2)))

(define make-times
  (lambda (e1 e2)
    (list 'times e1 e2)))

(define is-literal?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'literal)
         (proper-list-of-given-length? (cdr v) 1))))

(define is-plus?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'plus)
         (proper-list-of-given-length? (cdr v) 2))))

(define is-times?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'times)
         (proper-list-of-given-length? (cdr v) 2))))

(define literal-1
  (lambda (v)
    (list-ref v 1)))

(define plus-1
  (lambda (v)
    (list-ref v 1)))

(define plus-2
  (lambda (v)
    (list-ref v 2)))

(define times-1
  (lambda (v)
    (list-ref v 1)))

(define times-2
  (lambda (v)
    (list-ref v 2)))

(define make-PUSH
  (lambda (n)
    (list 'PUSH n)))

(define make-ADD
  (lambda ()
    (list 'ADD)))

(define make-MUL
  (lambda ()
    (list 'MUL)))

(define PUSH-1
  (lambda (v)
    (list-ref v 1)))

(define is-PUSH?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'PUSH)
         (proper-list-of-given-length? (cdr v) 1))))

(define is-ADD?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'ADD)
         (proper-list-of-given-length? (cdr v) 0))))

(define is-MUL?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'MUL)
         (proper-list-of-given-length? (cdr v) 0))))

(define make-byte-code-program
  (lambda (is)
    (list 'byte-code-program is)))

(define is-byte-code-program?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'byte-code-program)
         (proper-list-of-given-length? (cdr v) 1))))

(define byte-code-program-1
  (lambda (v)
    (list-ref v 1)))


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


;;;;;;;;;;;;;;;;;;;
;;Exercise 9
;;;;;;;;;;;;;;;;;;;

;;;;;;;
;;9a)
;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Accessors for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define minus-1
  (lambda (v)
    (list-ref v 1)))
(define minus-2
  (lambda (v)
    (list-ref v 2)))
(define quotient-1
  (lambda (v)
    (list-ref v 1)))
(define quotient-2
  (lambda (v)
    (list-ref v 2)))
(define remainder-1
  (lambda (v)
    (list-ref v 1)))
(define remainder-2
  (lambda (v)
    (list-ref v 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Constructors for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define make-minus
  (lambda (e1 e2)
    (list 'minus e1 e2)))
(define make-quotient
  (lambda (e1 e2)
    (list 'quotient e1 e2)))
(define make-remainder
  (lambda (e1 e2)
    (list 'remainder e1 e2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Predicates for the source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define is-minus?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'minus)
         (proper-list-of-given-length? (cdr v) 2))))
 (define is-quotient?
   (lambda (v)
     (and (pair? v)
          (equal? (car v) 'quotient)
          (proper-list-of-given-length? (cdr v) 2))))
(define is-remainder?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'remainder)
         (proper-list-of-given-length? (cdr v) 2))))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;Constructors for target language (Byte-code programs)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (define make-SUB
   (lambda ()
     (list 'SUB)))
 (define make-QUO
   (lambda ()
     (list 'QUO)))
 (define make-REM
   (lambda ()
     (list 'REM)))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;Predicates for target language (Byte-code programs)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (define is-SUB?
   (lambda (v)
     (and (pair? v)
          (equal? (car v) 'SUB)
          (proper-list-of-given-length? (cdr v) 0))))
(define is-QUO?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'QUO)
         (proper-list-of-given-length? (cdr v) 0))))
(define is-REM?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'REM)
         (proper-list-of-given-length? (cdr v) 0))))


;;;;;;;
;;9b)
;;;;;;;

;;
;; I guess this qualifies as exercise 63
;;
(define make-random-arithmetic-expression
  (lambda (n)
    (letrec (
      [getnegative (lambda ()
        (if (equal? (random 2) 0)
            #t
            #f))]
      [getrandliteral (lambda ()
        (if (getnegative)
            (make-literal (- -1 (random 100))) ;avoid 0s
            (make-literal (+ 1 (random 100)))) ;avoid 0s
      )]
      [getrandnonliteral (lambda (n)
      (let ([r (random 5)])
        (cond
          [(zero? n)
            (getrandliteral)]
          [(equal? r 4)
            (make-times (getrandnonliteral (- n 1)) (getrandnonliteral (- n 1)))
          ]
          [(equal? r 3)
            (make-plus (getrandnonliteral (- n 1)) (getrandnonliteral (- n 1)))
          ]
          [(equal? r 2)
            (make-minus (getrandnonliteral (- n 1)) (getrandnonliteral (- n 1)))
          ]
          [(equal? r 1)
            (make-quotient (getrandnonliteral (- n 1)) (getrandnonliteral (- n 1)))
          ]
          [(equal? r 0)
            (make-remainder (getrandnonliteral (- n 1)) (getrandnonliteral (- n 1)))
          ]
          [else (getrandliteral)])
      )
      )])
      (getrandnonliteral n)
      )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Well formed Arithmetic expressions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define ae0 (make-literal 42))
(define ae1 (make-plus (make-literal 1) (make-literal 10)))
(define ae2 (make-plus ae1 (make-plus (make-literal 100) (make-literal 1000))))
(define ae3
  (make-times
    (make-times
      (make-times
        (make-literal 1)
        (make-literal 2))
      (make-literal 3))
    (make-times
      (make-literal 4)
      (make-literal 5))))

(define ae4 '(times (quotient (literal 69) (literal -69)) (quotient (literal 18) (literal -10))))
(define ae5 '(times (times (literal -40) (literal -44)) (remainder (literal 60) (literal -58))))
(define ae6 '(plus (literal -44) (literal -31)))
(define ae7 '(remainder (quotient (quotient (times (literal -73) (literal -5)) (times (literal 46) (literal -59))) (quotient (times (literal 55) (literal -10)) (remainder (literal -46) (literal -31)))) (times (minus (times (literal 21) (literal -32)) (minus (literal 97) (literal -25))) (remainder (times (literal 90) (literal -68)) (minus (literal -33) (literal 72))))))
(define ae8 '(minus (literal -52) (literal 70)))

;;;;;;;Should give Exception in quotient: undefined for 0;;;;;
(define bae1 '(quotient (minus (plus (literal -60) (literal 13)) (times (literal 78) (literal -34))) (quotient (quotient (literal -56) (literal -75)) (minus (literal -72) (literal -57)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Well formed Byte code porgrams (p's are valid for the VM q's aren't)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define p0 (make-byte-code-program '((PUSH 42))))
(define p1 (make-byte-code-program '((PUSH 20) (PUSH 22) (ADD))))

(define q0 (make-byte-code-program '((PUSH 1) (PUSH 2))))
(define q1 (make-byte-code-program '((PUSH 1) (ADD))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ill formed Byte code porgrams (p's are valid for the VM q's aren't)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define z0 '())
(define z1 (make-byte-code-program '((PUSH 42) . whatever)))
(define z2 (make-byte-code-program '((ADD 42))))
(define z3 (make-byte-code-program '((PUSH "42"))))
(define z4 (make-byte-code-program '((PUSH 0) (PUSH 1/2) (ADD))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Positive tests for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Syntax
(define test-check-arithmetic-expression
  (lambda (candidate)
    (and (candidate ae0)
         (candidate ae1)
         (candidate ae2)
         (candidate ae3)
         (candidate ae4)
         (candidate ae5)
         (candidate ae6)
         (candidate ae7)
         (candidate ae8)
         (candidate bae1)
         (candidate (make-random-arithmetic-expression 5))
         )))

;(test-check-arithmetic-expression check-arithmetic-expression)
;#t

;;VM
(define test-interpret-arithmetic-expression
  (lambda (candidate)
    (and (= (candidate ae0) 42)
         (= (candidate ae1) 11)
         (= (candidate ae2) 1111)
         (= (candidate ae3) 120)
         (= (candidate ae4) 1)
         (= (candidate ae5) 3520)
         (= (candidate ae4) -75)
         (= (candidate ae4) 0)
         (= (candidate ae4) -122)
         )))
;(test-interpret-arithmetic-expression interpret-arithmetic-expression)
;#t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Positive tests for target language (Byte-code programs)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Syntax
(define test-check-byte-code-programs
  (lambda (candidate)
    (and (candidate p0)
         (candidate p1)
         (candidate q0)
         (candidate q1)
         ;;; add more tests here
         )))
;(test-check-byte-code-programs check-byte-code-program)
;#t

;;VM
(define test-run-byte-code-programs
  (lambda (candidate)
    (and (= (candidate p0) 42)
         (= (candidate p1) 42)
         ;;; add more tests here
         )))
;(test-run-byte-code-programs run-byte-code-program)
;#t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Negative tests for target language (Byte-code programs)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define test-check-byte-code-programs-negatively
  (lambda (candidate)
    (not (or (candidate z0)
             (candidate z1)
             (candidate z2)
             (candidate z3)
             (candidate z4)
             ))))

;(test-check-byte-code-programs-negatively check-byte-code-program)
;>#t


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Additional help methods
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define compile-and-run-arithmetic-expression
  (lambda (e)
    (run-byte-code-program
       (compile-arithmetic-expression
         e))))

(define test-commutation-for-arithmetic-expressions
  (lambda (e)
    (let ([result-1 (interpret-arithmetic-expression e)]
          [result-2 (compile-and-run-arithmetic-expression e)])
      (if (equal? result-1 result-2)
          (list #t result-1)
          (list #f result-1 result-2)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Test relative correctness:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define test-single-relative-correctness
  (lambda (expr)
    (let ([result (test-commutation-for-arithmetic-expressions expr)])

      (if (car result)
          (begin (printf "~s~nPASSED~n~n" expr) #t)
          (begin (printf "~s~nDID NOT PASS~n~n") #f)))))

(define test-relative-correctness
  (lambda ()
    (and
      (test-single-relative-correctness  ae1)
      (test-single-relative-correctness  ae2)
      (test-single-relative-correctness  ae3)
      (test-single-relative-correctness  ae4)
      (test-single-relative-correctness  ae5)
      (test-single-relative-correctness  ae6)
      (test-single-relative-correctness  ae7)
      (test-single-relative-correctness  ae8))))
;(test-relative-correctness)
;>#t

(define test-random-relative-correctness
  (lambda (times)
    (if (zero? times)
      #t
      (let ([expr (make-random-arithmetic-expression (random 7))])

(begin (printf "~s" expr)

        (let ([result (test-commutation-for-arithmetic-expressions expr)])
          (if (car result)
            (test-relative-correctness (- times 1))
            (begin (printf 'test-relative-correctness "Failed for expression: ~s~n" expr) #f)
        ))))))
)


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


;;;;;;;;;;;;;;;;;;;
;;Exercise 17
;;;;;;;;;;;;;;;;;;;
(define andmap1
  (lambda (p vs)
    (letrec ([visit (lambda (ws)
                      (if (null? ws)
                          #t
                          (and (p (car ws))
                               (visit (cdr ws)))))])
      (visit vs))))

(define and-all-original
  (lambda bs_init
    (letrec ([visit (lambda (bs)
                      (or (null? bs)
                          (and (car bs)
                               (visit (cdr bs)))))])
      (visit bs_init))))
;;a)
;TODO write test-and-all
;b)
(define and-all
  (lambda stuff (andmap1 (lambda (p) p) stuff)))

;c)
;(test-and-all and-all-original)
;>#t

;(test-and-all and-all)
;>#t


;;;;;;;;;;;;;;;;;;;
;;Exercise 25
;;;;;;;;;;;;;;;;;;;

(define curry3
  (lambda (p)
    (lambda (x1)
      (lambda (x2)
        (lambda (x3)
          (p x1 x2 x3))))))

(define uncurry3
  (lambda (p)
    (lambda (x1 x2 x3)
      (((p x1) x2) x3))))


;;;;;;;;;;;;;;;;;;;
;;Exercise 29
;;;;;;;;;;;;;;;;;;;

;;a) (fold-right_nat 0 1+)
(lambda (n)
  (letrec ([visit
            (lambda (i)
              (if (zero? i)
                  0
                  (1+ (visit (- i 1)))))])
    (visit n)))
;adds 1 to n-1
;;just returns n

;;b) (fold-left_nat 0 1+)
(lambda (n)
  (letrec ([visit
            (lambda (i a)
              (if (zero? i)
                  a
                  (visit (- i 1) (1+ a))))])
    (visit n 0)))
;adds 1 to n-1
;;just returns n

;;c) (lambda (n) ((fold-right_nat n 1+) n))
(lambda (n)
  (letrec ([visit
            (lambda (i)
              (if (zero? i)
                  n
                  (1+ (visit (- i 1)))))])
    (visit n)))
;adds 1 to n, n times
;implements (* 2 n)

;;d) (lambda (n) ((fold-left_nat n 1+) n))
(lambda (n)
  (letrec ([visit
            (lambda (i a)
              (if (zero? i)
                  a
                  (visit (- i 1) (1+ a))))])
    (visit n n)))
;adds 1 to n, n times
;implements (* 2 n)

 ;;e) (fold-right_proper-list '() cons)
 (lambda (vs)
   (letrec ([visit (lambda (ws)
                     (if (null? ws)
                         '()
                         (cons (car ws)
                               (visit (cdr ws)))))])
     (visit vs)))
;just returns vs

;;f) (fold-left_proper-list '() cons)
(lambda (vs)
  (letrec ([visit (lambda (ws a)
                    (if (null? ws)
                        a
                        (visit (cdr ws) (cons (car ws) a))))])
    (visit vs '())))
;returns vs reversed

;;g) (lambda (xs) ((fold-right_proper-list xs cons) xs))
(lambda (xs)
  (letrec ([visit (lambda (ws)
                    (if (null? ws)
                        xs
                        (cons (car ws)
                              (visit (cdr ws)))))])
    (visit xs)))
;;returns (append xs xs)

;;h) (lambda (xs) ((fold-left_proper-list xs cons) xs))
(lambda (xs)
  (letrec ([visit (lambda (ws a)
                    (if (null? ws)
                        a
                        (visit (cdr ws) (cons (car ws) a))))])
    (visit xs xs)))
;;returns (append (reverse xs) xs)


;;;;;;;;;;;;;;;;;;;
;;Exercise 46
;;;;;;;;;;;;;;;;;;;

;;Mystery-1 gives the first element of a proper list (does not work for an empty list)
;;I'd name it 1st

;;Mystery-2 returns (cdr v)
;;I'd name it Rem (aining)

;;All in all, (cons (mystery-1 <list>) (mystery-2 <list>)) = <list>


;;;;;;;;;;;;;;;;;;;
;;Exercise 48
;;;;;;;;;;;;;;;;;;;

(define negative-test-try-candidate-variadically
  (lambda (candidate)
    (and-all (candidate '+ + 0 1 2)
             (candidate '+ + 0 1 2 3)
             (candidate '* * 0)
             (candidate '* * 0 2)
             (candidate '* * 0 2 3)
             (candidate '* * 0 1 2 3)
             (candidate '* * 0 1 2 3 4 5)
             ;;;
             )))

(define silent-try
  #f)

(define try-candidate-variadically
  (lambda (name candidate expected-output . input)
    (let ([result (apply candidate input)])
    (or (equal? result
                expected-output)
        (begin
          (unless silent-try
            (printf "~s: error for ~s~nGot: ~s Expected: ~s~n" name input result expected-output))
          #f)))))

;(negative-test-try-candidate-variadically try-candidate-variadically)

;Am I satisfied: Yes I guess


;;;;;;;;;;;;;;;;;;;;;;
;;Exercise 64 Summary
;;;;;;;;;;;;;;;;;;;;;;

;a)

;Mathematicians can be subdivided into two types: the problem solvers and
;the theorizers. The problem solver likes to take on very difficult challenges
;and solve them, but once solved, he has no interest in it anymore.
;The theorizers likes to find ways to trivialize mathematics. They want to
;perfect current solutions, and they only care about definitions.

;b)

;I would say this applies to computer scientists, as either you like to implement
;or you like to design algorithms. At least to the same degree Rota thinks of it.

;c)

;It is 1:22 am and I can't think of any ;)


