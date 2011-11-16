#lang racket/base

(require rackunit "../pipe.rkt")

(test-equal? "1 expr 1 value" (->> 3333) 3333)

(test-equal? "2 expr 2 value pipe" (->> (values "<<~a>>" 1234)
                                        (format (string-append "{" <> "}") <>))
             "{<<1234>>}")

(test-equal? "2 expr 1 value pipe" (->> "1234" (format "{~a}" <>)) "{1234}")

(test-equal? "multiple expr multiple value pipe"
             (->> (values 1 2 3 4)
                  (values <> (+ <> <> <>))
                  (let ([a <>] [b <>])
                    (- b a))
                  (format "<~a>" <>))
             "<8>")

(test-equal? "non-sexp final arg" (->> 1 <>) 1)

(define x
  (->>* (values <> (+ <> <> <>))
        (let ([a <>] [b <>])
          (- b a))
        (format "<~a>" <>)))

(test-equal? "function multiple expr multiple value pipe" (x 1 2 3 4) "<8>")

(test-equal? "function no args" ((->>* "<8>")) "<8>")