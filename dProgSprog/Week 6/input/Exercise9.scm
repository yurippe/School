;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define map1_stream
  (lambda (p vs)
    (letrec ([visit (lambda (ws)
                         (cons (p (car ws))
                               (lambda () (visit ((cdr ws))))))])
      (if (procedure? p)
          (visit vs)
          (errorf 'map1_stream
                  "not a procedure: ~s"
                  p)))))

(define twice-the-stream
  (lambda (s) (map1_stream (lambda (n) (* 2 n)) s)))

;(test-twice-the-stream twice-the-stream)
;>#t
