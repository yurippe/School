;;;;;;;;;;;;;;;;;;;
;;Exercise 9
;;;;;;;;;;;;;;;;;;;

;;;;;;;
;;9a)
;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Accessors for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define minus-1
  (lambda (v)
    (list-ref v 1)))
(define minus-2
  (lambda (v)
    (list-ref v 2)))
(define quotient-1
  (lambda (v)
    (list-ref v 1)))
(define quotient-2
  (lambda (v)
    (list-ref v 2)))
(define remainder-1
  (lambda (v)
    (list-ref v 1)))
(define remainder-2
  (lambda (v)
    (list-ref v 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Constructors for source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define make-minus
  (lambda (e1 e2)
    (list 'minus e1 e2)))
(define make-quotient
  (lambda (e1 e2)
    (list 'quotient e1 e2)))
(define make-remainder
  (lambda (e1 e2)
    (list 'remainder e1 e2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Predicates for the source language (Arithmetic expression)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define is-minus?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'minus)
         (proper-list-of-given-length? (cdr v) 2))))
 (define is-quotient?
   (lambda (v)
     (and (pair? v)
          (equal? (car v) 'quotient)
          (proper-list-of-given-length? (cdr v) 2))))
(define is-remainder?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'remainder)
         (proper-list-of-given-length? (cdr v) 2))))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;Constructors for target language (Byte-code programs)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (define make-SUB
   (lambda ()
     (list 'SUB)))
 (define make-QUO
   (lambda ()
     (list 'QUO)))
 (define make-REM
   (lambda ()
     (list 'REM)))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;Predicates for target language (Byte-code programs)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (define is-SUB?
   (lambda (v)
     (and (pair? v)
          (equal? (car v) 'SUB)
          (proper-list-of-given-length? (cdr v) 0))))
(define is-QUO?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'QUO)
         (proper-list-of-given-length? (cdr v) 0))))
(define is-REM?
  (lambda (v)
    (and (pair? v)
         (equal? (car v) 'REM)
         (proper-list-of-given-length? (cdr v) 0))))
