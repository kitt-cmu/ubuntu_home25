;; Add repositories and other package-related configuration here
(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/"))
  ; '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/"))
  )

(unless (package-installed-p 'gnu-elpa-keyring-update)
  ;; Disable signature checking for packages
  (setq package-check-signature nil)
  (package-refresh-contents)
  (package-install 'gnu-elpa-keyring-update)
  )

; (setq package-check-signature "allow-unsigned")

;; Check if gnu-elpa-keyring-update is installed
(if (package-installed-p 'gnu-elpa-keyring-update)
    (message "gnu-elpa-keyring-update is installed.")
  (message "gnu-elpa-keyring-update is not installed."))


(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)

;; Load use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; Load and configure packages using use-package
(eval-when-compile
  (require 'use-package))

;; Define a list of additional packages to install
(defvar my-packages
  '(json-mode
    ; go-mode
    ; js2-mode
    web-mode css-mode
    ; ruby-mode
    ; inf-ruby
    ; racket-mode
    ; nasm-mode
    company
    ))

;; Ensure the listed packages are installed
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; Set the color source for the Base16 theme in 256-color terminal environments
;; Possible values:
;;   'terminal (default): Use colors from a Base16-compatible terminal theme
;;   'base16-shell: Use the extended color palette from Base16 Shell
;;   'colors: Convert HTML color codes to the closest 256-color matches
(setq base16-theme-256-color-source "colors")

;; Load theme using use-package
(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-default-dark t)
  )


;; Set default indentation behavior
(setq-default indent-tabs-mode nil) ;; Use spaces by default
(setq-default tab-width 4)          ;; Set default tab width to 4 spaces

;; Set tab width for Shell mode to 2 spaces
(add-hook 'sh-mode-hook
          (lambda ()
            (setq-local tab-width 2)))

;; Set indentation behavior for Go mode
(add-hook 'go-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode t) ;; Use tabs for indentation in Go mode
            (setq-local tab-width 4)))       ;; Set tab width to 4 spaces in Go mode

; Configure company-mode
(use-package company
  :ensure t
  :config
  (setq company-minimum-prefix-length 1) ; Set minimum prefix length for auto completion
  (global-company-mode 1) ; Enable Company mode globally
  )

; (add-hook 'python-mode-hook #'(lambda () (setq flycheck-checker 'python-pylint)))

; ;for python, you will need to install lsp: sudo pip3 install python-language-server
; (use-package lsp-mode
;   :ensure t
;   :hook
;   (prog-mode . lsp)
;   :config
;   ;; Adjust any additional settings here
;   )

; (setq lsp-pylsp-root-markers '(".git" "setup.cfg"))  ; Specify project root markers
; (add-hook 'go-mode-hook #'lsp-deferred)

(xterm-mouse-mode t) ; Enable mouse

;; Function to copy text to the Windows clipboard
(defun copy-to-windows-clipboard (text)
  "Copy TEXT to the Windows clipboard using clip.exe."
  (interactive (list (if (use-region-p) (buffer-substring-no-properties (region-beginning) (region-end)))))
  (if text
      (progn
        (with-temp-buffer
          (insert text)
          (call-process-region (point-min) (point-max) "clip.exe" nil 0))
        (kill-new text)
        (message "Copied region"))
    (message "No region is active")))

;; Function to paste text from the Windows clipboard
(defun paste-from-windows-clipboard ()
  "Paste text from the Windows clipboard using clip.exe."
  (interactive)
  (insert (shell-command-to-string "powershell.exe Get-Clipboard -Raw")))


;; Function to remove DOS line endings (^M) from the current buffer
(defun remove-dos-eol ()
  "Remove DOS line endings (^M) from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

;; Function to copy text to the clipboard on Ubuntu
(defun copy-to-clipboard ()
  "Copy the highlighted region to the clipboard using xclip."
  (interactive)
  (if (use-region-p)
      (progn
        (let ((text (buffer-substring (region-beginning) (region-end))))
          (with-temp-buffer
            (insert text)
            (call-process-region (point-min) (point-max) "xclip" nil 0 nil "-selection" "clipboard"))
          (message "Copied region")))
    (message "No region is active")))


;; Function to paste text from the clipboard on Ubuntu
(defun paste-from-clipboard ()
  "Paste text from the clipboard using xclip."
  (interactive)
  (insert (shell-command-to-string "xclip -o -selection clipboard")))


;; Bindings for copying and pasting, only if mouse mode is enabled
(when (bound-and-true-p xterm-mouse-mode)
  (if (getenv "WSL_DISTRO_NAME")
      (progn
        (global-set-key (kbd "C-c c") 'copy-to-windows-clipboard)
        (global-set-key (kbd "C-c v")
                        (lambda ()
                          (interactive)
                          (paste-from-windows-clipboard)
                          (remove-dos-eol))))
    (progn
      (global-set-key (kbd "C-c c") 'copy-to-clipboard)
      (global-set-key (kbd "C-c v") 'paste-from-clipboard)))
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))


(custom-set-variables
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(go-mode pkg-info use-package lsp-mode gnu-elpa-keyring-update base16-theme web-mode json-mode css-mode))
 '(show-paren-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "#949494"))))
 '(line-number ((t (:foreground "#787878")))))

;; Enable desktop-save-mode to save the current desktop layout
(desktop-save-mode t)


