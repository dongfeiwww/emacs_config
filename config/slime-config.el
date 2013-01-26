;; setup for common lisp IDE
(setq inferior-lisp-program "sbcl")
(add-to-list 'load-path "~/site-lisp/slime/")
(require 'slime)
(slime-setup)

(eval-after-load "slime"
  '(progn
     (slime-setup '(slime-fancy slime-asdf slime-banner))
     (setq slime-complete-symbol*-fancy t)
     (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)))

(provide 'slime-config)