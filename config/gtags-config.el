;;; set-gtags.el - settings for gtags.
;;;  
;;; Copyright (C) 2011 Jeffy Du
;;;  
;;; Author: Jeffy Du (cmdxiaoha@163.com)
;;; Create: 2011-12-23 09:55:28
;;; Last Modified: 2011-12-29 17:56:04
;;;  
;;; History:
;;; --------
;;; 2011-12-23  v0.1  Jeffy Du (cmdxiaoha@163.com)
;;;     1. Initial revision.
;;; from https://code.google.com/p/cmdxiaoha-dotemacs/source/browse/trunk/configs/set-gtags.el?r=24

(autoload 'gtags-mode "gtags" "" t)

(defun my-gtags-settings ()
  "Settings for gtags."

  ;; Key bindings.
  (define-prefix-command 'gtags-keymap)
  (define-key global-map (kbd "C-c g") 'gtags-keymap)

  (define-key gtags-mode-map (kbd "C->") 'gtags-find-tag-from-here)
  (define-key gtags-mode-map (kbd "C-<") 'gtags-pop-stack)
  (define-key gtags-mode-map (kbd "C-c g s") 'gtags-find-symbol)
  (define-key gtags-mode-map (kbd "C-c g t") 'gtags-find-tag)
  (define-key gtags-mode-map (kbd "C-c g r") 'gtags-find-rtag)
  (define-key gtags-mode-map (kbd "C-c g p") 'gtags-find-file)
  (define-key gtags-mode-map (kbd "C-c g v") 'gtags-visit-rootdir)
  (define-key gtags-mode-map [mouse-2] 'my-gtags-find-tag-by-event)
  (define-key gtags-mode-map [mouse-3] 'gtags-pop-stack)

  (define-key gtags-select-mode-map (kbd "n") 'next-line)
  (define-key gtags-select-mode-map (kbd "p") 'previous-line)
  (define-key gtags-select-mode-map (kbd "RET") 'gtags-select-tag)
  (define-key gtags-select-mode-map (kbd "C-<") 'gtags-pop-stack)
  (define-key gtags-select-mode-map (kbd "C->") 'gtags-select-tag)
  (define-key gtags-select-mode-map (kbd "q") 'gtags-pop-stack)
  (define-key gtags-select-mode-map [mouse-2] 'gtags-select-tag-by-event)
  (define-key gtags-select-mode-map [mouse-3] 'gtags-pop-stack)

  ;; Highlight gtags item line.
  (add-hook 'gtags-select-mode-hook '(lambda () (hl-line-mode 1)))

  ;; Update gtags data after save file.
  (defun gtags-update ()
    "Update gtags data."
    (interactive)
    (start-process "gtags-update" nil "global" "-u"))
  (add-hook 'after-save-hook 'gtags-update)

  ;; find tag by event support file-tag.
  (defun my-gtags-find-tag-by-event (event)
    "Get the expression as a tagname or filename around here and move there."
    (interactive "e")
    (let (tagname flag)
      (if (= 0 (count-lines (point-min) (point-max)))
          (progn (setq tagname "main")
                 (setq flag ""))
        (if gtags-running-xemacs
            (goto-char (event-point event))
          (select-window (posn-window (event-end event)))
          (set-buffer (window-buffer (posn-window (event-end event))))
          (goto-char (posn-point (event-end event))))
        (setq tagname (gtags-current-token))
        (if (looking-at (concat tagname "\\.h"))
            (progn (setq tagname (concat tagname ".h"))
                   (setq flag "Po"))
          (setq flag "C")))
      (if (not tagname)
          nil
        (gtags-push-context)
        (gtags-goto-tag tagname flag))))
)

(eval-after-load "gtags"
  '(my-gtags-settings))
