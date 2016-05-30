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
