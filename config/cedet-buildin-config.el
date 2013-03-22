
(load-file "~/lisp/cedet/cedet.el")
(load-file "~/lisp/cedet/semantic.el")
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)


 
;; Activate semantic
(semantic-mode 1)
;; (require 'semantic/bovine/c)

;; (setq MinGW-64-base-dir 
;;     "D:/MinGW/x86_64-w64-mingw32/include")
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat MinGW-64-base-dir "/crtdefs.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat MinGW-64-base-dir "/yvals.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat MinGW-64-base-dir "/vadefs.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat MinGW-64-base-dir "/comdefsp.h"))
;; (semantic-c-reset-preprocessor-symbol-map)
;; limit the frequence of idle schedule
;; (setq semantic-idle-scheduler-idle-time 5)
;; (setq microsoft-base-dir 
;;     "D:/Program Files (x86)/Microsoft Visual Studio 9.0/VC/include")

;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat microsoft-base-dir "/crtdefs.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat microsoft-base-dir "/yvals.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat microsoft-base-dir "/vadefs.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file 
;;      (concat microsoft-base-dir "/comdefsp.h"))
;; (semantic-c-reset-preprocessor-symbol-map)
;; (semantic-add-system-include microsoft-base-dir 'c++-mode)

;; (defconst user-include-dirs
;;   (list ".." "../include" "../inc" "../common" "../public"
;;         "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst win32-include-dirs
  (list "D:/MinGW/include"
        "D:/MinGW/x86_64-w64-mingw32/include"
;;	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include"
;;	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include/c++"
;;	"D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include-fixed"
))
(mapc (lambda (dir)
	(semantic-add-system-include dir 'c-mode)
	(semantic-add-system-include dir 'c++-mode))
      win32-include-dirs)
(semantic-add-system-include
 "D:/MinGW/lib/gcc/x86_64-w64-mingw32/4.7.2/include/c++" 'c++-mode)
;; (let ((include-dirs user-include-dirs))
;;   (when (eq system-type 'windows-nt)
;;     (setq include-dirs (append include-dirs win32-include-dirs)))
;;   (mapc (lambda (dir)
;;           (semantic-add-system-include dir 'c++-mode)
;;           (semantic-add-system-include dir 'c-mode))
;;         include-dirs))
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

;; (require 'semantic-tag-folding)
;; (global-semantic-tag-folding-mode)
;; (define-key semantic-tag-folding-mode-map 
;;   (kbd "C-c , -") 'semantic-tag-folding-fold-block)
;; (define-key semantic-tag-folding-mode-map 
;;   (kbd "C-c , =") 'semantic-tag-folding-show-block)
;; (define-key semantic-tag-folding-mode-map 
;;   (kbd "C-_") 'semantic-tag-folding-fold-all)
;; (define-key semantic-tag-folding-mode-map
;;   (kbd "C-+") 'semantic-tag-folding-show-all)
;; (global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)





;; name completion
(defun my-c-mode-cedet-hook ()
 (local-set-key "." 'semantic-complete-self-insert)
 (local-set-key ">" 'semantic-complete-self-insert)
 (local-set-key "\M-n" 'semantic-ia-complete-symbol-menu))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
(require 'eassist)
 
;; customisation of modes
(defun alexott/cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  ;;
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)
 
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  )
(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'scheme-mode-hook 'alexott/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'alexott/cedet-hook)

 
(defun alexott/c-mode-cedet-hook ()
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  )
(add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)
 
;; SRecode for template
;; (global-srecode-minor-mode 1)
 
;; EDE
(global-ede-mode 1)
(ede-enable-generic-projects)

(provide 'cedet-buildin-config)
