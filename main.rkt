#lang racket/gui

;;; Following: http://docs.racket-lang.org/gui/windowing-overview.html
;;; and: http://www.cs.unb.ca/~bremner/teaching/cs3613/tutorials/tutorial9/

(define frame (new frame% [label "Chapbook"]
                          [width 500]
                          [height 500]))

;; Useful for debugging:
;; (send msg set-label "waddup")
;; (define msg (new message%
;;                  [parent frame]
;;                  [label "Nothing yet"]))

;; see: http://docs.racket-lang.org/gui/horizontal-panel_.html
(define panel (new horizontal-panel% [parent frame]))

;;; From: http://docs.racket-lang.org/gui/editor-overview.html
(define editor (new text%))

;;; TODO: move these to a module!
(define is-markdown-filename?
  (λ (filename)
    (regexp-match #rx".*\\.md$" filename)))

(define (get-markdown-files [project (current-directory)])
  (filter is-markdown-filename? (directory-list project)))

(define as-titles
  (λ (paths)
    (let ([remove-extension (λ (name)
                              (string-replace name ".md" ""))])
        (map (compose string-titlecase
                      remove-extension
                      path->string)
             paths))))

;; see: http://docs.racket-lang.org/gui/control-event_.html
;; (callbacks always get the component and the event)
(define open-file-in-editor
  (λ (component event)
    (if (member (send event get-event-type)
                '(list-box-dclick list-box))
        (send editor load-file
              (send component get-string-selection)
              'text)
        #f)))

;; First child of `panel`, will be aligned to the left.
;; see: http://docs.racket-lang.org/gui/list-box_.html
(define project-files (new list-box%
                           [label "Project Name"]
                           [choices (map path->string (get-markdown-files))]
                           [parent panel]
                           [callback open-file-in-editor]
                           [style '(vertical-label single)]
                           [min-width 150]
                           [stretchable-width #f]))


;;; From: http://docs.racket-lang.org/gui/editor-overview.html
;; second child of `panel`, will be aligned to the right
(define canvas (new editor-canvas%
                    [parent panel]
                    [min-width 350]))

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
                    [callback (λ (x y)
                                (send editor save-file "test.md"))]))
(send editor set-max-undo-history 100)

; Show the frame by calling its show method
(send frame show #t)

