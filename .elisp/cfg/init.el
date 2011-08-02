(defun setup-frame-hook (frame)
  "This function will be applied to all new emacs frames."
  (set-frame-parameter frame 'alpha '(95 95)) ; translucency
  (mouse-avoidance-mode 'cat-and-mouse)       ; avoid mouse
  (fringe-mode '(1 . 1))                      ; make fringes smaller
  (tool-bar-mode -1)                          ; no toolbar
  (menu-bar-mode -1)                          ; no menubar
  (scroll-bar-mode -1)                        ; no scrollbar
  (set-frame-parameter (selected-frame) 'alpha '(95 95)))
(add-hook 'after-make-frame-functions 'setup-frame-hook)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
(require 'switch-window)

(setq x-select-enable-clipboard t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq python-python-command "python")

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
;; (setq thrift-indent-level 4)
(setq css-indent-level 4)
(setq py-indent-offset 2)
(setq js2-basic-offset 2)

(fset 'yes-or-no-p 'y-or-n-p)

;; disable line wrap
(setq truncate-lines t)
;; make side by side buffers function the same as the main window
(setq truncate-partial-width-windows nil)
;; Add F12 to toggle line wrap
(global-set-key [f11] 'toggle-truncate-lines)

;;; (server-start)

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

(defun smart-split ()
  "Split the window into 80-column sub-windows, and make sure no
   window has fewer than 80 columns."
  (interactive)
  (defun smart-split-helper (w)
    "Helper function to split a given window into two, the first
     of which has 80 columns."
    (if (> (window-width w) 81)
        (let ((w2 (split-window w 82 t)))
          (smart-split-helper w2))))
  (smart-split-helper nil))

;;
;; RM-Trailing-Spaces
;;
(defun rm-trailing-spaces ()
  "Remove spaces at ends of all lines"
  (interactive)
  (save-excursion
    (let ((current (point)))
      (goto-char 0)
      (while (re-search-forward "[ \t]+$" nil t)
        (replace-match "" nil nil))
      (goto-char current))))

(global-unset-key "\C-z")
(global-set-key "\C-x~" 'smart-split)
(global-set-key [(shift home)] '(lambda () (interactive) (other-window -1)))
(global-set-key [(shift end)] '(lambda () (interactive) (other-window 1)))
(global-set-key "\C-xy" 'anything)

(winner-mode 1)

(require 'zenburn)
(color-theme-zenburn)

(require 'rv-font-23)

;; (desktop-save-mode 1)

;; (require 'magit)

(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(require 'actionscript-mode)
(add-to-list 'auto-mode-alist '("\\.as\\'" . actionscript-mode))

(require 'js2-mode)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'coffee-mode)

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
;; (require 'slime)
;; (set-language-environment "UTF-8")
;; (setq slime-net-coding-system 'utf-8-unix)
;; (define-key global-map (kbd "<f12>") 'slime-selector)
;; (def-slime-selector-method ?j
;;   "most recently visited clojure-mode buffer."
;;   (slime-recently-visited-buffer 'clojure-mode))

;; uniquify changes conflicting buffer names from file<2> etc
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; (require 'w3m-load)
;; (setq w3m-use-cookies t)
;; (setq w3m-key-binding 'info)

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
