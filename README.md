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
