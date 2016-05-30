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


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 22
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;
; a)
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;the ground constructors, but with quasiquote and unquote
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; <reference>

(define make-location
  (lambda (natural-number)
    (quasiquote (location (unquote natural-number)))))

;;; <expression>

(define make-constant
  (lambda (literal)
    (quasiquote (constant (unquote literal)))))

(define make-dereference
  (lambda (reference)
    (quasiquote (dereference (unquote reference)))))

(define make-unary-operation
  (lambda (unary-operator expression)
    (quasiquote (unary-operation (unquote unary-operator) (unquote expression)))))

(define make-binary-operation
  (lambda (binary-operator expression_1 expression_2)
    (quasiquote (binary-operation (unquote binary-operator) (unquote expression_1) (unquote expression_2)))))

;;; <command>

(define make-skip
  (lambda ()
    (quasiquote (skip))))

(define make-sequence
  (lambda (command_1 command_2)
    (quasiquote (sequence (unquote command_1) (unquote command_2)))))

(define make-assign
  (lambda (reference expression)
    (quasiquote (assign (unquote reference) (unquote expression)))))

(define make-conditional
  (lambda (expression command_1 command_2)
    (quasiquote (conditional (unquote expression) (unquote command_1) (unquote command_2)))))

(define make-while
  (lambda (expression command)
    (quasiquote (while (unquote expression) (unquote command)))))

(define make-switch
  (lambda (expression switch-clauses command)
    (append (quasiquote (switch (unquote expression)))
            switch-clauses
            (quasiquote ((unquote (quasiquote (otherwise (unquote command)))))))))

;;; <program>

(define make-top
  (lambda (command)
    (quasiquote (top (unquote command)))))


;;;;;
; b) TODO
;;;;;


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exercise 27 / Summary
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Terry Lambert is demonstrating that claiming to have mastered anything is a pretty big
;claim, and that "knowing that you don't actually know everything" is important.
;He thinks that to appeal to other people, one must show humility and willingness to learn,
;rather than claiming to know everything.

;My reply:
;"""
;It is great that you feel confident about your abilities as  programmer, however
;, if you want to appeal to people you should consider not telling anyone that you are
;a programmer, let alone a good one, as most *normal* people consider programmers nerds
;or losers. :(
;
;TL;DR:
;if (you.isAProgrammer):
;   if(! you.talkAbout(somethingElse)):
;      otherPeople.willConsiderAsLoser(you)
;"""


