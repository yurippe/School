;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Help methods and supplied methods  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define force!
  (lambda (thunk)
    (thunk)))

(define stream-head
  (lambda (s_init n_init)
    (letrec ([visit (lambda (s n)
                      (if (zero? n)
                          '()
                          (cons (car s)
                                (visit (force! (cdr s))
                                       (1- n)))))])
      (if (and (integer? n_init)
               (not (negative? n_init)))
          (visit s_init n_init)
          (errorf 'stream-head
                  "not a non-negative integer: ~s"
                  n_init)))))

(define make-stream
  (lambda (seed next)
    (letrec ([produce (lambda (current)
                        (cons current
                              (lambda ()
                                (produce (next current)))))])
      (produce seed))))

(define stream-of-natural-numbers
  (letrec ([produce (lambda (current-natural-number)
                      (cons current-natural-number
                            (lambda ()
                              (produce (1+ current-natural-number)))))])
    (produce 0)))
(define stream-of-even-natural-numbers
  (make-stream 0
               (lambda (n)
                 (+ n 2))))

(define stream-of-odd-natural-numbers
  (make-stream 1
               (lambda (n)
                 (+ n 2))))


(define stream-ref
  (lambda (s_init n_init)
    (letrec ([visit (lambda (s n)
                      (if (zero? n)
                          (car s)
                          (visit (force! (cdr s))
                                 (- n 1))))])
      (if (and (integer? n_init)
               (not (negative? n_init)))
          (visit s_init n_init)
          (errorf 'stream-ref
                  "not a non-negative integer: ~s"
                  n_init)))))
