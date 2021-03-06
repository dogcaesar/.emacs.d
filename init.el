;;; Init.el --- init file created from multiple sources
;;; Commentary:
;;; Init file created by David Ochoa combining other multiple files
;;; Code:

(require 'package)
(setq package-archives '(; ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))

(defvar my-packages '(
                      auto-complete
                      ;; ac-cider
                      ;; better-defaults
                      ;; cider
                      exec-path-from-shell
                      ;; find-file-in-project
                      idle-highlight-mode
                      ido-ubiquitous
                      flx-ido
                      markdown-mode
                      flycheck
                      flycheck-pos-tip
                      magit
                      smex
                      scpaste
                      polymode
                      textmate
                      volatile-highlights
                      yaml-mode
                      git-gutter-fringe+
                      rainbow-mode
                      fill-column-indicator
                      monokai-theme
                      ;; sr-speedbar
                      yasnippet
                      r-autoyas
                      expand-region
                      coffee-mode
                      web-mode
                      ))

(let ((default-directory "~/.emacs.d/elpa/"))
    (normal-top-level-add-to-load-path '("."))
    (normal-top-level-add-subdirs-to-load-path))

; install the missing packages
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; (setq redisplay-dont-pause t)
;; (setq scroll-margin 1
;;       scroll-conservatively 0
;;       scroll-up-aggressively 0.01
;;       scroll-down-aggressively 0.01)
;; (setq-default scroll-up-aggressively 0.01
;; 	      scroll-down-aggressively 0.01)

; Load theme
;; (add-to-list 'load-path "~/.emacs.d/themes/")
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(setq ;; foreground and background
 monokai-foreground     "#eeeeec"
 monokai-background     "#161719"
 ;; ;; highlights and comments
 ;; monokai-comments       "#F8F8F0"
 ;; monokai-emphasis       "#282C34"
 ;; monokai-highlight      "#FFB269"
 ;; monokai-highlight-alt  "#66D9EF"
 ;; monokai-highlight-line "#1B1D1E"
 ;; monokai-line-number    "#F8F8F0"
 ;; ;; colours
 ;; monokai-blue           "#61AFEF"
 ;; monokai-cyan           "#56B6C2"
 monokai-green          "LightSkyBlue"
 ;; monokai-gray           "#3E4451"
 ;; monokai-violet         "#C678DD"
 ;; monokai-red            "#E06C75"
 ;; monokai-orange         "#D19A66"
 ;; monokai-yellow         "#E5C07B"

 monokai-blue           "#729fcf"
 monokai-cyan           "dodger blue"
 monokai-green          "#6ac214"
 monokai-gray           "DimGray"
 monokai-violet         "IndianRed"
 monokai-red            "tomato"
 monokai-orange         "orange"
 monokai-yellow         "#edd400"

 )

(load-theme 'monokai t)

;; ; Font
;; set all windows (emacs's "frame") to use font DejaVu Sans Mono
(set-frame-font "Menlo-12" t t)
(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))

;; no toolbar
(tool-bar-mode -1)

;; no scrollbars
(scroll-bar-mode -1)

;; mark fill column
;; (require 'fill-column-indicator)

;; Better looking terminal windows
;; Space after line numbers
(when (not(display-graphic-p)) (add-hook 'window-configuration-change-hook
					 (lambda ()
					   (setq linum-format " %4d"))))
;; Turn off menu bar
(when (not(display-graphic-p)) (menu-bar-mode -1))

; Desactivate alarm
(setq ring-bell-function 'ignore)

;; Emacs will not automatically add new lines (stop scrolling at end of file)
(setq next-line-add-newlines nil)

; Prevent functions to access the clipboard
;; (setq x-select-enable-clipboard nil)

; Yes or No in one character
(defalias 'yes-or-no-p 'y-or-n-p)

; Get rid of temporary files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;smek provides the history on top of M-x
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize))

(textmate-mode)

;; Highlights volatile actitions such as paste
(require 'volatile-highlights)
(volatile-highlights-mode t)

; magit
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

;; yasnippet
(require 'yasnippet)
(yas/global-mode 1)

;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

; Ido to navigate the filesystem
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-use-virtual-buffers t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10
      ido-default-file-method 'selected-window
      ido-auto-merge-work-directories-length -1)

(ido-mode +1)
(ido-ubiquitous-mode +1)
;;; smarter fuzzy matching for ido
(flx-ido-mode +1)
;; disable ido faces to see flx highlights
(setq ido-use-faces nil)


(defun my-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (when (display-graphic-p) (fci-mode nil))
  (linum-mode 1)
  (rainbow-mode 1) ;; Rainbow colors
 )

; Load hook
(add-hook 'prog-mode-hook 'my-common-hook)

;; Activate flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
'(flycheck-lintr-caching nil)

;; Activate pos-tip
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

(defun my-css-mode-hook ()
  (rainbow-mode 1))
(add-hook 'css-mode-hook 'my-css-mode-hook)

;; Anything that writes to the buffer while the region is active will overwrite
;; it, including paste, but also simply typing something or hitting backspace
(delete-selection-mode 1)

; Autocomplete
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(ac-flyspell-workaround)
(define-key ac-complete-mode-map [tab] 'ac-expand)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
(define-key ac-completing-map (kbd "C-c h") 'ac-quick-help)

;; Electric pair, indentation, layout
(electric-indent-mode 1)
(electric-pair-mode 1)
(electric-layout-mode 1)

;; Indent code when pasting
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      python-mode
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))


; spell checker
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")

;; Allows the right alt key to work as alt
(setq ns-right-alternate-modifier nil)

; Some keybindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [C-tab] 'other-window) ;Change windows

; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))

; YAML mode
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; Load speedbar in the same frame, do not refresh it
;; automatically
;; (require 'sr-speedbar)
;; (add-hook 'speedbar-mode-hook (lambda () (linum-mode -1)))
;; ;; (sr-speedbar-open)
;; (sr-speedbar-refresh-turn-off)

;; Polymode
;;; R modes
(require 'poly-R)
(require 'poly-markdown) 
;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;;; R modes
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; Let you use markdown buffer easily
;; (setq ess-nuke-trailing-whitespace-p nil) 

;; Lintrs
(setq flycheck-lintr-linters "with_defaults(camel_case_linter=NULL, trailing_whitespace_linter=NULL,line_length_linter=lintr::line_length_linter(120))")





; Variables I set up from within emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-move-point-for-output t)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 ;; '(compilation-ask-about-save nil)
 ;; '(compilation-auto-jump-to-first-error nil)
 ;; '(compilation-environment nil)
 ;; '(compilation-message-face (quote default))
 ;; '(compilation-read-command nil)
 ;; '(compilation-scroll-output (quote first-error))
 ;; '(compile-command "make -k")
 '(custom-safe-themes
   (quote
    ("f81a9aabc6a70441e4a742dfd6d10b2bae1088830dc7aba9c9922f4b1bd2ba50" default)))
 '(ess-R-font-lock-keywords
   (quote
    ((ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:constants . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers . t)
     (ess-R-fl-keyword:F&T . t))))
 '(fci-rule-column 120)
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(flycheck-lintr-caching nil)
 '(global-flycheck-mode t)
 '(global-linum-mode nil)
 '(inferior-R-font-lock-keywords
   (quote
    ((ess-S-fl-keyword:prompt n\. t)
     (ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:constants . t)
     (ess-R-fl-keyword:messages . t)
     (ess-fl-keyword:matrix-labels . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers . t)
     (ess-R-fl-keyword:F&T))))
 '(inhibit-startup-screen t)
 '(initial-scratch-message "")
 '(linum-delay t)
 '(linum-eager t)
 '(linum-format " %4d")
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (monokai-theme flycheck-pos-tip yaml-mode web-mode volatile-highlights textmate termbright-theme tangotango-theme tango-2-theme smex scpaste rainbow-mode r-autoyas pos-tip polymode noctilux-theme markdown-mode magit ido-ubiquitous idle-highlight-mode git-gutter-fringe+ flycheck flx-ido fill-column-indicator expand-region exec-path-from-shell color-theme-sanityinc-tomorrow color-theme coffee-mode auto-complete)))
 '(show-paren-mode t)
 '(vc-annotate-background-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-fringe-error ((t (:background "#161719" :foreground "#F92672" :weight bold))))
 '(flycheck-fringe-info ((t (:background "#161719" :foreground "#66D9EF" :weight bold))))
 '(flycheck-fringe-warning ((t (:background "#161719" :foreground "#E6DB74" :weight bold))))
 '(mode-line-buffer-id ((t (:foreground "#66D9EF" :weigth bold)))))

;; Mark additions/deletions in a git repo, on the margin
(require 'git-gutter-fringe+)
(global-git-gutter+-mode t)

(setq-default left-fringe-width  15)

;; Color of the fringe
;; (set-face-background 'fringe "#161719")

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))

; For R. The first two lines are needed *before* loading 
; ess, to set indentation to two spaces
(setq ess-default-style 'DEFAULT)
(setq ess-indent-level 2)
(setq ess-history-directory "~/.R/")

;; Adapted with one minor change from Felipe Salazar at
;; http://www.emacswiki.org/emacs/EmacsSpeaksStatistics
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
;;(setq inferior-R-program-name "/usr/local/bin/R")
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)


;; To compile closest Makefile
(require 'cl) ; If you don't have it already
(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
		      (loop 
		       for d = default-directory then (expand-file-name ".." d)
		       if (file-exists-p (expand-file-name file d))
		       return d
		       if (equal d root)
		       return nil))))

