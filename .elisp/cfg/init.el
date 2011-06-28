(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(setq x-select-enable-clipboard t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq python-python-command "python")

(fset 'yes-or-no-p 'y-or-n-p)

;; (server-start)

;; byte compile config file if changed
(add-hook 'after-save-hook
          '(lambda ()
	     (when (string-match
		    (concat (expand-file-name "~/.elisp/cfg/") ".*\.el$")
		    buffer-file-name)
	       (byte-compile-file buffer-file-name))))

(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-80-columns ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 80))

;;; Unbind the stupid minimize that I always hit.
(global-unset-key "\C-z")

(global-set-key "\C-x~" 'set-80-columns)
(global-set-key [(shift home)] '(lambda () (interactive) (other-window -1)))
(global-set-key [(shift end)] '(lambda () (interactive) (other-window 1)))

(winner-mode 1)

(require 'js2-mode)
(setq js2-bounce-indent-p t)

(require 'zenburn)
(color-theme-zenburn)

;; (desktop-save-mode 1)

(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(require 'actionscript-mode)
(add-to-list 'auto-mode-alist '("\\.as\\'" . actionscript-mode))

;; (require 'coffee-mode)

(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))

(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook     'enable-paredit-mode)
(add-hook 'clojure-mode-hook    'enable-paredit-mode)
(add-hook 'ruby-mode-hook       'esk-paredit-nonlisp)
(add-hook 'espresso-mode-hook   'esk-paredit-nonlisp)
(add-hook 'slime-repl-mode-hook 'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
(setq slime-net-coding-system 'utf-8-unix)

(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-startup-indented 1)
(setq org-startup-align-all-tables 1)
(set-face-attribute 'org-hide nil :foreground "grey25")

(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

;;bind the slime selector to f12 and add a method for finding clojure buffers
(require 'slime)
(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix)
(define-key global-map (kbd "<f12>") 'slime-selector)
(def-slime-selector-method ?j
  "most recently visited clojure-mode buffer."
  (slime-recently-visited-buffer 'clojure-mode))

;; uniquify changes conflicting buffer names from file<2> etc
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(require 'w3m-load)
(setq w3m-use-cookies t)
(setq w3m-key-binding 'info)

;; keep backup files neatly out of the way in .~/
(setq backup-directory-alist '(("." . ".~")))

;; real lisp hackers use the lambda character
;; courtesy of stefan monnier on c.l.l
(defun sm-lambda-mode-hook ()
  (font-lock-add-keywords
   nil `(("\\<lambda\\>"
	  (0 (progn (compose-region (match-beginning 0) (match-end 0)
				    ,(make-char 'greek-iso8859-7 107))
		    nil))))))
(add-hook 'emacs-lisp-mode-hook 'sm-lambda-mode-hook)
(add-hook 'lisp-interactive-mode-hook 'sm-lamba-mode-hook)
(add-hook 'scheme-mode-hook 'sm-lambda-mode-hook)

;; Steve Yegge's function to rename a file that you're editing along
;; with its corresponding buffer:
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file name new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))


(defun setup-proxy()
  "Setup Emacs for using socks proxy"

  ;; socks.el is part of GNU Emacs 23
  (require 'socks)
  (setq socks-noproxy '("localhost"))
  (setq socks-override-functions 1)
  (setq erc-server-connect-function 'socks-open-network-stream)
  ;; (defalias 'open-network-stream 'socks-open-network-stream)

  (setq socks-server '("madk proxy" "localhost" "8080" 5)))

(setup-proxy)

(provide 'init)