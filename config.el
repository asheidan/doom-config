;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Emil Eriksson"
      user-mail-address "emil.eriksson@codemill.se")

(setq system-time-locale "en_GB.UTF-8")

;; Fix option-key
;(setq default-input-method "MacOSX")
;(defvar mac-command-modifier)
;(defvar mac-allow-anti-aliasing)
;(defvar mac-command-key-is-meta)
(if (string-equal system-type "darwin")
    (setq mac-option-modifier nil
      mac-command-modifier 'meta
      mac-allow-anti-aliasing t
      mac-command-key-is-meta t))
;(defvar x-meta-keysym)
;(defvar x-super-keysym)
(if (string-equal system-type "gnu/linux")
    (setq x-meta-keysym 'super
          x-super-keysym 'meta))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(if (string-equal system-type "darwin")
    (setq doom-font (font-spec :family "ProFontIIx Nerd Font" :size 9))
  (setq doom-font (font-spec :family "ProFontWindows" :size 12)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-opera-light)
(setq doom-themes-enable-bold nil)
(setq doom-themes-enable-italic nil)
(setq doom-themes-treemacs-theme "doom-colors")
(setq doom-themes-treemacs-enable-variable-pitch nil)

(setq calendar-week-start-day 1)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(use-package! org
  :init
  (setq org-directory "~/Worklog/")
  (setq +org-capture-todo-file "inbox.org")
  (setq-default org-agenda-files '("~/Worklog/current.org"
                                   "~/Worklog/inbox.org"
                                   "~/Worklog/2020/12 December"
                                   "~/Worklog/2021/01 January"
                                   "~/Worklog/2021/02 February"
                                   "~/Worklog/Codemill"))
  :config
  (setq org-eldoc-breadcrumb-separator " > ") ; Tried with setq-default and :init which didn't seem to work
  (remove-hook 'org-mode-hook #'org-superstar-mode)
  (defun my-refile-targets ()
    (interactive)
    (concat org-directory (format-time-string "/%Y/%m %B/%Y-%m-%d.org" (current-time))))
  ;:custom
  (setq org-startup-folded t)

  (setq org-log-done 'time)  ;Logging when tasks are done
  (setq org-log-into-drawer "LOGBOOK")
  (setq org-log-state-notes-insert-after-drawers t)

  ; Agenda
  (setq org-deadline-warning-days 5)
  (setq org-agenda-span 'day)  ;Show single day by default
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-start-day nil)  ;Start the agenda today

  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)

  (setq org-agenda-time-grid '((daily today require-timed remove-match) (800 1000 1200 1400 1600 1800)
                          "......" "----------------"))
  (setq org-agenda-clock-consistency-checks
   '(:max-duration "10:00" :min-duration 1 :max-gap "0:05" :gap-ok-around ("4:00")
     :default-face ((:background "DarkRed") (:foreground "white"))
     :overlap-face nil :gap-face nil :no-end-time-face nil :long-face nil :short-face nil))
  (setq org-agenda-clockreport-parameter-plist
   '(:link t :maxlevel 3 :fileskip0 t :step day :stepskip0 t))


  ; Clocking
  (setq org-clock-persist 'history)
  (setq org-clock-persist-query-resume nil)  ;Do not prompt to resume an active clock, just resume it

  (setq org-clock-out-remove-zero-time-clocks t)  ;Remove empty clocklines
  (setq org-clock-out-when-done nil)  ;Should we clock-out when marking as done
  (setq org-clock-clocked-in-display nil)  ;Don't display clock. Clock display does not seem to work with doom-modeline.
  (setq org-clock-in-resume t)  ;Resume clocking task on clock-in if the clock is open

  ; Todo
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")
                       (sequence "WAIT(w@/!)" "|")
                       (sequence "|" "CANCELED(c@)")))
  (setq org-highest-priority ?A)
  (setq org-default-priority ?C)
  (setq org-lowest-priority ?E)

  ; Refile
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes t)
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-targets '((my-refile-targets :level . 1)
                        ("~/Worklog/current.org" :maxlevel . 1)
                                        ;("~/Worklog/inbox.org" :level 0)
                        ("~/Worklog/Codemill/recurring.org" :maxlevel . 1)
                        ("~/Worklog/Codemill/longterm.org" :maxlevel . 1)))

  (setq org-tags-exclude-from-inheritance '("PROJECT" "GOAL"))
  (setq org-tag-alist '((:startgrouptag) ("work") (:grouptags) ("codemill") ("pro7") (:endgrouptag)
                   (:startgrouptag) ("pro7") (:grouptags) ("ucp") (:endgrouptag)
                   (:startgrouptag) ("codemill") (:grouptags) ("ap_com") (:endgrouptag)))
  :custom-face
  (org-drawer ((t (:inherit org-meta-line)))))

