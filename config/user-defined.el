;; ��дһ���Զ�����C����Դ�ļ���ͷ�ļ��ĳ���
;; �������ļ���Ϊ�˽����㷨�������㷨ʵ�ֵ���ϰ
;; �������ļ���
;; filename.c ���ݰ���#include "filename.h"
;; filename_test.c ���ݰ���#include "filename.h"���� main
;; filename.h ���ݰ���once Ԥ����
;; filename.mk ���ݰ���makefile��ģ�壬��algorithm/make_template.mk��
;; ���������Ϊ filename

;; �����Ϊfilename.*���ļ��Ƿ���ڣ�(*�����������չ��)
(defun auto-c-files (filename template-filename)
  "auto generate files named \"filename\" for C development"
  (interactive "sEnter the file name sans extension: \nsEnter the template file name: ")
  (message "File name: %s, template file name: %s" filename template-filename)
  (if (directory-files "." nil 
		       (concat
			filename "\..*")
		       t)
      (message "%s already exists!" filename)
    (if (file-exists-p template-filename)
	(progn
	  (dot-c-file filename)
	  (dot-c-test-file filename)
	  (dot-h-file filename))
      (message "can't find the template file in current dir."))))
(defun dot-c-file (filename)
  (let ((filename-ext (concat filename ".c")))
    (if (not (file-exists-p filename-ext))
	(write-region 
	 (concat "#include \"" filename ".h\"\n") 
	 nil 
	 filename-ext
	 t)
    (message (concat 
		filename-ext
		" already exist!")))))
;; ����onceԤ����  
(defun dot-h-file (filename)
  (let ((filename-ext (concat filename ".h"))
	(filename-ext-h-tag 
	 (concat 
	  "_"
	  (upcase (file-name-nondirectory 
		   (file-name-sans-extension filename))) 
	  "_H_")))
    (if (not (file-exists-p filename-ext))
	  (write-region
	   (concat 
	    "#ifndef " filename-ext-h-tag "\n"
	    "#define " filename-ext-h-tag "\n\n\n"
	    "#endif /* " filename-ext-h-tag " */"
	    )
	   nil 
	   filename-ext
	   t)	
      (message (concat 
		filename-ext
		" already exist!")))))
;; ���ͷ�ļ���mainģ��
(defun dot-c-test-file (filename)
  (let ((filename-ext (concat filename "_test.c")))
    (if (not (file-exists-p filename-ext))
	  (write-region 
	   (concat 
	    "#include \"" filename ".h\"\n\n"
	    "int main(int argc, char *argv[])\n"
	    "{\n\n\n"
	    "    return 0;\n"
	    "}")  
	   nil 
	   filename-ext
	   t)
      (message (concat 
		filename-ext
		" already exist!")))))
;; ���makefileģ��
;; copy-file
(defun dot-make-file (filename template-filename)
  (let ((filename-ext (concat filename ".mk")))
    (if (not (file-exists-p filename-ext))
	(if (file-exists-p template-filename)
	    (copy-file template-filename filename-ext)
	  (message "template file is not exist!"))
      (message (concat 
		filename-ext
		" already exist!")))))

(provide 'user-defined)
