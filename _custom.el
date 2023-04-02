;; Run Emacs GUI in maximized state.
(add-to-list 'initial-frame-alist '(fullscreen . maximized))


;; Make the cursor blinking.
(blink-cursor-mode)


;; Increase default column length.
(setq-default fill-column 120)


;; Map key for redo undo.
(map! :desc "Redo undo" :n "U" #'redo)


;; Bind key to list bookmarks.
(map! :leader (:prefix-map ("b" . "buffer") :desc "List bookmarks" "L" #'list-bookmarks))


;; Bind key to change tab groups.
(use-package! centaur-tabs
  :config
  (map! :leader :desc "Change tab-groups" "T" #'centaur-tabs-switch-group))


;(use-package! whitespace
;  :config
;  (setq
;   global-whitespace-mode t
;   whitespace-style '(face tabs spaces trailing lines space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark)
;   whitespace-display-mappings '(
;                                 (space-mark   ?\     [?\u00B7]     [?.])
;                                 (space-mark   ?\xA0  [?\u00A4]     [?_])
;                                 (newline-mark ?\n    [?¬ ?\n])
;                                 (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t]))))


;; Alternate whitespace-mode with whitespace.el defaults, doom defaults and off.
(progn
  (defun merzu/set-whitespace-defaults ()
    ;; only save the values the first time we get here
    (unless (boundp 'merzu/default-whitespace-style)
      (setq-local merzu/default-whitespace-style (default-value 'whitespace-style)
                  merzu/default-whitespace-display-mappings (default-value 'whitespace-display-mappings)
                  merzu/doom-whitespace-style whitespace-style
                  merzu/doom-whitespace-display-mappings whitespace-display-mappings
                  merzu/whitespace-mode "doom")))

  ;; whitespace-style etc are set up with default-values in whitespace.el and then
  ;; modified in doom-highlight-non-default-indentation-h (in core/core-ui.el).
  ;; This is added to after-change-major-mode-hook in doom-init-ui-h (in
  ;; core/core-ui.el) and called a LOT: so I need to capture doom's modified
  ;; settings after that. The trouble is, this file (config.el) is called _before_
  ;; doom-init-ui-h which is called in window-setup-hook as the last gasp of
  ;; doom-initialize! find-file-hook appears to work.
  (add-hook! 'find-file-hook #'merzu/set-whitespace-defaults 'append)

  ;; doom=>default=>off=>doom=>...
  (defun merzu/toggle-whitespace ()
    (interactive)
    (cond ((equal merzu/whitespace-mode "doom")
           (setq-local whitespace-style merzu/default-whitespace-style
                       whitespace-display-mappings merzu/default-whitespace-display-mappings
                       merzu/whitespace-mode "default")
           (message "Whitespace mode is whitespace default")
           (whitespace-mode))
          ((equal merzu/whitespace-mode "default")
           (setq-local merzu/whitespace-mode "off")
           (message "Whitespace mode is off")
           (whitespace-mode -1))
          (t ; (equal merzu/whitespace-mode "off")
           (setq-local whitespace-style merzu/doom-whitespace-style
                       whitespace-display-mappings merzu/doom-whitespace-display-mappings
                       merzu/whitespace-mode "doom")
           (message "Whitespace mode is doom default")
           (whitespace-mode))))

  (map! :leader (:prefix-map ("t" . "toggle") :desc "Toggle whitespace characters" "W" #'merzu/toggle-whitespace)))


;; Use Wakatime to monitor coding activity.
(use-package! wakatime-mode
  :defer t
  :init
  (add-hook! 'prog-mode-hook #'wakatime-mode)
  :config
  ;; (setq wakatime-cli-path (file-truename "~/.local/bin/wakatime"))
  (setq wakatime-cli-path (file-truename "~/GitHub/wakatime-cli/build/wakatime-cli-linux-amd64"))
  (defun merzu/wakatime-dashboard ()
    (interactive)
    (browse-url "https://wakatime.com/dashboard"))
  (map! :leader (:prefix-map ("o" . "open") :desc "Open Wakatime dashboard in browser" "W" #'merzu/wakatime-dashboard)))


;; Handle Vim modeline in Emacs.
(use-package! vim-modeline
  :init
  (add-hook 'find-file-hook #'vim-modeline/do 'append))


;; Add TTCN-3 syntax support.
(use-package! ttcn-3-mode
  :mode "\\.ttcn")


;; LSP config.
(use-package! lsp-mode
  :config
  (setq lsp-lens-enable nil
        lsp-file-watch-threshold 3000))

(use-package! lsp-java
  :config
  (setq lsp-java-java-path "/usr/lib/jvm/openjdk-bin-11/bin/java"))


;; Org config.
(use-package! org
  :config
  (setq org-directory "~/Documents/org"))

(use-package! org-modern
  :init
  (add-hook! 'org-mode-hook #'org-modern-mode)
  :config
  (map! :localleader
        :map org-mode-map
        :desc "Toggle Org Modern" "M" #'org-modern-mode))


;; Deft (notes) config.
(use-package! deft
  :config
  (map! :leader :desc "Find deft notes" "N" #'deft-find-file)
  (setq deft-directory "~/Documents/notes"
        deft-extensions '("txt" "org" "md" "tex")))


;; Language tool (grammar checking) config.
(use-package! langtool
  :config
  (setq langtool-bin "/usr/bin/languagetool"))


;; Treemacs config.
(use-package! treemacs-all-the-icons
  :config
  (treemacs-load-theme 'all-the-icons)
  (setq doom-themes-treemacs-theme 'all-the-icons)
  (map! :desc "Select Treemacs window" "<f8>" #'treemacs-select-window))
