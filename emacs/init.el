;; Fix Garbage Collection
(setq gc-cons-threshold 402653184
gc-cons-percentage 0.6)

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/reset-gc)

;; Setup package manager and add melpa
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Use use-package
(unless (package-installed-p 'use-package)
       (package-refresh-contents)
       (package-install 'use-package))

;; Ensure that spacemacs theme is installed on any system that this config goes to
(unless (package-installed-p 'spacemacs-theme)
  (package-refresh-contents)
  (package-install 'spacemacs-theme))

;; Load my config from config.org
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
   (quote
    (clang-format column-enforce-mode highlight-indent-guides hilight-indent-guides hilight-indent-guides-mode auctex markdown-mode robe enh-ruby-mode org-evil evil-magit magit slime-company slime company-irony-c-headers rtags irony company-irony company-c-headers shackle company flycheck yasnippet delight hungry-delete diminish linum-relative linum-relitive rainbow-delimiters rainbow-mode org-bullets evil-leader spacemacs-theme evil which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "PfEd" :family "hack")))))
