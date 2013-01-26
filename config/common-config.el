;; setup for the compile command
(setq compile-command "make")
;; setup for switch windows
(global-set-key [(shift up)] 'windmove-up)
(global-set-key [(shift down)] 'windmove-down)
(global-set-key [(shift right)] 'windmove-right)
(global-set-key [(shift left)] 'windmove-left)
;; setup for man pages
(setq woman-manpath '("~/usr/man"))
(global-set-key (kbd "C-c m") 'woman)
;; setup for ido interactive
;; do not confirm a new file or buffer
(setq confirm-nonexistent-file-or-buffer nil)
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
;;(setq ido-enable-tramp-completion nil)
;;(setq ido-enable-last-directory-history t)
(setq ido-confirm-unique-completion nil) ;; wait for RET, even for unique?
;; Rename file and buffer
(defun rename-this-buffer-and-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))
(global-set-key (kbd "C-c r") 'rename-this-buffer-and-file)

;; setup for the color-theme
;; (require 'color-theme)
;; (color-theme-initialize)
;; (load-file "~/.emacs.d/themes/color-theme-blackboard.el")
;; (color-theme-classic);;颜色主题
(put 'set-goal-column 'disabled nil) 
(setq make-backup-files nil)
(setq inhibit-startup-screen t)
;;Set the default font use the M-x set-default-font to select all the fonts
;; Setting English Font
(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))
(defvar font-list '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体")) ;; "Microsoft Yahei"
(require 'cl) ;; find-if is in common list package
(find-if #'qiang-font-existsp font-list)
(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size) 
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))
(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))
    
    ;; Set the default English font
    ;; 
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)
    
    ;; Set Chinese font 
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))
(qiang-set-font
 '("YaHei Consolas Hybrid" "Consolas" "Monacoe" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=16" 
 '("YaHei Consolas Hybrid" "Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体")) ;; "Microsoft Yahei" 
;;(set-default-font "-outline-YaHei Consolas Hybrid-normal-normal-normal-sans-15-*-*-*-p-*-iso8859-1")
;; Shift + Tab settings
(global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
	(replace-match "")))))

;; setup for the findr packages
(autoload 'findr "findr" "Find file name." t)
(define-key global-map [(meta control S)] 'findr)

(autoload 'findr-search "findr" "Find text in files." t)
(define-key global-map [(meta control s)] 'findr-search)

(autoload 'findr-query-replace "findr" "Replace text in files." t)
(define-key global-map [(meta control r)] 'findr-query-replace)


(provide 'common-config)
