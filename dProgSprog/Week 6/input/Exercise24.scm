;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 24
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; %foo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(%foo x y) checks if x is equal to a tail of y
;This indicates that it should hold for:

;;;;
; (%which () (%foo (list (list 1 2 3) (list 3 2 1)) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;;;;

;because (append (list 1 2 3) (list (list 1 2 3) (list 3 2 1))) = (list 1 2 3 (list 1 2 3) (list 3 2 1))
;and if we do:

;;;;
;(%which (x) (%foo (append (cons x '()) (list (list 1 2 3) (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;;;;

;we would expect the valid x's to be (1 2 3), (2 3) or (3)
;> (%which () (%foo (append (list 3) (list (list 1 2 3) (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;()
;> (%which () (%foo (append (list 2 3) (list (list 1 2 3) (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;()
;> (%which () (%foo (append (list 1 2 3) (list (list 1 2 3) (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;()
;which all works (for some reason this setup does not evaluate well with (%which (x) ...) and (%more), since that only gives (x 3))

;We would also expect

;;;;
;(%which (x) (%foo (append (list 1 2 3) (list x (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;;;;

;to evaluate to ((x (1 2 3))) and (%more) to return #f, which also happens:

;> (%which (x) (%foo (append (list 1 2 3) (list x (list 3 2 1))) (list 1 2 3 (list 1 2 3) (list 3 2 1))))
;((x (1 2 3)))
;> (%more)
;#f


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; %bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(%foo x y) checks if x is equal to a head of y
;This indicates that it should hold for:

;;;;
;(%which (x) (%bar x (list 1 2 3)))
;;;;

;we would expect () (1) (1 2) and (1 2 3) to be valid answers, and indeed:
;> (%which (x) (%bar x (list 1 2 3)))
;((x ()))
;> (%more)
;((x (1)))
;> (%more)
;((x (1 2)))
;> (%more)
;((x (1 2 3)))
;> (%more)
;#f
