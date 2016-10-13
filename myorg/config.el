(setq-default
 org-src-fontify-natively t
 org-src-tab-acts-natively t)

;;;###autoload
(defun calc-offset-on-org-level ()
  "Calculate offset (in chars) on current level in org mode file."
  (* (or (org-current-level) 0) org-indent-indentation-per-level))

;;;###autoload
(defun my-org-fill-paragraph (&optional JUSTIFY)
  "Calculate apt fill-column value and fill paragraph."
  (let* ((fill-column (- fill-column (calc-offset-on-org-level))))
    (org-fill-paragraph JUSTIFY)))

;;;###autoload
(defun my-org-auto-fill-function ()
  "Calculate apt fill-column value and do auto-fill"
  (let* ((fill-column (- fill-column (calc-offset-on-org-level))))
    (org-auto-fill-function)))

;;;###autoload
(defun my-org-mode-hook ()
  (setq fill-paragraph-function   'my-org-fill-paragraph
        normal-auto-fill-function 'my-org-auto-fill-function))

(add-hook 'org-load-hook 'my-org-mode-hook)
(add-hook 'org-mode-hook 'my-org-mode-hook)

;;;###autoload
(defun jk-org-kwds ()
  "parse the buffer and return a cons list of (property . value)
from lines like:
#+PROPERTY: value"
  (org-element-map (org-element-parse-buffer 'element) 'keyword
    (lambda (keyword) (cons (org-element-property :key keyword)
                            (org-element-property :value keyword)))))

;;;###autoload
(defun jk-org-kwd (KEYWORD)
  "get the value of a KEYWORD in the form of #+KEYWORD: value"
  (cdr (assoc KEYWORD (jk-org-kwds))))

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-babel-after-execute-hook 'spacemacs/toggle-typographic-substitutions-on)

;;;###autoload
(defun org-export-filter-timestamp-remove-brackets (timestamp backend info)
  "removes relevant brackets from a timestamp"
  (cond
   ((org-export-derived-backend-p backend 'latex)
    (replace-regexp-in-string "[<>]\\|[][]" "" timestamp))
   ((org-export-derived-backend-p backend 'html)
    (replace-regexp-in-string "&[lg]t;\\|[][]" "" timestamp))))

(eval-after-load 'ox '(add-to-list
                       'org-export-filter-timestamp-functions
                       'org-export-filter-timestamp-remove-brackets))