(require 'compile)
;; (add-hook 'markdown-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "make -f %s" (get-closest-pathname)))))
;; (add-hook 'ess-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "make -f %s" (get-closest-pathname)))))

;; Limit buffer size
(add-to-list 'comint-output-filter-functions 'comint-truncate-buffer)

(defun my-ess-start-R ()
  (interactive)
  (or (assq 'inferior-ess-mode
            (mapcar 
              (lambda (buff) (list (buffer-local-value 'major-mode buff)))
              (buffer-list)))
   (progn
     (delete-other-windows)
     (setq w1 (selected-window))
     (setq w1name (buffer-name))
     (setq w2 (split-window w1 nil t))
     (R)
     (set-window-buffer w2 "*R*")
     (set-window-buffer w1 w1name))))

(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))

(defun my-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (when (display-graphic-p) (fci-mode nil))
  (linum-mode 1)
  (rainbow-mode 1) ;; Rainbow colors
  )

(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)
	     (linum-mode t) ;show line numbers
	     (when (display-graphic-p) (fci-mode nil))
	     (set (make-local-variable 'compile-command) (format "make -f %s " (get-closest-pathname)))
	     ))

(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [up] 'comint-previous-input)
             (local-set-key [down] 'comint-next-input)))

(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)
	     (linum-mode t) ;show line numbers
	     (when (display-graphic-p) (fci-mode nil))
	     ))

(setq-default fill-column 120)

(add-hook 'markdown-mode-hook
	  (lambda ()
	    (linum-mode t)
	    (when (display-graphic-p) (fci-mode nil))
	    (set (make-local-variable 'compile-command) (format "make -f %s " (get-closest-pathname)))
	    ))

(require 'ess-site)


; does not work for if you press `M-;`, but does work for <TAB>
(setq ess-fancy-comments nil)
(setq ess-indent-level 2)
; from http://stackoverflow.com/a/25219054/2723794 thank god, ESS apparently considers function bodies to be "continued statements", which are apparently independent of indent level! sheesh
(setq ess-first-continued-statement-offset 2
      ess-continued-statement-offset 0)

;; Some keys for ESS
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])

(defun my-ess-post-run-hook ()
  (local-set-key "\C-cw" 'ess-execute-screen-options))
(add-hook 'ess-post-run-hook 'my-ess-post-run-hook)

;; ???
(setq url-http-attempt-keepalives nil)

(eval-after-load "comint"
  '(progn
     (define-key comint-mode-map [up]
       'comint-previous-matching-input-from-input)
     (define-key comint-mode-map [down]
       'comint-next-matching-input-from-input)
     ;; also recommended for ESS use --
     (setq comint-scroll-to-bottom-on-output nil)
     (setq comint-scroll-show-maximum-output nil)
     ;; somewhat extreme, almost disabling writing in *R*,
     ;; *shell* buffers above prompt:
     (setq comint-scroll-to-bottom-on-input 'this)
     ))

(require 'r-autoyas)

(defun my-ess-mode-hook ()
  ; Do not replace _ with <-
  (ess-toggle-underscore nil)
  ;; ;; r-autoyas
  (r-autoyas-ess-activate)
  ;; (fci-mode nil)
  (rainbow-mode 1) ;; Rainbow colors
)

(add-hook 'ess-mode-hook 'my-ess-mode-hook)

; Save/load history of minibuffer
(savehist-mode 1)


;; ;;coffee-script
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
(define-key coffee-mode-map [(meta R)] 'coffee-compile-region)

(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))


;; (set-face-attribute 'ac-candidate-face nil   :background "#00222c" :foreground "light gray")
;; (set-face-attribute 'ac-selection-face nil   :background "SteelBlue4" :foreground "white")
;; (set-face-attribute 'popup-tip-face    nil   :background "#003A4E" :foreground "light gray")

(add-hook 'ess-mode (lambda () (add-to-list 'ac-sources 'ac-source-R)))


;; Play with window sizes
(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)


;; (defvar sanityinc/fci-mode-suppressed nil)
;; (defadvice popup-create (before suppress-fci-mode activate)
;;   "Suspend fci-mode while popups are visible"
;;   (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-mode)
;;   (when fci-mode
;;     (turn-off-fci-mode)))
;; (defadvice popup-delete (after restore-fci-mode activate)
;;   "Restore fci-mode when all popups have closed"
;;   (when (and (not popup-instances) sanityinc/fci-mode-suppressed)
;;     (setq sanityinc/fci-mode-suppressed nil)
;;     (turn-on-fci-mode)))

;;; Transparency (in standalone X11) ;;;
; from http://www.emacswiki.org/emacs/TransparentEmacs#toc1
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
;; (set-frame-parameter (selected-frame) 'alpha '(100 85))
;; (add-to-list 'default-frame-alist '(alpha 100 85))
;; ; use C-c t to turn on/off transparency?
;; (eval-when-compile (require 'cl))
;; (defun toggle-transparency ()
;;   (interactive)
;;   (if (/=
;;        (cadr (frame-parameter nil 'alpha))
;;        100)
;;       (set-frame-parameter nil 'alpha '(100 100))
;;     (set-frame-parameter nil 'alpha '(100 85))))
;; (global-set-key (kbd "C-c t") 'toggle-transparency)

;;; Whitespace. ;;;
; Show tabs
;; (setq white-space-style '(tabs tab-mark))
; Show trailing whitespace

;;; Windowing. ;;;
; Winner mode, which makes it easy to go back/forward in window changes
; This uses "C-c left/right" to remember window stuff
;; (when (fboundp 'winner-mode)
;;      (winner-mode 1))

(require 'expand-region)
(global-set-key (kbd "C-<") 'er/expand-region)

