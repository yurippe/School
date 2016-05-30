;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define test-twice-the-stream
  (lambda (candidate)
    (and (equal? (stream-head (candidate stream-of-natural-numbers)
                              10)
                 '(0 2 4 6 8 10 12 14 16 18))
         (equal? (stream-head (candidate stream-of-even-natural-numbers)
                              10)
                 '(0 4 8 12 16 20 24 28 32 36))
         (equal? (stream-head (candidate stream-of-odd-natural-numbers)
                              10)
                 '(2 6 10 14 18 22 26 30 34 38))

         (equal? (stream-head (candidate (candidate stream-of-natural-numbers)) 10)
                 '(0 4 8 12 16 20 24 28 32 36))
         (equal? (stream-head  (candidate (candidate (candidate stream-of-natural-numbers))) 10)
                 '(0 8 16 24 32 40 48 56 64 72))

         (equal? (stream-head  (candidate (make-stream 0 (lambda (n) n))) 10)
                 '(0 0 0 0 0 0 0 0 0 0))
         (equal? (stream-head  (candidate (make-stream 1 (lambda (n) n))) 10)
                 '(2 2 2 2 2 2 2 2 2 2))
         (equal? (stream-head  (candidate (make-stream 2 (lambda (n) n))) 10)
                 '(4 4 4 4 4 4 4 4 4 4))
         )))


 (define twice-the-stream
   (lambda (o-stream)
    (letrec ([current (car o-stream)] [next (cdr o-stream)]

      [modnext (lambda (nxt)
        (lambda () (let ([n (nxt)]) (cons (* 2 (car n)) (modnext (cdr n))))))
      ]

      )
      (cons (* 2 current) (modnext next))
)))

;(test-twice-the-stream twice-the-stream)
;>#t
