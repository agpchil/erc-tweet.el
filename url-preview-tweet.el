;;; url-preview-tweet.el --- shows text of a tweet when an url is posted in buffers

;; Copyright (C) 2012  Raimon Grau

;; Author: Raimon Grau <raimonster@gmail.com>
;; Version: 0.9
;; Package-Requires: ((erc "5.3"))
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:
(require 'url-preview)

(defgroup url-preview-tweet nil
  "Url preview for twitter."
  :prefix "url-preview-tweet"
  :group 'url-preview)

(defvar url-preview-tweet
  '(:name "tweet"
    :pattern "https?://\\(?:[^/]*\\)?twitter.com/.+/status/[0-9]+"
    :retrieve nil
    :retrieve-url url-preview-tweet-correct-url
    :retrieve-args nil
    :retrieve-error nil
    :retrieve-success nil
    :on-success (url-preview-cb-save-cache
                 url-preview-tweet-cb-text
                 url-preview-tweet-cb-cleanup-text
                 url-preview-cb-message)
    :on-error (url-preview-cb-error-message)
    :enabled nil
    :buffer nil
    :display-at url-preview-display-at-nextline
    :display url-preview-display)
  "")

(defun url-preview-tweet-cb-cleanup-text (module str)
  "Strip tags in a regex. Naive, I know."
  (replace-regexp-in-string "<.+?>\\|\n$" "" str))

(defun url-preview-tweet-cb-text (module)
  "Extract the tweet text from the retrieved HTML"
  (goto-char (point-min))
  (search-forward-regexp "js-tweet-text tweet-text[^>]*>")
  (let ((pt-before (point)))
    (search-forward "

")
    (backward-char)
    (string-as-multibyte (buffer-substring-no-properties pt-before (point)))))

(defun url-preview-tweet-correct-url (url)
  "Change the url to go to the non-mobile site."
  ;; go to the non-mobile tweet
  (replace-regexp-in-string "mobile\." "" url))

;;;###autoload
(eval-after-load 'url-preview
  '(url-preview-module-define url-preview-tweet))


(provide 'url-preview-tweet)
;;; url-preview-tweet.el ends here
