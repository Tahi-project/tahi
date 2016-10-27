#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import logging
from random import choice

from loremipsum import generate_paragraph

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

from frontend.Tasks.basetask import BaseTask

__author__ = 'sbassi@plos.org'

class ReviewerReportTask(BaseTask):
  """
  Page Object Model for Reviewer Report Task
  """
  def __init__(self, driver):
    super(ReviewerReportTask, self).__init__(driver)
    # Locators - Instance members
    # Shared Locators
    self._review_note = (By.CSS_SELECTOR, 'div.reviewer-report-wrapper p strong')
    self._question_block = (By.CSS_SELECTOR, 'li.question')
    self._questions = (By.CLASS_NAME, 'question-text')
    self._questions_help = (By.CLASS_NAME, 'question-help')
    self._question_textarea = (By.CSS_SELECTOR, 'li.question > div > textarea')
    self._submit_button = (By.CLASS_NAME, 'button-primary')
    self._submit_confirm_text = (By.CLASS_NAME, 'reviewer-report-confirmation')
    self._submit_confirm_yes_btn = (By.CSS_SELECTOR, 'div.reviewer-report-confirmation > button')
    self._submit_confirm_no_btn = (By.CSS_SELECTOR,
                                   'div.reviewer-report-confirmation > button + button')
    # Question one is the same regardless front-matter or research type - all other questions differ
    self._q1_accept_label = (By.CSS_SELECTOR, 'div.flex-group > label')
    self._q1_accept_radio = (By.CSS_SELECTOR, 'input[value=\'accept\']')
    self._q1_reject_label = (By.CSS_SELECTOR, 'div.flex-group > label + label')
    self._q1_reject_radio = (By.CSS_SELECTOR, 'input[value=\'reject\']')
    self._q1_majrev_label = (By.CSS_SELECTOR, 'div.flex-group > label + label + label')
    self._q1_majrev_radio = (By.CSS_SELECTOR, 'input[value=\'major_revision\']')
    self._q1_minrev_label = (By.CSS_SELECTOR, 'div.flex-group > label + label + label + label')
    self._q1_minrev_radio = (By.CSS_SELECTOR, 'input[value=\'minor_revision\']')
    # Research Reviewer Report locators
    # Note these must be used with a find to be unique
    self._res_yes_label = (By.CSS_SELECTOR, 'div.ember-view > label')
    self._res_yes_radio = (By.CSS_SELECTOR, 'div.ember-view > label > input')
    self._res_no_label = (By.CSS_SELECTOR, 'div.ember-view > label + label')
    self._res_no_radio = (By.CSS_SELECTOR, 'div.ember-view > label + label > input')
    self._res_q2_form = (By.NAME, 'reviewer_report--competing_interests--detail')
    self._res_q3_form = (By.NAME, 'reviewer_report--identity')
    self._res_q4_form = (By.NAME, 'reviewer_report--comments_for_author')
    self._res_q5_form = (By.NAME, 'reviewer_report--additional_comments')
    self._res_q6_form = (By.NAME, 'reviewer_report--suitable_for_another_journal--journal')
    # Front Matter Reviewer Report locators
    # Note these must be used with a find to be unique
    self._fm_yes_label = (By.CSS_SELECTOR, 'div.yes-no-with-comments > div > label')
    self._fm_yes_radio = (By.CSS_SELECTOR, 'div.yes-no-with-comments > div > label > input')
    self._fm_no_label = (By.CSS_SELECTOR, 'div.yes-no-with-comments > div > label + label')
    self._fm_no_radio = (By.CSS_SELECTOR,
                      'div.yes-no-with-comments > div > label + label > input')
    self._fm_q2_form = (By.NAME, 'front_matter_reviewer_report--competing_interests')
    self._fm_q3_form = (By.NAME, 'front_matter_reviewer_report--suitable--comment')
    self._fm_q4_form = (By.NAME,
                        'front_matter_reviewer_report--includes_unpublished_data--explanation')
    self._fm_q5_form = (By.NAME, 'front_matter_reviewer_report--additional_comments')
    self._fm_q6_form = (By.NAME, 'front_matter_reviewer_report--identity')

  # POM Actions
  def validate_task_elements_styles(self, research_type=True):
    """
    This method validates the styles of the task elements including the common tasks elements
    :param research_type: boolean, determines whether elements will be validated as a research type
      reviewer report (default) or a front-matter type report.
    :return void function
    """
    # First the global elements/sytles
    self.validate_common_elements_styles()
    accrb = self._get(self._q1_accept_radio)
    self.validate_radio_button(accrb)
    acclbl = self._get(self._q1_accept_label)
    assert acclbl.text == 'Accept', acclbl.text
    self.validate_radio_button_label(acclbl)
    rejrb = self._get(self._q1_reject_radio)
    self.validate_radio_button(rejrb)
    rejlbl = self._get(self._q1_reject_label)
    assert rejlbl.text == 'Reject', acclbl.text
    self.validate_radio_button_label(rejlbl)
    majrevrb = self._get(self._q1_majrev_radio)
    self.validate_radio_button(majrevrb)
    majrevlbl = self._get(self._q1_majrev_label)
    assert majrevlbl.text == 'Major Revision', majrevlbl.text
    self.validate_radio_button_label(majrevlbl)
    minrevrb = self._get(self._q1_minrev_radio)
    self.validate_radio_button(minrevrb)
    minrevlbl = self._get(self._q1_minrev_label)
    assert majrevlbl.text == 'Major Revision', majrevlbl.text
    self.validate_radio_button_label(majrevlbl)
    question_block_list = self._gets(self._question_block)
    qb1, qb2, qb3, qb4, qb5, qb6 = question_block_list
    question_list = self._gets(self._questions)
    for q in question_list:
      self.validate_application_list_style(q)
    question_help_list = self._gets(self._questions_help)
    for qh in question_help_list:
      self.validate_application_ptext(qh)
    # Then the specific styles
    if research_type:
      q2yeslbl = qb2.find_element(*self._res_yes_label)
      assert q2yeslbl.text == 'Yes', q2yeslbl.text
      self.validate_radio_button_label(q2yeslbl)
      q2yesradio = qb2.find_element(*self._res_yes_radio)
      self.validate_radio_button(q2yesradio)
      q2nolbl = qb2.find_element(*self._res_no_label)
      assert q2nolbl.text == 'No', q2nolbl.text
      self.validate_radio_button_label(q2nolbl)
      q2noradio = qb2.find_element(*self._res_no_radio)
      self.validate_radio_button(q2noradio)
      q6yeslbl = qb6.find_element(*self._res_yes_label)
      assert q6yeslbl.text == 'Yes', q6yeslbl.text
      self.validate_radio_button_label(q6yeslbl)
      q6yesradio = qb6.find_element(*self._res_yes_radio)
      self.validate_radio_button(q6yesradio)
      q6nolbl = qb6.find_element(*self._res_no_label)
      assert q6nolbl.text == 'No', q6nolbl.text
      self.validate_radio_button_label(q6nolbl)
      q6noradio = qb6.find_element(*self._res_no_radio)
      self.validate_radio_button(q6noradio)
      q2rta = self._get(self._res_q2_form)
      self.validate_textarea_style(q2rta)
      q3rta = self._get(self._res_q3_form)
      self.validate_textarea_style(q3rta)
      q4rta = self._get(self._res_q4_form)
      self.validate_textarea_style(q4rta)
      q5rta = self._get(self._res_q5_form)
      self.validate_textarea_style(q5rta)
      q6rta = self._get(self._res_q6_form)
      self.validate_textarea_style(q6rta)
    else:
      q3yeslbl = qb3.find_element(*self._fm_yes_label)
      assert q3yeslbl.text == 'Yes', q3yeslbl.text
      self.validate_radio_button_label(q3yeslbl)
      q3yesradio = qb3.find_element(*self._fm_yes_radio)
      self.validate_radio_button(q3yesradio)
      q3nolbl = qb3.find_element(*self._fm_no_label)
      assert q3nolbl.text == 'No', q3nolbl.text
      self.validate_radio_button_label(q3nolbl)
      q3noradio = qb3.find_element(*self._fm_no_radio)
      self.validate_radio_button(q3noradio)
      q4yeslbl = qb4.find_element(*self._fm_yes_label)
      assert q4yeslbl.text == 'Yes', q4yeslbl.text
      self.validate_radio_button_label(q4yeslbl)
      q4yesradio = qb4.find_element(*self._fm_yes_radio)
      self.validate_radio_button(q4yesradio)
      q4nolbl = qb4.find_element(*self._fm_no_label)
      assert q4nolbl.text == 'No', q4nolbl.text
      self.validate_radio_button_label(q4nolbl)
      q4noradio = qb4.find_element(*self._fm_no_radio)
      self.validate_radio_button(q4noradio)
      q2fmta = self._get(self._fm_q2_form)
      self.validate_textarea_style(q2fmta)
      q3fmta = self._get(self._fm_q3_form)
      self.validate_textarea_style(q3fmta)
      q4fmta = self._get(self._fm_q4_form)
      self.validate_textarea_style(q4fmta)
      q5fmta = self._get(self._fm_q5_form)
      self.validate_textarea_style(q5fmta)
      q6fmta = self._get(self._fm_q6_form)
      self.validate_textarea_style(q6fmta)
    submit_btn = self._get(self._submit_button)
    assert submit_btn.text == u'SUBMIT THIS REPORT', submit_btn.text
    self.validate_primary_big_green_button_style(submit_btn)
    # Need to move to an appropriate place so this button is not under the toolbar.
    self._actions.move_to_element(qb6).perform()
    submit_btn.click()
    confirm_text = self._get(self._submit_confirm_text)
    assert 'Once you submit the report, you will no longer be able to edit it. Are you sure?' in \
           confirm_text.text, confirm_text.text
    # APERTA-8079
    # self.validate_application_h4_style(confirm_text)
    confirm_yes = self._get(self._submit_confirm_yes_btn)
    assert confirm_yes.text == u'YES, I\u2019M SURE', confirm_yes.text
    self.validate_primary_big_green_button_style(confirm_yes)
    confirm_no = self._get(self._submit_confirm_no_btn)
    assert confirm_no.text == 'NOPE', confirm_no.text
    self.validate_secondary_big_green_button_style(confirm_no)
    confirm_no.click()

  def validate_reviewer_report(self, research_type=True):
    """
    Validates content of Reviewer Report task.
    :param research_type: If set to False, validates content against Front-Matter type report; when
      True uses research type reviewer report content
    :return None
    """
    logging.info('Validating reviewer report')
    self._wait_for_element(self._get(self._review_note))
    review_note = self._get(self._review_note)
    if research_type:
      assert u'Please refer to our referee guidelines for detailed instructions.' in \
          review_note.text
      assert '<a href="http://journals.plos.org/plosbiology/s/reviewer-guidelines#loc-criteria-'\
          'for-publication">referee</a>' in review_note.get_attribute('innerHTML')
      question_list = self._gets(self._questions)
      q1, q2, q3, q4, q5, q6 = question_list
      assert q1.text == u'Please provide your publication recommendation:', q1.text
      assert q2.text == u'Do you have any potential or perceived competing interests that may '\
          u'influence your review?', q2.text
      assert q3.text == u'(Optional) If you\'d like your identity to be revealed to the authors, '\
          u'please include your name here.', q3.text
      assert q4.text == u'Add your comments to authors below.', q4.text
      assert q5.text == u'(Optional) If you have any additional confidential comments to the editor,'\
          u' please add them below.', q5.text
      assert q6.text == u'If the manuscript does not meet the standards of PLOS Biology, do you '\
          u'think it is suitable for another PLOS journal?', q6.text
      qh2, qh3, qh4, qh5, qh6 = self._gets(self._questions_help)
      assert qh2.text == u'Please review our Competing Interests policy and declare any potential'\
          u' interests that you feel the Editor should be aware of when considering your review.', \
          qh2.text
      assert qh3.text == u'Your name and review will not be published with the manuscript.', \
          qh3.text
      assert qh4.text == u'These comments will be transmitted to the author.', qh4.text
      assert qh5.text == u'Additional comments may include concerns about dual publication, '\
          u'research or publication ethics.\n\nThese comments will not be transmitted to the '\
          u'authors.', qh5.text
      assert qh6.text == u'If so, please specify which journal and whether you will be willing' \
          u' to continue there as reviewer. PLOS Wombat is committed to facilitate the transfer' \
          u' between journals of suitable manuscripts to reduce redundant review cycles, and we ' \
          u'appreciate your support.', qh6.text
    else:
      assert u'Please refer to our referee guidelines and information on our article ' \
                         u'types.' in review_note.text, review_note.text
      assert '<a href="http://journals.plos.org/plosbiology/s/reviewer-guidelines#loc-criteria-' \
             'for-publication" target="_blank">referee</a>' in \
             review_note.get_attribute('innerHTML'), review_note.get_attribute('innerHTML')
      question_list = self._gets(self._questions)
      q1, q2, q3, q4, q5, q6 = question_list
      assert q1.text == u'Please provide your publication recommendation:', q1.text
      assert q2.text == u'Do you have any potential or perceived competing interests that may ' \
                        u'influence your review?', q2.text
      assert q3.text == u'Is this manuscript suitable in principle for the magazine section of ' \
                        u'PLOS Biology?', q3.text
      assert q4.text == u'If previously unpublished data are included to support the conclusions,' \
                        u' please note in the box below whether:', q4.text
      assert q5.text == u'(Optional) Please offer any additional confidential comments to the ' \
                        u'editor', q5.text
      assert q6.text == u'(Optional) If you\'d like your identity to be revealed to the authors, ' \
                        u'please include your name here.', q6.text
      qh2, qh3, qh4, qh5, qh6 = self._gets(self._questions_help)
      assert qh2.text == u'Please review our Competing Interests policy and declare any potential' \
                         u' interests that you feel the Editor should be aware of when ' \
                         u'considering your review. If you have no competing interests, please ' \
                         u'write: "I have no competing interests."', qh2.text
      assert qh3.text == u'Please refer to our referee guidelines and information on our article ' \
                         u'types.\nSubmit your detailed comments in the box below. These will be ' \
                         u'communicated to the authors.', qh3.text
      assert qh4.text == u'The data have been generated rigorously with relevant controls, ' \
                         u'replication and sample sizes, if applicable.\nThe data provided ' \
                         u'support the conclusions that are drawn.', qh4.text
      assert qh5.text == u'Additional comments may include concerns about dual publication, ' \
                         u'research or publication ethics.', qh5.text
      assert qh6.text == u'Your name and review will not be published with the manuscript.', \
          qh6.text

  def complete_reviewer_report(self):
    """
    Completes and submits the reviewer report
    :return: void function
    """
    logging.info('Complete Reviewer Report called')
    research_type = False
    review_note = self._get(self._review_note)
    self._actions.move_to_element(review_note).perform()
    if u'Please refer to our referee guidelines for detailed instructions.' in review_note.text:
      research_type = True
    question_block_list = self._gets(self._question_block)
    qb1, qb2, qb3, qb4, qb5, qb6 = question_block_list
    choices = ['Accept', 'Reject', 'Major Revision', 'Minor Revision']
    reccommendation = choice(choices)
    if reccommendation == 'Accept':
      accrb = self._get(self._q1_accept_radio)
      accrb.click()
    elif reccommendation == 'Reject':
      rejrb = self._get(self._q1_reject_radio)
      rejrb.click()
    elif reccommendation == 'Major Revision':
      majrevrb = self._get(self._q1_majrev_radio)
      majrevrb.click()
    else:
      minrevrb = self._get(self._q1_majrev_radio)
      minrevrb.click()
    if research_type:
      q2radval = self.get_random_bool()
      if q2radval:
        q2yesradio = qb2.find_element(*self._res_yes_radio)
        q2yesradio.click()
      else:
        q2noradio = qb2.find_element(*self._res_no_radio)
        q2noradio.click()
      q2rta = self._get(self._res_q2_form)
      q2response = generate_paragraph()
      q2rta.send_keys(q2response)
      q3rta = self._get(self._res_q3_form)
      q3response = generate_paragraph()
      q3rta.send_keys(q3response)
      q4rta = self._get(self._res_q4_form)
      q4response = generate_paragraph()
      q4rta.send_keys(q4response)
      q5rta = self._get(self._res_q5_form)
      q5response = generate_paragraph()
      q5rta.send_keys(q5response)
      q6radval = self.get_random_bool()
      self._actions.move_to_element(qb5).perform()
      if q6radval:
        q6yesradio = qb6.find_element(*self._res_yes_radio)
        q6yesradio.click()
      else:
        q6noradio = qb6.find_element(*self._res_no_radio)
        q6noradio.click()
      q6rta = self._get(self._res_q6_form)
      q6response = generate_paragraph()
      q6rta.send_keys(q6response)
    else:
      q2fmta = self._get(self._fm_q2_form)
      q2response = generate_paragraph()
      q2fmta.send_keys(q2response)
      q3radval = self.get_random_bool()
      if q3radval:
        q3yesradio = qb3.find_element(*self._fm_yes_radio)
        q3yesradio.click()
      else:
        q3noradio = qb3.find_element(*self._fm_no_radio)
        q3noradio.click()
      q3fmta = self._get(self._fm_q3_form)
      q3response = generate_paragraph()
      q3fmta.send_keys(q3response)
      q4radval = self.get_random_bool()
      if q4radval:
        q4yesradio = qb4.find_element(*self._fm_yes_radio)
        q4yesradio.click()
      else:
        q4noradio = qb4.find_element(*self._fm_no_radio)
        q4noradio.click()
      q4fmta = self._get(self._fm_q4_form)
      q4response = generate_paragraph()
      q4fmta.send_keys(q4response)
      q5fmta = self._get(self._fm_q5_form)
      q5response = generate_paragraph()
      q5fmta.send_keys(q5response)
      q6fmta = self._get(self._fm_q6_form)
      q6response = generate_paragraph()
      q6fmta.send_keys(q6response)
    submit_report_btn = self._get(self._submit_button)
    submit_report_btn.click()

    self._wait_for_element(self._get(self._submit_confirm_yes_btn))
    confirm_yes = self._get(self._submit_confirm_yes_btn)
    confirm_yes.click()
