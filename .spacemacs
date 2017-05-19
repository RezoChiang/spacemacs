(defvar rezo-const-full-date "%Y/%m/%d" "完整日期格式")
(defvar rezo-const-full-datetime "%Y/%m/%d %H:%M" "完整日期时间格式")
(defvar rezo-const-short-date "%m.%d" "时间格式")
;; 用户信息: 注意FreeBSD无法通过getenv获取到当前用户名
(defvar rezo-name-user "rezo" "用户名")
(defvar rezo-name-full "Rezo.Chiang" "用户全名")
(defvar rezo-email-address1 "rezo@live.cn" "email地址")

(defvar rezo-dir-home (getenv "HOME") "定义用户根目录" )
(defvar rezo-dir-default (expand-file-name "file" rezo-dir-home) "各项目文件存放根路径" )
(defvar rezo-gdt-dir (expand-file-name "proj_gdt" rezo-dir-default) "gdt根目录" )
(defvar rezo-dir-snippet (expand-file-name "proj_rezo_snippets" rezo-dir-default)  "yassnippets文件根目录" )
(defvar rezo-dir-remember (expand-file-name "proj_rezo_remember" rezo-dir-default) "remember文件目录" )

(defvar rezo-gdt-code (expand-file-name "code.org" rezo-gdt-dir) "代码或技术备注文件存放路径" )
(defvar rezo-gdt-idea (expand-file-name "idea.org" rezo-gdt-dir) "GDT初步设想记录文件存放路径" )
(defvar rezo-gdt-note (expand-file-name "note.org" rezo-gdt-dir) "GDT笔记文件存放路径" )
(defvar rezo-gdt-other (expand-file-name "inbox.org" rezo-gdt-dir) "GDT杂项文件存放路径" )
(defvar rezo-gdt-project (expand-file-name "project.org" rezo-gdt-dir) "GDT项目或计划存放路径" )
(defvar rezo-gdt-question (expand-file-name "question.org" rezo-gdt-dir) "GDT问题记录文件存放路径" )
(defvar rezo-gtd-review (expand-file-name "review.org" rezo-gdt-dir) "GDT回溯反思文件存放路径" )
(defvar rezo-gdt-task (expand-file-name "task.org" rezo-gdt-dir) "GDT任务文件存放路径" )


;; 定义编码
(defvar rezo-coding-default 'utf-8 "默认编码设置")

;; (setq debug-on-error t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode 1)

;; 设置编码
(set-language-environment rezo-coding-default)
(set-keyboard-coding-system rezo-coding-default)
(set-clipboard-coding-system rezo-coding-default)
(set-terminal-coding-system rezo-coding-default)
(set-buffer-file-coding-system rezo-coding-default)
(set-selection-coding-system rezo-coding-default)

(setq-default
 pathname-coding-system rezo-coding-default

 ;; dotspacemacs-themes '(spacemacs-light)
 dotspacemacs-themes '(molokai)

 display-time-interval 10

 dotspacemacs-default-font '("DejaVu Sans Mono"
                             :size 9.2
                             :weight normal
                             :width normal
                             :powerline-scale 1.2)

 org-log-done 'time
 org-log-done 'note

 dotspacemacs-check-for-update nil


 dotspacemacs-configuration-layers '( auto-completion
                                      command-log
                                      shell
                                      org
                                      react
                                      c-c++
                                      shell-scripts
                                      sql
                                      markdown
                                      ruby
                                      javascript
                                      lua
                                      php
                                      html
                                      git
                                      )

 dotspacemacs-additional-packages '( molokai-theme
                                     zen-and-art-theme
                                     tangotango-theme
                                     espresso-theme
                                     twilight-bright-theme
                                     lua-mode
                                     js2-mode
                                     web-mode
                                     yasnippet
                                     origami
                                     swiper
                                     rainbow-mode
                                     git-timemachine
                                     company
                                     ;; multiple-cursor-mode
                                     )
 ;; A list of packages that cannot be updated.
 dotspacemacs-frozen-packages '()
 ;; A list of packages that will not be installed and loaded.
 dotspacemacs-excluded-packages '()
 )
