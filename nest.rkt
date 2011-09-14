#lang racket/base

(require (for-syntax syntax/parse racket/base))

(begin-for-syntax
  (define-syntax-class nest-body
    (pattern (x) #:with nested #`x)
    (pattern ((n ...) . rest:nest-body) #:with nested #`(n ... rest.nested))))

(define-syntax ($ stx)
  (syntax-parse stx
    [($) (raise-syntax-error '$ "error empty body provided, 1 or more elements required")]
    [($ . body:nest-body) (syntax/loc stx body.nested)]))

(provide $)