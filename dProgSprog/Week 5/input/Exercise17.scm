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
