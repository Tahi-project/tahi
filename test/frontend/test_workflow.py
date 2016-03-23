#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import logging
import random
import time

from Base.Decorators import MultiBrowserFixture
from Base.Resources import internal_editor_login, staff_admin_login, pub_svcs_login, \
    super_admin_login, prod_staff_login
from frontend.Pages.manuscript_viewer import ManuscriptViewerPage
from frontend.Pages.workflow_page import WorkflowPage
from frontend.common_test import CommonTest

"""
This test case validates the Aperta workflow page
"""
__author__ = 'sbassi@plos.org'


@MultiBrowserFixture
class ApertaWorkflowTest(CommonTest):
  """
  Self imposed AC:
     - validate page elements and styles for:
         - WorkflowPage
         - Adding cards
         - TODO: Removing cards (NOT READY)
  AC for APERTA-5513:
    - Separation between author and staff cards
    - Alphabetical order
    - Add multiple cards at once
    - After adding card, go to the workflow page
  """

  def _go_to_workflow(self):
    """Internal method to reach workflow page"""
    manuscript_page = ManuscriptViewerPage(self.getDriver())
    manuscript_page.click_workflow_link()
    return WorkflowPage(self.getDriver())

  def test_validate_components_styles(self):
    """
    test_workflow: Validates elements and styles of the workflow page
    :return: void function
    """
    workflow_users = [internal_editor_login,
                      staff_admin_login,
                      prod_staff_login,
                      pub_svcs_login,
                      super_admin_login,
                      ]
    workflow_user = random.choice(workflow_users)
    logging.info('Logging in as {0}'.format(workflow_user['name']))
    dashboard_page = self.cas_login(workflow_user['email'])
    # We have to ensure there *is* a first manuscript on a users dashboard
    manuscript_count = dashboard_page.validate_manuscript_section_main_title(workflow_user)[0]
    logging.info(manuscript_count)
    dashboard_page.click_create_new_submission_button()
    self.create_article(journal='PLOS Wombat',
                        type_='Research',
                        random_bit=True,
                        title='Created Document for Workflow test',
                        )
    time.sleep(12)
    workflow_page = self._go_to_workflow()
    workflow_page.validate_initial_page_elements_styles()
    return self

  def test_add_new_card(self):
    """
    test_workflow: Testing adding a new card
    :return: void function
    """
    # APERTA-6186 stops the internal editor and publication services logins from adding a new card
    workflow_users = [internal_editor_login,
                      staff_admin_login,
                      prod_staff_login,
                      pub_svcs_login,
                      super_admin_login,
                      ]
    workflow_user = random.choice(workflow_users)
    logging.info('Logging in as {0}'.format(workflow_user['name']))
    dashboard_page = self.cas_login(workflow_user['email'])
    # NOTA BENE: The first manuscript on these users desktop is not guaranteed to be in a journal
    #   on which these users possess the relevant role (super_admin_login excepted) - therefore
    # switching this from click on first manuscript to an explicit create
    dashboard_page.click_create_new_submission_button()
    self.create_article(journal='PLOS Wombat',
                          type_='Research',
                          random_bit=True,
                          title='Created Document for Workflow test',
                          )
    time.sleep(12)
    workflow_page = self._go_to_workflow()
    # GET URL
    time.sleep(2)
    workflow_url = self._driver.current_url
    # Count cards in first column
    start_cards = workflow_page.count_cards_first_column()
    # Test add new card
    workflow_page.click_add_new_card()
    # Elements in add new card
    # Following check commented out until APERTA-5414 is solved
    # workflow_page.check_overlay()
    time.sleep(2)
    workflow_page.check_new_tasks_overlay()
    # Check that after adding a card returns to workflow APERTA-5513 AC 4
    time.sleep(1)
    assert workflow_url == self._driver.current_url, (workflow_url, self._driver.current_url)
    current_cards = workflow_page.count_cards_first_column()
    # Check that there are two more card after adding a card
    # APERTA-5513 AC 3
    assert start_cards + 2 == current_cards
    # NOTE: Missing deleting a new card
    return self

if __name__ == '__main__':
  CommonTest._run_tests_randomly()