;; 使用avy-goto-char切换窗口(替换掉ace-window)
(global-set-key (kbd "C-x j") 'avy-goto-char)

;; remember快捷键
(global-set-key (kbd "M-<f12>") 'remember)

;; org-agenda日程快捷键
(global-set-key (kbd "M-<f11>") 'org-agenda)

;; 如果是GUI下,取消退出快捷键
(if (not(eq window-system 'nil))
    (global-unset-key (kbd "C-x C-c")))

;; org模式下的自动换行
;; (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(defun rezo-org-capture-tpl-code()
  (let ((initial (plist-get org-store-link-plist :initial))
        (annotation (plist-get org-store-link-plist :annotation))
        (date (format-time-string rezo-const-full-date (current-time)))
        (now (format-time-string rezo-const-full-datetime (current-time))))

    (concat "* [" date "] %^{keywords, cause or purpose} \t%^g\n"
            (if (and initial (> (length initial) 0))
                (concat 
                 "** From: " annotation "\n"
                 "** Code Reference: \n"
                 "#+NAME: %^{usage}\n"
                 "# key: src\n# expand-env: ((yas/indent-line 'fixed) (yas/wrap-around-region 'nil))\n"
                 "# --\n"
                 "#+BEGIN_SRC %^{language}\n"
                 initial
                 "\n#+END_SRC\n"))
            "** [" now "] Comments: \n%?" )))


(defun rezo-org-capture-tpl-other()
  (let ((initial (plist-get org-store-link-plist :initial))
        (annotation (plist-get org-store-link-plist :annotation))
        (date (format-time-string rezo-const-full-date (current-time)))
        (now (format-time-string rezo-const-full-datetime (current-time))))

    (concat "* [" date "] %^{keywords, cause or purpose}\t%^g\n"
            (if (and initial (> (length initial) 0))
                (concat 
                 "** From: " annotation "\n"
                 "** Reference: \n"
                 "#+BEGIN_QUOTE\n"
                 initial
                 "\n#+END_QUOTE\n"))
            "** [" now "] Comments: \n%?" )))


(defun rezo-org-capture-tpl-idea()
  (let ((initial (plist-get org-store-link-plist :initial))
        (annotation (plist-get org-store-link-plist :annotation))
        (date (format-time-string rezo-const-full-date (current-time)))
        (now (format-time-string rezo-const-full-datetime (current-time))))
    (concat "* %^{todo sequence|MAYBE|WAITTING|TODO} [" date "] %^{keywords, cause or purpose} \t%^g\n"
            "  SCHEDULED:%^t \t DEADLINE:%^t\n"
            (if (and initial (> (length initial) 0))
                (concat 
                 "** From: " annotation "\n"
                 "** Reference: \n"
                 "#+BEGIN_QUOTE\n"
                 initial
                 "\n#+END_QUOTE\n"))
            "** Risk,Questions & Review: \n"
            "** Commemts: \n%?")))


(defun rezo-org-capture-tpl-question()
  (let ((initial (plist-get org-store-link-plist :initial))
        (annotation (plist-get org-store-link-plist :annotation))
        (date (format-time-string rezo-const-full-date (current-time)))
        (now (format-time-string rezo-const-full-datetime (current-time))))
    (concat "* [" date "] %?? \t%^g\n"
            (if (and initial (> (length initial) 0))
                (concat 
                 "** From: " annotation "\n"
                 "** Reference: \n"
                 "#+BEGIN_QUOTE\n"
                 initial
                 "\n#+END_QUOTE\n"))
            "** Target, Scope & Cost: \n")))


(defun rezo-org-capture-tpl-task()
  (let ((initial (plist-get org-store-link-plist :initial))
        (annotation (plist-get org-store-link-plist :annotation))
        (date (format-time-string rezo-const-full-date (current-time)))
        (now (format-time-string rezo-const-full-datetime (current-time))))
    (concat "* %^{todo sequence|TODO|WAITTING|MAYBE} %^{Priority|[#B]|[#A]|[#C]|} [" date "] %?\t%^g\n"
            "  SCHEDULED:%^t \t DEADLINE:%^t\n"
            (if (and initial (> (length initial) 0))
                (concat 
                 "** From: " annotation "\n"
                 "** Reference: \n"
                 "#+BEGIN_QUOTE\n"
                 initial
                 "\n#+END_QUOTE\n"))
            "** Requirement: \n"
            "** Daily Report: \n"
            "** Risk: \n"
            "** Questions: \n"
            "** Review: \n")))

;; 定义org-agenda读取的文件
(setq org-agenda-files (list rezo-gdt-idea
                             rezo-gdt-task))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-todo-keywords
   (quote
    ((sequence "MAYBE(m!)" "TODO(t@/!)" "PROCESSED(p@/!)" "WAITTING(w@/!)" "|" "DONE(d@/!)" "ABORT(a@/!)"))))
 '(browse-url-browser-function (quote eww-browse-url))
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(custom-safe-themes
   (quote
    ("357d5abe6f693f2875bb3113f5c031b7031f21717e8078f90d9d9bc3a14bcbd8" "c1390663960169cd92f58aad44ba3253227d8f715c026438303c09b9fb66cdfb" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" default)))
 '(evil-want-Y-yank-to-eol nil)
 '(org-capture-templates
   (quote
    (("c" "Code" plain
      (file rezo-gdt-code "Code")
      "%(rezo-org-capture-tpl-code)")
     ("i" "Idea" entry
      (file rezo-gdt-idea "Idea")
      "%(rezo-org-capture-tpl-idea)")
     ("n" "Note" entry
      (file rezo-gdt-note "Note")
      "%(rezo-org-capture-tpl-other)")
     ("o" "Other" entry
      (file rezo-gdt-other "Other")
      "%(rezo-org-capture-tpl-other)")
     ("Q" "Question" entry
      (file rezo-gdt-question "Question")
      "%(rezo-org-capture-tpl-question)")
     ("t" "Task" entry
      (file rezo-gdt-task "Task")
      "%(rezo-org-capture-tpl-task)"))))
 '(package-selected-packages
   (quote
    (ivy powerline pcre2el spinner alert log4e gntp markdown-mode skewer-mode simple-httpd json-snatcher json-reformat multiple-cursors js2-mode hydra parent-mode projectile pkg-info epl request haml-mode gitignore-mode flx magit magit-popup git-commit with-editor smartparens iedit anzu evil goto-chg undo-tree highlight f php-mode diminish web-completion-data s dash-functional tern dash company inf-ruby bind-map bind-key yasnippet helm avy helm-core async auto-complete popup org-capture-pop-frame winum fuzzy zen-and-art-theme twilight-bright-theme tangotango-theme espresso-theme macrostep elisp-slime-nav auto-compile packed xterm-color ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package toc-org tagedit swiper sql-indent spacemacs-theme spaceline smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs rbenv rake rainbow-mode rainbow-delimiters quelpa pug-mode popwin phpunit phpcbf php-extras php-auto-yasnippets persp-mode paradox orgit org-projectile org-present org-pomodoro org-plus-contrib org-download org-bullets open-junk-file neotree multi-term move-text molokai-theme mmm-mode minitest markdown-toc magit-gitflow lua-mode lorem-ipsum livid-mode linum-relative link-hint less-css-mode json-mode js2-refactor js-doc insert-shebang info+ indent-guide ido-vertical-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-gitignore helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md flx-ido fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help emmet-mode dumb-jump drupal-mode disaster define-word company-web company-tern company-statistics company-shell company-c-headers command-log-mode column-enforce-mode coffee-mode cmake-mode clean-aindent-mode clang-format chruby bundler auto-yasnippet auto-highlight-symbol aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell)))
 '(trash-directory "~/Trash"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
