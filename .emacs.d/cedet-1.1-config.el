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
