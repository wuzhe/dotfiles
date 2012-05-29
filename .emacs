(let ((default-directory "~/.elisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'load-path "~/.elisp/vendor")

(setq package-archives
      '(("ELPA" . "http://tromey.com/elpa/")
        ;; ("gnu" . "http://elpa.gnu.org/packages/")
        ;; ("technomancy" . "http://repo.technomancy.us/emacs/")
        ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(require 'init)
