;; Normal fonts
(setq doom-font (font-spec :family "hasklig" :size 15)
      doom-variable-pitch-font (font-spec :family "hasklig")
      doom-unicode-font (font-spec :family "hasklig")
      doom-big-font (font-spec :family "hasklig" :size 20))

;; Japanese fonts.
(set-fontset-font t 'han  (font-spec :family "IPAGothic" :size 14))
(set-fontset-font t 'kana (font-spec :family "IPAGothic" :size 14))
(set-fontset-font t 'cjk-misc (font-spec :family "IPAGothic" :size 14))

(setq doom-theme 'doom-horizon)

(setq shell-file-name (executable-find "bash"))
; Make vterm use fish as it's interactive shell.
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

(map! :map vertico-map "C-M-RET" #'vertico-exit-input)

(setq rustic-lsp-server 'rust-analyzer)

(add-hook 'rustic-mode-hook (lambda () (setq rustic-indent-offset 4)))

(after! lsp-rust
  (setq lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-cargo-load-out-dirs-from-check t
        lsp-rust-analyzer-cargo-run-build-scripts t))

(setq lsp-rust-analyzer-cargo-watch-command "clippy")

(set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode))

(setq lsp-haskell-plugin-ghcid-type-lenses-config-mode "always")

(c-add-style "rncwnd"
             '("bsd"
               (c-basic-offset . 4)
               (tab-width . 4)
               (c-offsets-alist
                (access-label . --))))
(setq-default c-default-style "rncwnd")

(add-hook 'c++-mode-hook 'yas-minor-mode-on)
(add-hook 'c-mode-hook 'yas-minor-mode-on)

(setq typescript-indent-level 2)

(use-package! lsp-elixir
  :init
  ;; Must be set before lsp-elixir.el loads
  (setf lsp-elixir-ls-version "v0.21.3")
  ;; this can be removed when lsp-mode 8.0.1 or greater is released
  (setf lsp-elixir-ls-download-url
        (format
         "https://github.com/elixir-lsp/elixir-ls/releases/download/%1$s/elixir-ls-%1$s.zip"
         lsp-elixir-ls-version)))

;; Disable spec suggest becuase it's not good.
(setq lsp-elixir-suggest-specs 'nil)

(add-hook 'org-mode-hook 'auto-fill-mode)

(setq org-roam-directory "~/org/brain")
(setq org-download-image-dir "~/org/download-images")
(setq org-attach-id-dir "~/org/attach/id")
(setq org-attach-directory "~/org/attach")

(setq org-roam-capture-templates '(("d" "default" plain "%?" :target
  (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags:\n")
  :unnarrowed t)))

(add-hook 'markdown-mode-hook 'auto-fill-mode)

(add-hook 'latex-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
