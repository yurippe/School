;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 11
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define test-merge-streams
  (lambda (candidate)
    (and (equal? (stream-head (candidate stream-of-even-natural-numbers
                                         stream-of-odd-natural-numbers)
                              10)
                 '(0 1 2 3 4 5 6 7 8 9))
         (equal? (stream-head (candidate stream-of-odd-natural-numbers
                                         stream-of-even-natural-numbers)
                              10)
                 '(1 0 3 2 5 4 7 6 9 8))

         (equal? (stream-head (candidate (make-stream 0 (lambda (n) n)) (make-stream 1 (lambda (n) n))) 10)
                '(0 1 0 1 0 1 0 1 0 1))

        (equal? (stream-head (candidate (make-stream 1 (lambda (n) n)) (make-stream 0 (lambda (n) n))) 10)
                '(1 0 1 0 1 0 1 0 1 0))
         )))

;;;;;
; a)
;;;;;
(define merge-streams
  (lambda (s1 s2)
    (letrec ([f (lambda (first second)

      (cons (car first) (lambda () (f second ((cdr first)))))

    )])
    (f s1 s2)
    )))

;(test-merge-streams merge-streams)
;>#t

;;;;;
; b)
;;;;;

(define append_stream (lambda streams (car streams)))
;return the first stream, because if the streams are infinite then we dont really care about the rest, since we could never reach them
