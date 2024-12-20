(setq inhibit-startup-message t)
(setq visible-bell t)

;; Turn off some unneeded UI elements
(menu-bar-mode -1)  ; Leave this one on if you're a beginner!
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (R . t)
   (emacs-lisp . nil)))

(add-hook 'org-mode-hook 'org-indent-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vterm which-key ess snakemake-mode pdf-tools magit evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq font-latex-fontify-sectioning 1)

(find-file "/Users/guillo0001/LabNotebook/journal.org") 

(setq org-default-notes-file "/Users/guillo0001/LabNotebook/journal.org")
(global-set-key (kbd "C-c c") #'org-capture)

(defconst journal-path "/Users/guillo0001/LabNotebook/journal.org")

(defun today-journal ()
  "Open today's journal."
  (interactive)
    (find-file journal-path))

(global-set-key (kbd "C-x j") 'today-journal)

(ido-mode 1)

(require 'which-key)
(which-key-mode)
(which-key-setup-side-window-bottom)
