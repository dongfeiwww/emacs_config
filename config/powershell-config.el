;; autoload powershell interactive shell
(autoload 'powershell "powershell" "Start a interactive shell of PowerShell." t)
;; powershell-mode
(autoload 'powershell-mode "powershell-mode" "A editing mode for Microsoft PowerShell." t)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode)) ; PowerShell script

(global-set-key (kbd "<f3>") 'powershell)
(provide 'powershell-config)
