#lang racket/base

; Note: pipe works on the unexpanded syntax of the input, the values are returned in order of <> appearance

(require (for-syntax syntax/parse racket/syntax racket/list racket/base))

(define-syntax (<> stx) (raise-syntax-error "can only be used in middle or last lines of ->>"))

(begin-for-syntax
  (define-syntax-class atom
    (pattern (~not (n ...))))
  (define-syntax-class nest-body
    (pattern ((n ...)) #:with nested #`(n ...))
    (pattern ((n ...) . rest:nest-body) #:with nested #`(n ... rest.nested)))
  (define-syntax-class maybe-<>
    (pattern (~and x:atom (~literal <>))
             #:with expr (generate-temporary)
             #:attr value (list #'expr))
    (pattern (~and x:atom (~not (~literal <>)))
             #:with expr #'x
             #:attr value null)
    (pattern (n:maybe-<> ...)
             #:attr value (flatten (attribute n.value))
             #:with expr #'(n.expr ...))))

(define-syntax (->> stx)
  (syntax-parse stx
    [(->> first) #`first]
    [(->> first middle:maybe-<> ... last:maybe-<>)
    (with-syntax ([(value ...) (append (attribute middle.value) (list (attribute last.value)))]
                  [(body ...)  #`(first middle.expr ...)])
      (syntax/loc stx
        (let*-values ([value body] ...)
          last.expr)))]))

(define-syntax (->>* stx)
  (syntax-parse stx
    [(->>* first:maybe-<>)
     (with-syntax ([value (attribute first.value)])
       (syntax/loc stx
         (lambda value
           first.expr)))]
    [(->>* first:maybe-<> middle:maybe-<> ... last:maybe-<>)
     (with-syntax ([first-value (attribute first.value)]
                   [(value ...) (append (attribute middle.value) (list (attribute last.value)))]
                   [(body ...)  #`(first.expr middle.expr ...)])
       (syntax/loc stx
         (lambda first-value
           (let*-values ([value body] ...) last.expr))))]))

(provide <> ->> ->>*)