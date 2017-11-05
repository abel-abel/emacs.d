;; Sun Oct 29 23:24:21 CST 2017

(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
			 ("melpa" . "http://elpa.emacs-china.org/melpa/")))
(package-initialize)
(add-to-list 'default-frame-alist
	     '(font . "Source Code Pro-15"))

;; disable toolbar
(tool-bar-mode -1)

;; disable menubar
(menu-bar-mode -1)

;; Emacs frame transparency
;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
;;(set-frame-parameter (selected-frame) 'alpha <both>)
(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
(add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; visit soft link without asking
(setq vc-follow-symlinks nil)

;; ==================================================
;; Packages Installation
;; ==================================================
(setq use-package-always-ensure t)

;; (use-package ahungry-theme)
;; (use-package github-theme)
(if (display-graphic-p)
    (load-theme 'github t)
  (load-theme 'ahungry t))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package
  lispy
  :config (add-hook
	   'emacs-lisp-mode-hook
	   (lambda () (lispy-mode 1))))

(use-package swiper)
(use-package counsel
  :config
  (ivy-mode 1)
  (setq ivy-use-selectable-prompt t)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key read-expression-map (kbd "C-r") 'counsel-expression-history))

(use-package hydra
  :config
  (defhydra hydra-zoom (global-map "<f2>")
    "zoom"
    ("g" text-scale-increase "in")
    ("l" text-scale-decrease "out"))

  (defhydra hydra-buffer-menu (:color pink
				      :hint nil)
    "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
    ("m" Buffer-menu-mark)
    ("u" Buffer-menu-unmark)
    ("U" Buffer-menu-backup-unmark)
    ("d" Buffer-menu-delete)
    ("D" Buffer-menu-delete-backwards)
    ("s" Buffer-menu-save)
    ("~" Buffer-menu-not-modified)
    ("x" Buffer-menu-execute)
    ("b" Buffer-menu-bury)
    ("g" revert-buffer)
    ("T" Buffer-menu-toggle-files-only)
    ("O" Buffer-menu-multi-occur :color blue)
    ("I" Buffer-menu-isearch-buffers :color blue)
    ("R" Buffer-menu-isearch-buffers-regexp :color blue)
    ("c" nil "cancel")
    ("v" Buffer-menu-select "select" :color blue)
    ("o" Buffer-menu-other-window "other-window" :color blue)
    ("q" quit-window "quit" :color blue))

  (define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body))

(use-package
  ace-window
  :ensure t
  :defer 1
  :config
  (global-set-key (kbd "M-p") 'ace-window)
  (set-face-attribute
   'aw-leading-char-face
   nil
   :foreground "deep sky blue"
   :weight 'bold
   :height 3.0)
  (set-face-attribute
   'aw-mode-line-face
   nil
   :inherit 'mode-line-buffer-id
   :foreground "lawn green")
  (setq aw-keys
	'(?a ?s ?d ?f ?j ?k ?l)
	aw-dispatch-always
	t
	aw-dispatch-alist
	'((?x
	   aw-delete-window
	   "Ace - Delete Window")
	  (?c
	   aw-swap-window
	   "Ace - Swap Window")
	  (?n aw-flip-window)
	  (?v
	   aw-split-window-vert
	   "Ace - Split Vert Window")
	  (?h
	   aw-split-window-horz
	   "Ace - Split Horz Window")
	  (?m
	   delete-other-windows
	   "Ace - Maximize Window")
	  (?g delete-other-windows)
	  (?b balance-windows)
	  (?u winner-undo)
	  (?r winner-redo)))
  (when (package-installed-p 'hydra)
    (defhydra hydra-window-size (:color red)
      "Windows size"
      ("h"
       shrink-window-horizontally
       "shrink horizontal")
      ("j"
       shrink-window
       "shrink vertical")
      ("k"
       enlarge-window
       "enlarge vertical")
      ("l"
       enlarge-window-horizontally
       "enlarge horizontal"))
    (defhydra hydra-window-frame (:color red)
      "Frame"
      ("f" make-frame "new frame")
      ("x"
       delete-frame
       "delete frame"))
    (defhydra hydra-window-scroll (:color red)
      "Scroll other window"
      ("n"
       joe-scroll-other-window
       "scroll")
      ("p"
       joe-scroll-other-window-down
       "scroll down"))
    (add-to-list
     'aw-dispatch-alist
     '(?w hydra-window-size/body)
     t)
    (add-to-list
     'aw-dispatch-alist
     '(?o hydra-window-scroll/body)
     t)
    (add-to-list
     'aw-dispatch-alist
     '(?\; hydra-window-frame/body)
     t))
  (ace-window-display-mode t))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package company)
(use-package auto-complete)

(use-package tuareg
  :config
  (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
  (setq auto-mode-alist
	(append '(("\\.ml[ily]?$" . tuareg-mode)
		  ("\\.topml$" . tuareg-mode))
		auto-mode-alist))
  (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (add-hook 'tuareg-mode-hook 'auto-complete-mode))

(use-package utop
  :config
  (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t))

(use-package merlin
  :config
  (setq merlin-use-auto-complete-mode t)
  (setq merlin-error-after-save nil))

(use-package ocp-indent)
