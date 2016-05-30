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
