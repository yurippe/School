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
