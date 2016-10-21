;;; packages.el --- myjava layer packages file for Spacemacs.
;;
;; Copyright (c) 2016 Jake Waksbaum
;;
;; Author:  <jake.waksbaum@gmail.com>
;; URL: https://github.com/jbaum98/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `myjava-packages'.  Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `myjava/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `myjava/pre-init-PACKAGE' and/or
;;   `myjava/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst myjava-packages
  '(
    flycheck
    (eclim :excluded t)
    java-snippets
    )
  "The list of Lisp packages required by the myjava layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defcustom flycheck-javac-infer-classpath '(".")
  "The classpath passed to `javac`."
  :type '(repeat (string)))

(defun null-classpath (paths)
  "Determine if PATHS conataines only the current directory."
  (or (null paths) (equal paths '("."))))

(defun make-classpath-str (paths)
  "Forms a classpath string out of a list of paths, PATHS."
  (concat "" (mapconcat 'identity paths ":") ""))

(defun myjava/post-init-flycheck ()
  "Configure flycheck for Java."
  (flycheck-define-checker java/javac
    "A Java syntax and style checker using javac."
    :command ("javac"
              (eval
               (when (not (null-classpath flycheck-javac-infer-classpath))
                 (list "-classpath" (make-classpath-str flycheck-javac-infer-classpath))))
              source)
    :error-patterns
    ((error line-start (file-name) ":" line ":" " error:" (message) line-end)
     (warning line-start (file-name) ":" line ":" " warning:" (message) line-end)
     (info line-start (file-name) ":" line ":" " info:" (message) line-end))
    :modes java-mode)

  (flycheck-define-checker java/javac-in-place
    "A Java syntax and style checker using javac that also automatically compiles the file."
    :command ("javac"
              (eval
               (when (not (null-classpath flycheck-javac-infer-classpath))
                 (list "-classpath" (make-classpath-str flycheck-javac-infer-classpath))))
              source-original)
    :error-patterns
    ((error line-start (file-name) ":" line ":" " error:" (message) line-end)
     (warning line-start (file-name) ":" line ":" " warning:" (message) line-end)
     (info line-start (file-name) ":" line ":" " info:" (message) line-end))
    :modes java-mode
    :predicate flycheck-buffer-saved-p)
  (add-to-list 'flycheck-checkers 'java/javac)
  (add-to-list 'flycheck-checkers 'java/javac-in-place)
  )

(defun myjava/init-java-snippets () ())

;;; packages.el ends here
