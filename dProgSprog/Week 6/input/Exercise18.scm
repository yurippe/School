;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 18
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Call by value:
;;;;;;;;;;;;;;;;;
;when we try to execute the line

;(define my-list-of-nats
;            (make-a-list-of-nats 0))

;it loops infinitly, because in the method make-a-list, (produce (next current))
;is evaluated and it has no stop condition, so it will just loop on forever


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Call by name:
;;;;;;;;;;;;;;;;;

;we get the following output:
;> (load "interpreter-for-Scheme-with-call-by-name.scm")
;>  (start-the-interpreter "by-name> ")
;There we go again, in call by name.
;by-name> (load "lists.scm")
;by-name> (define my-list-of-nats
;           (make-a-list-of-nats 0))
;by-name> (+ (list-a-ref my-list-of-nats 5)
;            (list-a-ref my-list-of-nats 3))
;producing 0
;producing 1
;producing 2
;producing 3
;producing 4
;producing 5
;producing 0
;producing 1
;producing 2
;producing 3
;8

;This is because every time we actually try to access a value we need to use,
;it will be evaluated, it also does not save the result of this evaluation,
;which is the reason why
;producing 0
;producing 1
;producing 2
;producing 3
;Shows up the second time

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Call by need:
;;;;;;;;;;;;;;;;;

;We get the following output:
;> (load "interpreter-for-Scheme-with-call-by-need.scm")
;> (start-the-interpreter "by-need> ")
;There we go again, in call by need.
;by-need> (load "lists.scm")
;by-need> (define my-list-of-nats
;           (make-a-list-of-nats 0))
;by-need> (+ (list-a-ref my-list-of-nats 5)
;            (list-a-ref my-list-of-nats 3))
;producing 0
;producing 1
;producing 2
;producing 3
;producing 4
;producing 5
;8

;This is because when we dont "need" to evaluate the values before we actually call
;+, but we save the result of the evaluation after we do it the first time.
;Since (list-a-ref my-list-of-nats 5) calculates all we need to know for
;(list-a-ref my-list-of-nats 3), it does not print out any extra lines for this.
;If however we tried to do:

;by-need> (+ (list-a-ref my-list-of-nats 5)
;            (list-a-ref my-list-of-nats 6))
;it would print the lines
;producing 0
;producing 1
;producing 2
;producing 3
;producing 4
;producing 5
;producing 6
;11

;because it would only have to figure out 1 more element, since the other values are
;saved.
