(defconst dot-emacs (concat (getenv "HOME") "/" ".emacs.tlh.el")
    "My dot emacs file")

(require 'bytecomp)
(setq compiled-dot-emacs (byte-compile-dest-file dot-emacs))

(if (or (not (file-exists-p compiled-dot-emacs))
	(file-newer-than-file-p dot-emacs compiled-dot-emacs)
        (equal (nth 4 (file-attributes dot-emacs)) (list 0 0)))
    (load dot-emacs)
  (load compiled-dot-emacs))

(add-hook 'kill-emacs-hook
          '(lambda () (and (file-newer-than-file-p dot-emacs compiled-dot-emacs)
                           (byte-compile-file dot-emacs))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bm-face ((((class color) (background dark)) (:background "#00004AA652F1" :foreground "Black"))))
 '(ido-subdir ((t (:foreground "DarkOliveGreen3")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4be7116df821c19aa761d7befc70a57f6774ec7393582e7d930bc2d5a28a17e8" default)))
 '(server-done-hook (quote ((lambda nil (kill-buffer nil)) delete-frame)))
 '(server-switch-hook (quote ((lambda nil (let (server-buf) (setq server-buf (current-buffer)) (bury-buffer) (switch-to-buffer-other-frame server-buf)))))))
