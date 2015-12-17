(use extras)
(use srfi-13)
(use srfi-69)

(use combinatorics)

(define (parse-line line)
  (let ((line (string-tokenize line)))
    (list (list-ref line 0)
          (alist->hash-table (list (list (string-trim-both (last line) #\.)
                                         (* (if (equal? (list-ref line 2) "gain") 1 -1)
                                            (string->number (list-ref line 3)))))))))

(define (table-insert ht new-person)
  (hash-table-set! ht
                   (first new-person)
                   (hash-table-merge (hash-table-ref/default ht (first new-person) (make-hash-table))
                                     (second new-person))))

(define (read-from-stdin ht)
  (letrec ((helper (lambda (line ht)
                     (if (or (eof-object? line) (string-null? line))
                       ht
                       (begin
                         (table-insert ht (parse-line line))
                         (helper (read-line) ht))))))
    (helper (read-line) ht)))

(define (view people person on)
  (let* ((feelings-of (hash-table-ref people person))
         (feelings-on (hash-table-ref feelings-of on)))
    (first feelings-on)))

(define (score people person left right)
  (let ((from-left (view people person left))
        (from-rght (view people person right)))
    (+ from-left from-rght)))

(define (left-of person order) 
  (let ((idx (list-index (lambda (p) (equal? p person)) order)))
    (if (eq? idx 0)
      (last order)
      (list-ref order (- idx 1)))))

(define (right-of person order)
  (if (equal? person (last order))
    (first order)
    (list-ref order (+ 1 (list-index (lambda (p) (equal? p person)) order)))))

(define (score-order order feelings)
  (let ((scores (map (lambda (person)
                       (score feelings person (left-of person order) (right-of person order)))
                     order)))
    (fold + 0 scores)))
        
(define (optimal-order feelings)
  (let ((orders (permutation-map (lambda (x) x) (hash-table-keys feelings))))
    (fold max 0 (map (lambda (order) (score-order order feelings)) orders))))

(define (add-me hash)
  (for-each (lambda (p) (table-insert hash (list "Me" (alist->hash-table (list (list p 0))))))
            (hash-table-keys hash))
  (for-each (lambda (p) (table-insert hash (list p (alist->hash-table (list (list "Me" 0))))))
            (hash-table-keys hash)))

(let* ((people (read-from-stdin (make-hash-table)))
       (best   (optimal-order people))
       (withme (begin (add-me people) (optimal-order people))))
  (print "Best: " best)
  (print "Oops: " withme))
