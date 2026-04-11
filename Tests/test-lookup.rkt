#lang racket

(require rackunit "eval.rkt")

(define add
  (lambda (a b)
    (cond ((and (number? a) (number? b)) (+ a b))
          ((and (list? a) (list? b)) (append a b))
          (else (error "unable to add:" a b)))))

(define e1 (map list
                 '(x y z + - * cons car cdr nil list add)
                 (list 10 20 30 + - * cons car cdr '() list add)))

(check =
       (lookup 'x e1)
       10)

(check =
       (lookup 'z e1)
       30)

(check-exn exn:fail?
           (lambda ()
             (lookup 'foo e1)))

(check-exn exn:fail?
           (lambda ()
             (lookup '(z) e1)))

(check =
       (evaluate 'y e1)
       20)