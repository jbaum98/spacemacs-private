;;; config.el --- myjava layer configuration file for Spacemacs.
;;
;; Copyright (c) 2016 Sylvain Benner & Contributors
;;
;; Author:  <jake.waksbaum@gmail.com>
;; URL: https://github.com/jbaum98/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;;; Code:

(add-hook 'java-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "javac " (file-name-nondirectory buffer-file-name)))
            (flycheck-mode)))

;;; config.el ends here
