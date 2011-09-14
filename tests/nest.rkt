#lang racket/base

(require rackunit "../nest.rkt")

(test-equal? "nest 2 expr " 
             ($ (let loop ([x 10]))
                (if (zero? x) 1
                    (loop (sub1 x))))
             1)

(test-equal? "nest 3 expr"
             ($ (let ([x 4]))
                (for/list ([i x]))
                (if (even? i) i (sub1 i)))
             (list 0 0 2 2))

(test-equal? "no nest, only 1 expr" ($ 1) 1)

(test-equal? "no nest, only 1 expr" ($ (begin 1)) 1)

(test-equal? "no nest, only 1 expr" ($ (+ 50)
                                       (+ 25 25)
                                       (+ -25 -25)
                                       10)
             60)