(after! org-roam
  ; Workaround for https://github.com/org-roam/org-roam/issues/1400
  (setq org-roam-db-location "~/.emacs.d/.local/etc/org-roam.workaround.db"))

(use-package! org-roam
  ;:custom
  :init
  (setq org-roam-directory "~/Brain")
  :config
  (setq org-roam-tag-sources '(prop all-directories))
  (setq org-roam-capture-templates '(("d" "default" plain (function org-roam--capture-get-point)
                                 "%?"
                                 :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                 :head "#+title: ${title}\n"
                                 :unnarrowed t)
                                ("y" "Youtube" plain (function org-roam--capture-get-point)
                                 "%?"
                                 :file-name "Youtube/%<%Y%m%d%H%M%S>-${slug}"
                                 :head "#+title: ${title}\n"
                                 :unnarrowed t)
                                ("g" "Game" plain (function org-roam--capture-get-point)
                                 "%?"
                                 :file-name "Game/%<%Y%m%d%H%M%S>-${slug}"
                                 :head "#+title: ${title}\n"
                                 :unnarrowed t)))
  (setq org-roam-dailies-directory "Daily/")
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" entry
           #'org-roam-capture--get-point
           "* %<%H:%M>\n%?"
           ;:immediate-finish t  ; This would end the capture directly
           ;:unnarrowd t  ; This would show the entire file after capture
           :file-name "Daily/%<%Y/%Y-%m-%d>"
           :olp ("Journal")
           :head "#+title: %<%Y-%m-%d>\n\n"))))
(map! :leader
      :desc "" "n r d c" #'org-roam-dailies-capture-today)


(defun my-days-ago (days)
  (format-time-string "%Y-%m-%d"
                      (time-subtract (current-time)
                                     (days-to-time days))))
(use-package org-super-agenda
  :after org-agenda
  :init
  (org-super-agenda-mode)
  :config
  ;:custom
  (setq org-super-agenda-groups
   `((:name "Schedule"
      :time-grid t)
     (:name "Important"
      :and (:priority "A"
            :todo "TODO"))
     (:name "Stale"
      :scheduled (before ,(my-days-ago 30))
      :deadline (before ,(my-days-ago 30))
      :order 200)
     (:name "Waiting"
      :todo "WAIT"
      :order 100)))
  ;:bind (:map org-super-agenda-header-map ("k" . evil-previous-line) ("j" . evil-next-line))
  )
(map! :map org-mode-map
      :localleader "s c" #'org-columns)

(map! :map org-super-agenda-header-map
      :n
      "k" #'evil-previous-line
      "j" #'evil-next-line)


(defun my-ignore-pycache (filename absolute-path)
  (or (string-equal "__pycache__" filename)
      (string-suffix-p ".pyc" filename)))

(use-package! treemacs
  :config
  (add-to-list 'treemacs-ignored-file-predicates #'my-ignore-pycache)
  :custom
  (treemacs-collapse-dirs 10)
  (treemacs-filewatch-mode t)
  (treemacs-show-hidden-files nil))

; Documentation lookups
; To open results from +lookup/online in EWW instead of your system browser, change +lookup-open-url-fn (default: #'browse-url):
(setq +lookup-open-url-fn #'eww)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
