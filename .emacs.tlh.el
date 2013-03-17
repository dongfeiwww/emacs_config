;; use utf-8 charset for html and yml files
(modify-coding-system-alist 'file "\\.markdown\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "\\.md\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "\\.html\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "\\.yml\\'" 'utf-8-unix)

;; msys shell
(defun msys-shell ()
  (interactive)
  (let ((explicit-bash.exe-args '("--noediting" "--login" "-i"))
	(explicit-shell-file-name "D:/home/bin/Git/bin/bash.exe"))
    (shell)))
;; start the emacs server to speed up the emacs
(load "server")
(unless (server-running-p) (server-start))

;; Opening Server Files Always in a New Frame
(custom-set-variables
   '(server-done-hook (quote ((lambda nil (kill-buffer nil)) delete-frame)))
   '(server-switch-hook (quote 
			 ((lambda nil 
			    (let (server-buf) 
			      (setq server-buf (current-buffer)) 
			      (bury-buffer)      
			      (switch-to-buffer-other-frame server-buf))))))
   )
;; setup for the load path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'load-path "~/config/")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
;; (add-to-list 'load-path "~/.emacs.d/plugins/xcscope")
(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(add-to-list 'load-path "~/.emacs.d/plugins/cedet-1.1")
(add-to-list 'load-path "D:/emacs-24.2/.emacs.d/elpa/helm-20130124.943")
(add-to-list 'load-path "D:/emacs-24.2/.emacs.d/elpa/glsl-mode-20130209.13/glsl-mode")

;; setup for glsl-mode
(autoload 'glsl-mode "glsl-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
  (add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
  (add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
  (add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

;; setup for the gtags
(if (eq system-type 'windows-nt)
        (progn
          (setq exec-path (add-to-list 'exec-path "D:/home/bin/gtags/bin"))
          (setenv "PATH" (concat "D:\\home\\bin\\gtags\\bin;" (getenv "PATH")))))
(autoload 'gtags-mode "gtags" "" t)
;; (add-hook 'c-mode-common-hook
;; 	  '(lambda ()
;; 	     (gtags-mode 1)))
;; There are two hooks, gtags-mode-hook and gtags-select-mode-hook.
;; The usage of the hook is shown as follows.
;;
;; [Setting to use vi style scroll key]
;;
;; (add-hook 'gtags-mode-hook
;;   '(lambda ()
;;      (define-key gtags-mode-map "\C-f" 'scroll-up)
;;      (define-key gtags-mode-map "\C-b" 'scroll-down)
;; ))
;;
;; [Setting to make 'Gtags select mode' easy to see]
;;
(add-hook 'gtags-select-mode-hook
  '(lambda ()
     (setq hl-line-face 'underline)
     (hl-line-mode 1)
))
;; setup for the emacs-color-theme
(load-theme 'zenburn t)
;;(add-to-list 'custom-theme-load-path 
;;	     "~/.emacs.d/plugins/emacs-color-theme-solarized")
;;(load-theme 'solarized-light t)

;; setup for cedet
(load-file "~/.emacs.d/plugins/cedet-1.1/common/cedet.el")
;; Enable EDE (Project Management) features
(global-ede-mode 1)
;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)
;; semantic-tag-folding
(require 'semantic-tag-folding nil 'noerror)
;; (autoload 'global-semantic-tag-folding-mode
;;  "semantic-tag-folding" "loading semantic-tag-folding" t)
(global-semantic-tag-folding-mode)
;; key bindings
(define-key semantic-tag-folding-mode-map 
  (kbd "C-c , -") 'semantic-tag-folding-fold-block)
(define-key semantic-tag-folding-mode-map 
  (kbd "C-c , =") 'semantic-tag-folding-show-block)
(define-key semantic-tag-folding-mode-map 
  (kbd "C-_") 'semantic-tag-folding-fold-all)
(define-key semantic-tag-folding-mode-map
  (kbd "C-+") 'semantic-tag-folding-show-all)
(global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)
;; * This enables even more coding tools such as intellisense mode,
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberant ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languages only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
;; a template system like yasnippet
;; (global-srecode-minor-mode 1)

(defconst user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst win32-include-dirs
  (list "D:/MinGW/include"
        "D:/MinGW/x86_64-w64-mingw32/include"
	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include"
	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include/c++"
	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include-fixed"
	;; "D:/MinGW/glew/include"
	;; "d:/MinGW/freeglut/include"
))
(require 'semantic-c nil 'noerror)
(let ((include-dirs user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs win32-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
;;sematic jump between the function call and function called
(global-set-key [f8] 'semantic-ia-fast-jump)
(global-set-key [S-f8]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
;; setup for the package system
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )
;; highlight matching paren
 (show-paren-mode t)
;; Auto-complete settings
;; this is the code for the auto-complete
(require 'auto-complete-config)
(autoload 'auto-complete-mode "auto-complete-config" nil)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete//ac-dict")
(ac-config-default)
;; show the menu after 0.5 seconds
;;(setq ac-auto-show-menu 0.5)
(define-key ac-completing-map "\M-/" 'ac-stop)
;; fix the bug for [return] in autopair
(define-key ac-completing-map [return] 'ac-complete)
;;(define-key ac-completing-map [tab] 'ac-expand)
;;(defun ac-common-setup ()
;;  (setq ac-sources (append ac-sources '(ac-source-words-in-all-buffer))))
;; (add-hook 'c-mode-common-hook (lambda () (add-to-list 'ac-sources 'ac-source-semantic)))
;; (add-hook 'c-mode-common-hook (lambda () (add-to-list 'ac-sources 'ac-source-semantic-raw)))
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
;; Complete member name by C-c . for C++ mode.
(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key (kbd "C-c .") 'ac-complete-semantic)))


;; enable AC-mode in text mode
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'makefile-gmake-mode)
;; setup for yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(setq yas-also-auto-indent-first-line t)

(yas-reload-all)
;; (yas-global-mode t)
;; setup for bm
(add-to-list 'load-path 
	     "~/.emacs.d/plugins/bm")
(require 'bm)
(global-set-key (kbd "C-.") 'bm-toggle)
(global-set-key (kbd "<f11>")   'bm-next)
(global-set-key (kbd "<f12>") 'bm-previous)
(setq bm-cycle-all-buffers t)

;; setup for the tramp
;;(require 'tramp)
(setq default-tramp-method "plink")
(setq shell-prompt-pattern "^[^#$%>\n]*[#$%>] *")

;; setup for the common config
(require 'common-config)
;; setup for the chrome extension "Edit with Emacs"
(when (require 'edit-server nil t)
  (setq edit-server-new-frame nil)
  (edit-server-start))
;; setup for the tex coding system
;; 打开tex结尾的文件时默认用gbk编码。
(modify-coding-system-alist 'file ".*\\.tex\\'" 'chinese-gbk-dos)
;; setup for org-mode
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "HANGUP" "|" "DONE" "CANCEL")))
(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i!)" "HANGUP(h!)" "|" "DONE(d!)" "CANCEL(c!)")))


;; setting up for auto pair
(require 'autopair)
;; (autopair-global-mode) ;; enable autopair in all buffers
(add-hook 'c-mode-common-hook
	  #'(lambda () (autopair-mode t)))
(add-hook 'emacs-lisp-mode-hook
	  #'(lambda () (autopair-mode t)))
(add-hook 'python-mode-hook
	  #'(lambda () 
	      (autopair-mode t)))
;; setup for smart compile
(require 'smart-compile)
(global-set-key (kbd "<f5>") 'smart-compile)
;; setup for the powershell
(global-set-key (kbd "<f2>") 'shell)
;; setup for the speedbar
(global-set-key (kbd "<f9>") 'speedbar)

;; setup for the c-mode-style
(defun my-c-mode-hook ()
  (c-set-style "awk"))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)
;;Set the xcscope
;; (add-hook 'c-mode-common-hook
;; 	  (lambda ()
;; ;;	    (linum-mode t)
;; 	    (require 'xcscope)))
;; setup for the yasnippet
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (require 'yasnippet)
	    (yas-minor-mode-on)))
;; setup for magit
(autoload 'magit-status "magit" nil t)
(setq magit-git-executable "D:/home/bin/Git/bin/git.exe")
(setq exec-path (append exec-path '("D:/home/bin/Git/bin")))
(if (eq system-type 'windows-nt)
        (progn
          (setq exec-path (add-to-list 'exec-path "D:/home/bin/Git/bin"))
          (setenv "PATH" (concat "D:\\home\\bin\\Git\\bin;" (getenv "PATH")))))
;; setup for rect-mark
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)
;;(autoload 'cc-mode "cc-config" "loading cc-config." t)
(autoload 'auto-c-files "user-defined" "loading user-defined" t)
(setq python-command "python -i -u")
(add-hook 'python-mode-hook
	  '(lambda ()
	     (require 'python-config)))
(autoload 'slime "slime-config" "loading slime-config." t)
(autoload 'run-scheme "scheme-config" "loading scheme-config." t)
(autoload 'c-mode "user-defined" "loading user-defined." t)
;; set up for helm
(autoload 'helm-mode "helm-config" t)
(global-set-key (kbd "C-c h") 'helm-mini)

