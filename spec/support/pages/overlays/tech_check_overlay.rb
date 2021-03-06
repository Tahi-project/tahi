# Copyright (c) 2018 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

require 'support/pages/card_overlay'
require 'support/rich_text_editor_helpers'

class TechCheckOverlay < CardOverlay
  include RichTextEditorHelpers

  def create_author_changes_card
    click_send_changes_button
    wait_for_editors
    set_rich_text(editor: 'author-changes-letter', text: 'First round author changes')
    click_send_changes_button
    expect_author_changes_saved
  end

  def expect_author_changes_saved
    expect(page).to have_content('Author Changes Letter has been Saved')
  end

  def display_letter
    find(".task-main-content .button-primary").click
    wait_for_editors
  end

  def letter_text
    wait_for_editors
    get_rich_text(editor: 'author-changes-letter')
  end

  def click_autogenerate_email_button
    # find("button#autogenerate-email").click
    click_button 'Auto-generate Text'
  end

  private

  def click_send_changes_button
    click_button 'Send Changes to Author'
  end
end
