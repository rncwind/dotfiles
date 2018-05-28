(map!
 :ne "C-w <right>" #'evil-window-right
 :ne "C-w <left>"  #'evil-window-left
 :ne "C-w <up>"    #'evil-window-up
 :ne "C-w <down>"  #'evil-window-down
 )

(map!
 (:leader
   (:desc "window" :prefix "w"
     :desc "vsplit" :nv "/" #'evil-window-vsplit
     :desc "hsplit" :nv "-" #'evil-window-split)))

(map!
 (:leader
   (:desc "window" :prefix "w"
     :desc "Delete window" :n "d" #'evil-window-delete
     :desc "Kill Win+Buf"  :n "q" #'kill-buffer-and-window)))

(map!
 (:leader
   (:desc "buffer" :prefix "b"
     :desc "Kill Buffer" :n "d" #'kill-this-buffer
     :desc "Kill buffer" :n "q" #'kill-this-buffer)))

(map!
 (:leader
   (:desc "buffer" :prefix "b"
     :desc "Helm buffer list" :n "b" #'helm-buffers-list)))



(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0)
(setq nlinum-relative-current-symbol "")
