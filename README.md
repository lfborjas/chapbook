# Chapbook

A very simple, very niche, text editor built in
[Racket](https://racket-lang.org/). 

## Development

I'm working in Emacs with
[racket-mode](https://github.com/greghendershott/racket-mode). My MO is to open
`main.rkt` and just do `C-x C-k` to run it, which spawns the GUI and a REPL, and
then I can interact with it. If you see a bunch of lambdas, it's because I
[enabled a
hook](https://stackoverflow.com/questions/39431240/lambda-is-replace-with-λ-in-racket-mode-emacs)
to turn the word `lambda` into the actual unicode character, which is valid in
racket.

### References

Surprisingly, or maybe _unsurprisingly_, the documentation (which I can invoke
with `C-c C-d` from a racket buffer) is extremely good, albeit sometimes spartan
with the examples. For GUI basics, see:

* https://docs.racket-lang.org/gui/windowing-overview.html
* https://docs.racket-lang.org/gui/editor-overview.html

### Documentation and examples

* https://docs.racket-lang.org/gui/editor-overview.html?q=editors
* <https://docs.racket-lang.org/gui/keymap_.html?q=set-keymap>
* <https://docs.racket-lang.org/gui/text_.html#%28meth._%28%28%28lib._mred%2Fmain..rkt%29._text~25%29._after-insert%29%29>
* <https://docs.racket-lang.org/framework/Color.html?q=spellcheck#%28meth._%28%28%28lib._framework%2Fmain..rkt%29._color~3atext~3c~25~3e%29._get-spell-suggestions%29%29>
* <https://docs.racket-lang.org/guide/serialization.html#%28tech._serialization%29>
* https://github.com/alex-hhh/ActivityLog2/blob/c45d62cb1ab5e79c6717d6a247406d31084e220d/rkt/widgets/notes-input-field.rkt#L61-L69
* https://alex-hhh.github.io/2018/11/an-enhanced-text-field-gui-control-for-racket.html
* https://alex-hhh.github.io/2018/10/chess-game-using-racket-s-pasteboard.html

