#lang racket/gui

(require framework)

;;; GLOBAL STATE, I'M SORRY GOD

(define current-project null)
(define current-file null)

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
;; mixins: https://docs.racket-lang.org/guide/classes.html#%28part._.Mixins%29
;;
(define mixins (compose text:foreground-color-mixin
                        
                        ;;other mixins here: https://docs.racket-lang.org/framework/Text.html?q=font%20color#%28def._%28%28lib._framework%2Fmain..rkt%29._text~3aforeground-color~3c~25~3e%29%29
                        editor:standard-style-list-mixin))
(define editor (new (mixins text:basic%)
                    [auto-wrap #t]))

;;; TODO: move these to a module!
(define is-markdown-filename?
  (λ (filename)
    (regexp-match #rx".*\\.md$" filename)))

(define (get-markdown-files [project (current-directory)])
  (map path->string (filter is-markdown-filename? (directory-list project))))

(define in-project
  (λ (filename)
    (build-path current-project filename)))

;; see: http://docs.racket-lang.org/gui/control-event_.html
;; (callbacks always get the component and the event)
(define open-file-in-editor
  (λ (component event)
    (when (member (send event get-event-type) '(list-box-dclick list-box))
      (let ([filename (send component get-string-selection)])
        (send editor load-file (in-project filename) 'text)
        (set! current-file filename)))))

(define get-user-dir
  (λ ()
    (get-directory "Choose the base directory" frame)))

;; Notice that split-path returns multiple values:
;; see: https://docs.racket-lang.org/reference/Manipulating_Paths.html?q=split-path#%28def._%28%28quote._~23~25kernel%29._split-path%29%29
;; but see: https://stackoverflow.com/a/20556950
(define get-dir-name
  (λ (absolute-path)
    (let-values ([(base name is-dir) (split-path absolute-path)])
      (path->string name))))

(define save-current-file
  (λ (c e)
    (unless (null? current-file)
      (send editor save-file (in-project current-file)))))

;; First child of `panel`, will be aligned to the left.
;; see: http://docs.racket-lang.org/gui/list-box_.html
(define project-files (new list-box%
                           [label "No Project Selected"]
                           [choices '("Open project")]
                           [parent panel]
                           [callback open-file-in-editor]
                           [style '(vertical-label single)]
                           [min-width 150]
                           [stretchable-width #f]))


(define open-project
  (λ (c e)
    (let ([directory (get-user-dir)])
      (when (directory-exists? directory)
        (set! current-project (path->string directory))
        (send project-files set-label (get-dir-name directory))
        (send project-files set (get-markdown-files directory))))))

;;; From: http://docs.racket-lang.org/gui/editor-overview.html
;; second child of `panel`, will be aligned to the right
(define canvas (new editor-canvas%
                    [parent panel]
                    [min-width 350]
                    ;; can be governed by the editor's set-padding
                    ;;[vertical-inset 15]
                    [style '(auto-vscroll auto-hscroll)]))


;; Set some UI default preferences, set editor on canvas.
;; https://docs.racket-lang.org/gui/canvas___.html#%28meth._%28%28%28lib._mred%2Fmain..rkt%29._canvas~3c~25~3e%29._set-canvas-background%29%29
;; and: https://docs.racket-lang.org/draw/color-database___.html?q=color%25

;; for the color: https://tex.stackexchange.com/a/390623
(send canvas set-canvas-background (make-object color% 253 246 227))
;; foreground color: the green of my faber castell moss green ink:
;; https://www.gouletpens.com/products/graf-von-faber-castell-moss-green-75ml-bottled-ink
(editor:set-default-font-color (make-object color%  45 106 73))

;; https://docs.racket-lang.org/gui/text_.html?q=text%25#%28meth._%28%28%28lib._mred%2Fmain..rkt%29._text~25%29._set-padding%29%29
(send editor set-padding
      15 ;; left
      15 ;; top
      ;; right and bottom
      0 0 )
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
                    [callback save-current-file]))
(define m-open-project (new menu-item%
                            [label "Open Project..."]
                            [parent m-file]
                            [shortcut #\o]
                            [callback open-project]))

(send editor set-max-undo-history 100)

; Show the frame by calling its show method
(send frame show #t)

;;; Notes:

;; interesting for saving when there's changes: https://docs.racket-lang.org/framework/Text.html?q=font%20color#%28meth._%28%28%28lib._framework%2Fmain..rkt%29._text~3abasic~3c~25~3e%29._get-edition-number%29%29
