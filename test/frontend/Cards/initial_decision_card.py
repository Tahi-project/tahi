#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import logging
import random
import time

from selenium.webdriver.common.by import By

from frontend.Cards.basecard import BaseCard

__author__ = 'jgray@plos.org'


class InitialDecisionCard(BaseCard):
  """
  Page Object Model for the Initial Decision Card
  """
  def __init__(self, driver):
    super(InitialDecisionCard, self).__init__(driver)

    # Locators - Instance members
    self._card_title = (By.TAG_NAME, 'h1')
    self._intro_text = (By.TAG_NAME, 'p')
    self._reject_radio_button = (By.XPATH, '//input[@value=\'reject\']')
    self._invite_radio_button = (By.XPATH, '//input[@value=\'invite_full_submission\']')
    self._decision_letter_textarea = (By.TAG_NAME, 'textarea')
    self._register_decision_btn = (By.XPATH, '//textarea/following-sibling::button')
    self._decision_alert = (By.CLASS_NAME, 'rescind-decision-container')
    self._decision_verdict = (By.CLASS_NAME, 'rescind-decision-verdict')
    self._rescind_button = (By.CLASS_NAME, 'rescind-decision-button')

   # POM Actions
  def validate_styles(self):
    """
    Validate styles for the Initial Decision Card
    """
    card_title = self._get(self._card_title)
    assert card_title.text == 'Initial Decision'
    self.validate_application_title_style(card_title)
    intro_text = self._get(self._intro_text)
    self.validate_application_ptext(intro_text)
    assert intro_text.text == 'Please write your decision letter in the area below', intro_text.text
    self._get(self._reject_radio_button)
    self._get(self._invite_radio_button)
    self._get(self._decision_letter_textarea)
    reg_dcn_btn = self._get(self._register_decision_btn)
    # disabling due to APERTA-6224
    # self.validate_primary_big_disabled_button_style(reg_dcn_btn)

  def execute_decision(self, choice='random'):
    """
    Randomly renders an initial decision of reject or invite, populates the decision letter
    :param choice: indicates whether to generate a choice randomly or to reject, else invite
    :return: selected choice
    """
    choices = ['reject', 'invite']
    decision_letter_input = self._get(self._decision_letter_textarea)
    logging.info('Initial Decision Choice is: {0}'.format(choice))
    if choice == 'random':
      choice = random.choice(choices)
      logging.info('Since choice was random, new choice is {0}'.format(choice))
    time.sleep(2)
    if choice == 'reject':
      reject_input = self._get(self._reject_radio_button)
      reject_input.click()
      time.sleep(1)
      decision_letter_input.send_keys('Rejected')
    else:
      invite_input = self._get(self._invite_radio_button)
      invite_input.click()
      time.sleep(1)
      decision_letter_input.send_keys('Invited')
    # Time to allow the button to change to clickable state
    time.sleep(1)
    self._get(self._register_decision_btn).click()
    time.sleep(5)
    # look for alert info
    decision_msg = self._get(self._decision_alert)
    if choice != 'reject':
      assert "A decision of Invite full submission has been registered." in \
          decision_msg.text, decision_msg.text
    else:
      assert "A final decision of Reject has been registered." in alert_msg.text, alert_msg.text
    self.click_close_button()
    return choice
