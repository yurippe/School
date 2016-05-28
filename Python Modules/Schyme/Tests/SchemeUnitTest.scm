(define force!
  (lambda (thunk)
    (thunk)))

(define stream-head
  (lambda (s_init n_init)
    (letrec ([visit (lambda (s n)
                      (if (zero? n)
                          (list)
                          (cons (car s)
                                (visit (force! (cdr s))
                                       (1- n)))))])
      (if (and (integer? n_init)
               (not (negative? n_init)))
          (visit s_init n_init)
          (+ 1 1)))))

(define make-stream
  (lambda (seed next)
    (letrec ([produce (lambda (current)
                        (cons current
                              (lambda ()
                                (produce (next current)))))])
      (produce seed))))


(define stream-of-even-natural-numbers
  (make-stream 0
               (lambda (n)
                 (+ n 2))))

 (define twice-the-stream
   (lambda (o-stream)
    (letrec ([current (car o-stream)] [next (cdr o-stream)]

      [modnext (lambda (nxt)
        (lambda () (let ([n (nxt)]) (cons (* 2 (car n)) (modnext (cdr n))))))
      ]

      )
      (cons (* 2 current) (modnext next))
)))
