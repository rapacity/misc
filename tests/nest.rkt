#lang racket/base

(require rackunit "../nest.rkt")

(test-equal? "nest 1 expr" 1 ($ (begin 1)))

(test-equal? "nest 2 expr " 1 
             ($ (let loop ([x 10]))
                (if (zero? x) 1
                    (loop (sub1 x)))))

(test-equal? "nest 3 expr"
             (list 0 0 2 2)
             ($ (let ([x 4]))
                (for/list ([i x]))
                (if (even? i) i (sub1 i))))