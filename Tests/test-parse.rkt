#lang racket

(require rackunit "parse.rkt" "eval.rkt")

;; mini test:
(define e2 (list (list '+ +)))

(check equal?
       (parse "(+ 1 2)")
       '((+ 1 2)))

(check equal?
       (map (lambda (exp) (evaluate exp e2))
            (parse "(+ 1 2)"))
       '(3))

;; parsing tests

(check equal?
       (parse "1234")
       '(1234))

(check equal?
       (parse "1234 5678")
       '(1234 5678))

(check equal?
       (parse "fubar")
       '(fubar))

(check equal?
       (parse "(1 2 3)")
       '((1 2 3)))

(check equal?
       (parse "(cons a b)")
       '((cons a b)))

(check equal?
       (parse "()")
       '(()))

(check equal?
       (parse "(cons (+ 1 2) (list 3 4 5))")
       '((cons (+ 1 2) (list 3 4 5))))

(check equal?
       (parse
        "(let ((f (lambda (a) (lambda (b) (+ a b)))))
                    (let ((g (f 10))
                          (h (f 20)))
                      (list (g 100) (h 100))))")
       '((let ((f (lambda (a) (lambda (b) (+ a b)))))
           (let ((g (f 10))
                 (h (f 20)))
             (list (g 100) (h 100))))))