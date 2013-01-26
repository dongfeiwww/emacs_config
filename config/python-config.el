(c-add-style
  "python-new"
  '((indent-tabs-mode . nil)
    (fill-column      . 78)
    (c-basic-offset   . 4)
    (c-offsets-alist  . ((substatement-open . 0)
                         (inextern-lang . 0)
                         (arglist-intro . +)
                         (knr-argdecl-intro . +)))
    (c-hanging-braces-alist . ((brace-list-open)
                               (brace-list-intro)
                               (brace-list-close)
                               (brace-entry-open)
                               (substatement-open after)
                               (block-close . c-snug-do-while)))
    (c-block-comment-prefix . "* "))
  )

;; This is a very crude hook that auto-selects the C style depending on
;; whether it finds a line starting with tab in the first 3000 characters
;; in the file
(defun c-select-style ()
   (save-excursion
     (if (re-search-forward "^\t" 3000 t)
         (c-set-style "python")
       (c-set-style "python-new"))))
(add-hook 'c-mode-hook 'c-select-style)
(provide 'python-config)
