#lang racket/base

(require rackunit "../pipe.rkt")

(test-equal? "1 expr 1 value" 3333 (->> 3333))

(test-equal? "2 expr 2 value pipe" "{<<1234>>}" (->> (values "<<~a>>" 1234)
                                                     (format (string-append "{" <> "}") <>)))

(test-equal? "2 expr 1 value pipe" "{1234}" (->> "1234" (format "{~a}" <>)))

(test-equal? "multiple expr multiple value pipe"
             "<8>"
             (->> (values 1 2 3 4)
                  (values <> (+ <> <> <>))
                  (let ([a <>] [b <>])
                    (- b a))
                  (format "<~a>" <>)))

(define x
  (->>* (values <> (+ <> <> <>))
        (let ([a <>] [b <>])
          (- b a))
        (format "<~a>" <>)))

(test-equal? "function multiple expr multiple value pipe" "<8>" (x 1 2 3 4))

(test-equal? "function no args" "<8>" ((->>* "<8>")))