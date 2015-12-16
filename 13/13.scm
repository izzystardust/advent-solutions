(use extras)
(use srfi-13)
(use srfi-69)

(use combinatorics)

(define *people* (make-hash-table))

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
                     (if (eof-object? line)
                       ht
                       (begin
                         (table-insert ht (parse-line line))
                         (helper (read-line) ht))))))
    (helper (read-line) ht)))
