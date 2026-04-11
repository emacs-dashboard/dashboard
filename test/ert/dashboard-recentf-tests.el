;;; dashboard-recentf-tests.el -- Tests for dashboard-recentf  -*- lexical-binding: t; -*-
;; Commentary:

;;; Code:

(require 'recentf)

(defun dashboard-recentf--setup-tests ()
  "Setup recentf in dashboard buffer before running test-suite."
  (require 'dashboard)
  (setopt dashboard-items '((recents . 5))))

(defun dashboard-recentf--build-recent-files-for-tests ()
  "Create recent file list."
  (let ((recent-files '("~/recent-file" "~/dummy-file")))
    (dolist (file (mapcar 'expand-file-name recent-files))
      (unless (file-exists-p file)
        (write-region "Content file" nil file)
        (message "File created %s" (expand-file-name file)))
      (recentf-add-file file)))
  (recentf-save-list))

(defun dashboard-recentf--clean-tests ()
  "Clear test environment.  Delete recentf file and set recentf-list to nil."
  (setq recentf-list nil)
  (recentf-save-list)
  (recentf-mode -1))

;; Tests

(ert-deftest dashboard-recentf--no-recents-test ()
  "Test dsahboard show no items message when there are no recent files."
  (dashboard-recentf--setup-tests)
  (with-current-buffer (and (fboundp 'dashboard-open)
                            (funcall 'dashboard-open))
    (let ((dashboard-content (buffer-string)))
      (should (string-match-p "Recent Files:" dashboard-content))
      (should (string-match-p "No items" dashboard-content)))))

(ert-deftest dashboard-recentf--show-recent-files-test ()
  "Show list of recent files."
  (dashboard-recentf--build-recent-files-for-tests)
  (dashboard-recentf--setup-tests)
  (unwind-protect
      (with-current-buffer (and (fboundp 'dashboard-open)
                                (funcall 'dashboard-open))
        (let ((dashboard-content (buffer-string)))
          (should (string-match-p "Recent Files:" dashboard-content))
          (should (string-match-p "recent-file" dashboard-content))
          (should (string-match-p "dummy-file" dashboard-content))))
    (dashboard-recentf--clean-tests)))

(ert-deftest dashboard-recentf--recents-with-show-base-align-and-custom-item-format-test ()
  "Show the list fo recent files and the path to each file."
  (dashboard-recentf--build-recent-files-for-tests)
  (dashboard-recentf--setup-tests)
  (setopt dashboard-recentf-show-base 'align)
  (setopt dashboard-recentf-item-format "%s - %s")
  (unwind-protect
      (with-current-buffer (and (fboundp 'dashboard-open)
                                (funcall 'dashboard-open))
        (let ((dashboard-content (buffer-string)))
          (should (string-match-p "Recent Files:" dashboard-content))
          (should (string-match-p "recent-file - ~/recent-file" dashboard-content))
          (should (string-match-p "dummy-file  - ~/dummy-file" dashboard-content))))
    (dashboard-recentf--clean-tests)))

(ert-deftest dashboard-recentf--delete-recent-file-test ()
  "Delete a recent file."
  (dashboard-recentf--build-recent-files-for-tests)
  (dashboard-recentf--setup-tests)
  (unwind-protect
      (with-current-buffer (and (fboundp 'dashboard-open)
                                (funcall 'dashboard-open))
        (let ((dashboard-content (buffer-string)))
          (should (string-match-p "Recent Files:" dashboard-content))
          (should (string-match-p "dummy-file" dashboard-content))
          (should (string-match-p "recent-file" dashboard-content)))
        (and (fboundp 'dashboard--goto-section)
             (apply 'dashboard--goto-section '(recents)))
        (and (fboundp 'dashboard-remove-item-under)
             (call-interactively 'dashboard-remove-item-under))
        (let ((new-content (buffer-string)))
          (should-not (string-match-p "dummy-file" new-content))
          (should (string-match-p "recent-file" new-content))))
    (dashboard-recentf--clean-tests)))


(provide 'dashboard-recentf-tests)
;;; dashboard-recentf-tests.el ends here
