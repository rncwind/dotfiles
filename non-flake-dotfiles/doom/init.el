;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom! :input

       :completion
       (company
        +childframe)       ; the ultimate code completion backend
       (vertico
        +childframe
        +icons)           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
                                        ;indent-guides     ; highlighted indent columns
       (ligatures
        +hasklig)         ; ligatures and symbols to make your code pretty again
       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       treemacs          ; a project drawer, like neotree but cooler
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       window-select     ; visually switch windows
       workspaces        ; tab emulation, persistence & separate workspaces
       nav-flash
                                        ;(vc-gutter +pretty)

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness
       rotate-text       ; cycle region at point between text candidates
       snippets          ; my elves. They type so I don't have to
                                        ;word-wrap         ; soft wrapping with language-aware indent

       :emacs
       (dired
        +icons
        +ranger)             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       (ibuffer
        +icons)         ; interactive buffer management
       (undo
        +tree)              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       eshell            ; the elisp shell that works everywhere
       vterm             ; the best terminal emulation in Emacs

       :checkers
       (syntax +childframe)              ; tasing you for every semicolon you forget
       (spell
        +flyspell
        +aspell)
       grammar

       :tools
       (debugger
        +lsp)          ; FIXME stepping through code, to help you add bugs
       direnv
       (docker +lsp)
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval
        +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       (lsp
        +peek)               ; M-x vscode
       (magit +forge)             ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       terraform         ; infrastructure as code
       tree-sitter       ; syntax and parsing, sitting in a tree...

       :lang
       (nix +tree-sitter +lsp) ; All other build systems are WRONG
       (haskell +lsp +tree-sitter) ; My beloved
       (cc +lsp)      ; C/C++/Obj-C madness
       data           ; config/data formats
       dhall          ; What if haskell was a config language?
       emacs-lisp     ; drown in parentheses
       (sh +lsp +fish +tree-sitter)      ; she sells (ba|z)sh shells on the C xor
       (python +lsp +pyright +pyenv +tree-sitter +poetry)
       (rust +lsp +tree-sitter)
       (elixir +lsp +tree-sitter)

                                        ; NOTE: Markups
       (latex         ; Paper Machine go BRRRRRRRR
        +lsp
        +viewers
        +latexmk
        +ref
        +fontification)
       (org           ; organize your plain life in plain text
        +attach       ; custom attachment system
        +babel        ; running code in org
        +capture      ; org-capture in and outside of Emacs
        +export       ; Exporting org to whatever you want
        +present      ; Emacs for presentations
        +journal      ; Project notes
        +dragndrop    ; Sometimes, im graphical
        +pandoc       ; Exporting org to something for mortals is useful
        +pretty       ; Bullet points are nicer than stars
        +roam2        ; Notetaking go brrrrrrrrrrrrr
        +gnuplot)     ; Plot graphs
       markdown       ; For when redditors try and talk to me
                                        ; NOTE: Web stuff
       (web
        +lsp
        +tree-sitter) ; <div>Bring back tables</div>
       (javascript
        +lsp
        +tree-sitter)
       (json
        +lsp)         ; Press X
       (yaml
        +tree-sitter
        +lsp)
       (rest +jq)

       :app
       ;;calendar
       ;;emms
       ;;everywhere        ; *leave* Emacs!? You must be joking
       ;;irc               ; how neckbeards socialize
       ;;(rss +org)        ; emacs as an RSS reader
       ;;twitter           ; twitter client https://twitter.com/vnought

       :config
       literate
       (default +bindings +smartparens))
