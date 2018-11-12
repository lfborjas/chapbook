#lang racket/gui

;;; Following: http://docs.racket-lang.org/gui/windowing-overview.html
;;; and: http://www.cs.unb.ca/~bremner/teaching/cs3613/tutorials/tutorial9/

(define frame (new frame% [label "Chapbook"]
                          [width 500]
                          [height 500]))

;;; From: http://docs.racket-lang.org/gui/editor-overview.html
(define canvas (new editor-canvas% [parent frame]))
(define editor (new text%))
(send canvas set-editor editor)

;; Menus n shit
(define mb (new menu-bar% [parent frame]))
(define m-file (new menu% [label "File"] [parent mb]))
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
(append-editor-operation-menu-items m-edit #t)
(append-editor-font-menu-items m-font)
(define m-save (new menu-item%
                    [label "Save"]
                    [parent m-file]
                    [shortcut #\s]
                    [callback (lambda (x y)
                                (send editor save-file "test.md"))]))
(send editor set-max-undo-history 100)

;; Load a test file:
(send editor load-file "test.md" 'text)
 
; Show the frame by calling its show method
(send frame show #t)


