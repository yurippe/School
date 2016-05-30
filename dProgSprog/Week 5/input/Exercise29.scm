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
