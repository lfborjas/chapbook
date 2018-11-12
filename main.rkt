#lang racket/gui

;;; Following: http://docs.racket-lang.org/gui/windowing-overview.html
;;; and: http://www.cs.unb.ca/~bremner/teaching/cs3613/tutorials/tutorial9/

(define frame (new frame% [label "Chapbook"]
                          [width 500]
                          [height 500]))

;; (define msg (new message% [parent frame]
;;                  [label "No events so far..."]))

;; (new button% [parent frame]
;;              [label "Click Me"]
;;              ; Callback procedure for a button click:
;;              [callback (lambda (button event)
;;                          (send msg set-label "Button click"))])

;;; From: http://docs.racket-lang.org/gui/editor-overview.html
(define c (new editor-canvas% [parent frame]))
(define t (new text%))
(send c set-editor t)

;; Menus n shit
(define mb (new menu-bar% [parent frame]))
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
(append-editor-operation-menu-items m-edit #t)
(append-editor-font-menu-items m-font)
(send t set-max-undo-history 100)

;; Load a test file:
(send t load-file "test.md" 'text)
 
; Show the frame by calling its show method
(send frame show #t)


