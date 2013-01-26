;; setup for the Racket (Scheme implementation)
(require 'quack)
(setq-default racket-program-name "racket")
;; We also want something like this when running a Scheme process.

(define-key inferior-scheme-mode-map "\n" 'newline)
(define-key inferior-scheme-mode-map "\r" 'scheme-return)

;; -------- Making return work --------

;; The problem with comint mode is that it's extremely line-based.
;; Scheme is not so line based.  This fixes the problem: a Scheme
;; expression is only sent to the Scheme process when it is full and
;; balanced.

(defun scheme-return ()
  "Newline and indent, or evaluate the sexp before the prompt.
Complete sexps are evaluated; for incomplete sexps inserts a newline
and indents."
  (interactive)
  (let ((input-start (process-mark (get-buffer-process (current-buffer)))))
    (if (< (point) input-start)
	(comint-send-input)		; this does magic stuff
      (let ((state (save-excursion
		     (parse-partial-sexp input-start (point)))))
	(if (and (< (car state) 1)	; depth in parens is zero
		 (not (nth 3 state))	; not in a string
		 (not (save-excursion	; nothing after the point
			(search-forward-regexp "[^ \t\n\r]" nil t))))
	    (comint-send-input)		; then go for it.
	  (newline-and-indent))))))

;;; -------- Indenting definitions ----

;; if TAB indents lines, it might make sense for C-c TAB to indent
;; definitions.  Or maybe not, but here it is anyway.

(defun scheme-indent-definition ()
  "Fix indentation of the current definition."
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (scheme-indent-sexp)))

(define-key scheme-mode-map "\C-c\C-i" 'scheme-indent-definition)
(define-key inferior-scheme-mode-map "\C-c\C-i" 'scheme-indent-definition)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(quack-default-program "D:\\home\\user\\Racket\\racket.exe")
 '(quack-manuals (quote ((r5rs "R5RS" "http://www.schemers.org/Documents/Standards/R5RS/HTML/" nil) (bigloo "Bigloo" "http://www-sop.inria.fr/mimosa/fp/Bigloo/doc/bigloo.html" nil) (chez "Chez Scheme User's Guide" "http://www.scheme.com/csug/index.html" nil) (chicken "Chicken User's Manual" "http://www.call-with-current-continuation.org/manual/manual.html" nil) (gambit "Gambit-C home page" "http://www.iro.umontreal.ca/~gambit/" nil) (gauche "Gauche Reference Manual" "http://www.shiro.dreamhost.com/scheme/gauche/man/gauche-refe.html" nil) (mitgnu-ref "MIT/GNU Scheme Reference" "http://www.gnu.org/software/mit-scheme/documentation/scheme.html" nil) (mitgnu-user "MIT/GNU Scheme User's Manual" "http://www.gnu.org/software/mit-scheme/documentation/user.html" nil) (mitgnu-sos "MIT/GNU Scheme SOS Reference Manual" "http://www.gnu.org/software/mit-scheme/documentation/sos.html" nil) (plt-mzscheme "PLT MzScheme: Language Manual" plt t) (plt-mzlib "PLT MzLib: Libraries Manual" plt t) (plt-mred "PLT MrEd: Graphical Toolbox Manual" plt t) (plt-framework "PLT Framework: GUI Application Framework" plt t) (plt-drscheme "PLT DrScheme: Programming Environment Manual" plt nil) (plt-insidemz "PLT Inside PLT MzScheme" plt nil) (plt-tools "PLT Tools: DrScheme Extension Manual" plt nil) (plt-mzc "PLT mzc: MzScheme Compiler Manual" plt t) (plt-r5rs "PLT R5RS" plt t) (scsh "Scsh Reference Manual" "http://www.scsh.net/docu/html/man-Z-H-1.html" nil) (sisc "SISC for Seasoned Schemers" "http://sisc.sourceforge.net/manual/html/" nil) (htdp "How to Design Programs" "http://www.htdp.org/" nil) (htus "How to Use Scheme" "http://www.htus.org/" nil) (t-y-scheme "Teach Yourself Scheme in Fixnum Days" "http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme.html" nil) (tspl "Scheme Programming Language (Dybvig)" "http://www.scheme.com/tspl/" nil) (sicp "Structure and Interpretation of Computer Programs" "http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-4.html" nil) (slib "SLIB" "http://swissnet.ai.mit.edu/~jaffer/SLIB.html" nil) (faq "Scheme Frequently Asked Questions" "http://www.schemers.org/Documents/FAQ/" nil) (Racket "Racket reference " "http://docs.racket-lang.org/reference/index.html" t))))
 '(quack-programs (quote ("D:\\home\\user\\Racket\\racket.exe" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -i -p neil/sicp" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )