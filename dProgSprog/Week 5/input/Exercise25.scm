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
