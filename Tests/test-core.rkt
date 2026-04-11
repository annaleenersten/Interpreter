#lang racket

(require rackunit "eval.rkt")

(define add
  (lambda (a b)
    (cond ((and (number? a) (number? b)) (+ a b))
          ((and (list? a) (list? b)) (append a b))
          (else (error "unable to add" a b)))))

(define e1  (map list
                 '(x y z + - * cons car cdr nil list add = else)
                 (list 10 20 30 + - * cons car cdr '() list add = #t)))

;; basic eval
(check =
       (evaluate 'x e1)
       10)

(check =
       (evaluate '(+ x y) e1)
       30)

(check =
       (evaluate '(+ 3 (- 10 y) z) e1)
       23)

(check =
       (evaluate '(+ x (+ y (+ z 100))) e1)
       160)

(check =
       (evaluate '(* 2 2 2 2 2 (* 2 2 2 2 2)) e1)
       1024)

;; cons / list
(check equal?
       (evaluate '(cons 1 2) e1)
       '(1 . 2))

(check equal?
       (evaluate '(cons 1 (cons 2 (cons 3 nil))) e1)
       '(1 2 3))

(check equal?
       (evaluate '(add 1 2) e1)
       3)

(check equal?
       (evaluate '(add (cons 1 nil) (cons 2 nil)) e1)
       (list 1 2))

(check equal?
       (evaluate '(list 1 2 3) e1)
       (evaluate '(cons 1 (list 2 3)) e1))

;; conditionals
(check =
       (evaluate '(if (= 1 1) 2 3) e1)
       2)

(check =
       (evaluate '(if (= 1 2) 2 3) e1)
       3)

(check =
       (evaluate '(cond ((= 1 2) 1)
                        ((= 2 3) 2)
                        (else 3)) e1)
       3)

;; let
(check =
       (evaluate '(let ((a 1) (b 2)) (+ a b)) e1)
       3)

(check =
       (evaluate '(+ x (let ((x 100)) (+ x y)) x) e1)
       140)

(check =
       (evaluate '(let ((x 10) (a 20))
                    (let ((x (+ 2 2)) (y x) (z (* 3 3)))
                      (+ a x y z))) e1)
       43)

(check =
       (evaluate '(let ((x 10))
                    (+ (let ((x 20)) (+ x x)) x)) e1)
       50)

(check =
       (evaluate '(let ((x 10))
                    (+ (let ((x (+ x x))) (+ x x)) x)) e1)
       50)

;; lambda
(check =
       (evaluate '((lambda (x) (* x x)) 2) e1)
       4)

(check =
       (evaluate '(let ((f (lambda (a) (+ a x))))
                    (f 100)) e1)
       110)

(check =
       (evaluate '(let ((f (let ((x 100))
                              (lambda (a) (+ a x)))))
                    (f x)) e1)
       110)

;; closures
(check equal?
       (evaluate '(let ((f (lambda (a) (lambda (b) (+ a b)))))
                    (let ((g (f 10))
                          (h (f 20)))
                      (list (g 100) (h 100)))) e1)
       '(110 120))

;; letrec + recursion
(check =
       (evaluate '(letrec ((f (lambda (n)
                                (if (= n 0)
                                    1
                                    (* n (f (- n 1)))))))
                    (f 10)) e1)
       (* 10 9 8 7 6 5 4 3 2 1))

(check =
       (evaluate '(letrec ((f (lambda (n)
                                (if (= n 0)
                                    1
                                    (* n (f (- n 1)))))))
                    (let ((factorial (lambda (n) (f n))))
                      (factorial 10))) e1)
       (* 10 9 8 7 6 5 4 3 2 1))

;; extra recursion structures (map/reverse/etc)
(check equal?
       (evaluate
        '(letrec ((map
                   (lambda (f ls)
                     (if (empty? ls)
                         nil
                         (cons (f (car ls))
                               (map f (cdr ls)))))))
           (map (lambda (x) (list x (* 2 x)))
                (list 1 2 3 4))) e1)
       '((1 2) (2 4) (3 6) (4 8)))

(check equal?
       (evaluate
        '(letrec ((f (lambda (n)
                       (cond ((= n 0) 1)
                             (else (* n (f (- n 1))))))))
           (f 10)) e1)
       (* 1 2 3 4 5 6 7 8 9 10))