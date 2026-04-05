;;; activate.el --- Test dashboard activation  -*- lexical-binding: t; -*-

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Test dashboard activation.
;;

;;; Code:
(ert-deftest activate-dashboard-with-dashboard-open-test ()
  (use-package dashboard
    :load-path "./"
    :demand t)
  (with-current-buffer (dashboard-open)
    (should (string-match-p "Welcome to Emacs!" (buffer-string)))))

;;; activate.el ends here
