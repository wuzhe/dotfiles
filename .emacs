(add-to-list 'load-path "~/.elisp/")
(let ((default-directory "~/.elisp/"))
  (normal-top-level-add-subdirs-to-load-path))

(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

(add-to-list 'package-archives
             '("technomancy" . "http://repo.technomancy.us/emacs/") t) 

(require 'init)