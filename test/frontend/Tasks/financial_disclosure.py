#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import logging
import random

from selenium.webdriver.common.by import By

from Base.CustomException import ElementDoesNotExistAssertionError
from frontend.Tasks.basetask import BaseTask

__author__ = 'jgray@plos.org'


class FinancialDisclosureTask(BaseTask):
    """
    Page Object Model for the Financial Disclosure Task
    """

    def __init__(self, driver):
        super(FinancialDisclosureTask, self).__init__(driver)

        # Locators - Instance members
        self._intro_text = (By.CSS_SELECTOR, 'div.card-form-text-error')
        self._yes_radio = (By.CSS_SELECTOR, 'div.card-radio input')
        self._yes_radio_label = (By.CSS_SELECTOR, 'div.card-radio input + span')
        self._yes_radio_required_icon = (By.CSS_SELECTOR,
                                         'div.card-radio input + span + span.required-field')
        self._no_radio = (By.CSS_SELECTOR, 'div.card-radio + div.card-radio input')
        self._no_radio_label = (By.CSS_SELECTOR, 'div.card-radio + div.card-radio input + span')
        self._no_radio_required_icon = (
            By.CSS_SELECTOR, 'div.card-radio + div.card-radio input + span + span.required-field')
        self._yes_subform_instruction_text = (By.CSS_SELECTOR, 'div.card-content-view-text')
        self._add_funder_link = (By.CSS_SELECTOR, 'a.add-repetition')
        self._funder_summary_div = (By.CSS_SELECTOR,
                                    'div.card-content-financial-disclosure-summary')
        self._funder_summary_intro_text = (By.CSS_SELECTOR,
                                           'div.card-content-financial-disclosure-summary > p')
        # The following locators can occur multiple times per summary div and should be used within
        #     a find_element structure
        self._funder_summary_statement = (By.CSS_SELECTOR, 'p + div')
        self._funder_summary_statement_funder_name = (By.CSS_SELECTOR, 'div > strong')
        self._subform_enclosing_div = (By.CSS_SELECTOR, 'div.repeated-block')
        # The following locators can occur for each sub-form enclosing div and should be used within
        #     a find_element structure
        self._subform_title = (By.TAG_NAME, 'h4')
        self._subform_funder_name_label = (By.CSS_SELECTOR, 'div.qa-ident-funder--name > div > div')
        self._subform_funder_name_field = (By.CSS_SELECTOR,
                                           'div.qa-ident-funder--name > div > div + div > input')
        self._subform_grant_number_label = (By.CSS_SELECTOR,
                                            '.qa-ident-funder--grant_number > div > div')
        self._subform_grant_number_field = (By.CSS_SELECTOR,
                                            '.qa-ident-funder--grant_number > div > div > input')
        self._subform_website_label = (By.CSS_SELECTOR, '.qa-ident-funder--website > div > div')
        self._subform_website_field = (By.CSS_SELECTOR,
                                       '.qa-ident-funder--website > div > div > input')
        self._subform_addl_comments_label = (By.CSS_SELECTOR,
                                             '.qa-ident-funder--additional_comments > div > div')
        self._subform_addl_comments_field = (
            By.CSS_SELECTOR, '.qa-ident-funder--additional_comments > div > div > input')
        self._subform_funder_role_radio_question = (
            By.CSS_SELECTOR, 'fieldset.qa-ident-funder--had_influence > div')
        self._subform_funder_role_radio_yes = (By.CSS_SELECTOR, 'div.card-radio > label > input')
        self._subform_funder_role_radyes_lbl = (By.CSS_SELECTOR,
                                                'div.card-radio > label > input + span')
        self._subform_funder_role_yes_radio_required_icon = (
            By.CSS_SELECTOR, 'div.card-radio > label > input + span + span.required-field')
        self._subform_funder_role_radio_no = (
            By.CSS_SELECTOR, 'div.card-radio + div.card-radio > label > input + span')
        self._subform_funder_role_radno_lbl = (
            By.CSS_SELECTOR, 'div.card-radio + div.card-radio > label > input + span')
        self._subform_funder_role_no_radio_required_icon = (
            By.CSS_SELECTOR, 'div.card-radio + div.card-radio > label > input '
                             '+ span + span.required-field')
        self._subform_funder_role_field_label = (By.CSS_SELECTOR,
                                                 'fieldset > div.card-content-short-input')
        self._subform_funder_role_field = (
            By.CSS_SELECTOR, 'fieldset > div.card-content-short-input input.ember-text-field')

    # POM Actions
    def validate_styles(self):
        """
        Validate styles in the Financial Disclosure Task
        """
        intro_text = self._get(self._intro_text)
        self.validate_application_body_text(intro_text)
        assert intro_text.text == 'Did any of the authors receive specific funding for ' \
                                  'this work?', intro_text.text
        yes_rad = self._get(self._yes_radio)
        assert not yes_rad.is_selected()
        yes_lbl = self._get(self._yes_radio_label)
        assert yes_lbl.text == 'Yes', yes_lbl.text
        self._get(self._yes_radio_required_icon)
        no_rad = self._get(self._no_radio)
        assert not no_rad.is_selected()
        no_lbl = self._get(self._no_radio_label)
        assert no_lbl.text == 'No', no_lbl.text
        self._get(self._no_radio_required_icon)
        assert self._check_for_invisible_element_boolean(self._yes_subform_instruction_text)
        assert self._check_for_invisible_element_boolean(self._add_funder_link)
        assert self._check_for_invisible_element_boolean(self._funder_summary_div)
        # The following locator can occur multiple times per summary div and should be used within
        #     a find_element structure - However, the funder name and statement don't attach to
        #     the DOM until a top level Yes selection is made.
        self.set_timeout(2)
        try:
            self._get(self._funder_summary_intro_text)
        except ElementDoesNotExistAssertionError:
            pass
        try:
            self._get(self._funder_summary_statement_funder_name)
        except ElementDoesNotExistAssertionError:
            pass
        try:
            assert self._get(self._funder_summary_statement)
        except ElementDoesNotExistAssertionError:
            pass
        self.restore_timeout()
        # The No selection *should* trigger the display of a summary disclosure statement
        #     It currently does not due to APERTA-12393
        # no_rad.click()
        # Insert validation of "No" statement here when possible.
        while not yes_rad.is_selected():
            yes_rad.click()
            self._wait_for_element(
                self._get(self._subform_enclosing_div).find_element(
                    *self._subform_funder_role_radio_question), multiplier=1)
        subform_encl_div = self._get(self._subform_enclosing_div)
        # The following locators can occur for each subform enclosing div and should be used within
        #     a find_element structure
        funder_subform_title = subform_encl_div.find_element(*self._subform_title)
        self.validate_application_h4_style(funder_subform_title)
        assert funder_subform_title.text == 'FUNDER', funder_subform_title.text
        funder_subform_name_lbl = subform_encl_div.find_element(*self._subform_funder_name_label)
        self.validate_input_field_external_label_style(funder_subform_name_lbl)
        self._scroll_into_view(funder_subform_name_lbl)
        assert funder_subform_name_lbl.text == 'Funder Name:', funder_subform_name_lbl.text
        subform_encl_div.find_element(*self._subform_funder_name_field)
        funder_subform_grant_lbl = subform_encl_div.find_element(*self._subform_grant_number_label)
        assert funder_subform_grant_lbl.text == 'Grant Number:', funder_subform_grant_lbl.text
        self.validate_input_field_external_label_style(funder_subform_grant_lbl)
        subform_encl_div.find_element(*self._subform_grant_number_field)
        funder_subform_site_lbl = subform_encl_div.find_element(*self._subform_website_label)
        self.validate_input_field_external_label_style(funder_subform_site_lbl)
        assert funder_subform_site_lbl.text == 'Website:', funder_subform_site_lbl.text
        subform_encl_div.find_element(*self._subform_website_field)
        funder_subform_comments_lbl = \
            subform_encl_div.find_element(*self._subform_addl_comments_label)
        self.validate_input_field_external_label_style(funder_subform_comments_lbl)
        assert funder_subform_comments_lbl.text == 'Additional Comments:', \
            funder_subform_comments_lbl.text
        subform_encl_div.find_element(*self._subform_addl_comments_field)
        funder_subform_role_question = \
            subform_encl_div.find_element(*self._subform_funder_role_radio_question)
        self.validate_input_field_external_label_style(funder_subform_role_question)
        assert funder_subform_role_question.text == \
            'Did the funder have a role in study design, data collection and analysis, decision ' \
            'to publish, or preparation of the manuscript?', funder_subform_role_question.text
        sub_yes_radio = subform_encl_div.find_element(*self._subform_funder_role_radio_yes)
        funder_subform_role_yes_lbl = \
            subform_encl_div.find_element(*self._subform_funder_role_radyes_lbl)
        self.validate_input_field_external_label_style(funder_subform_role_yes_lbl)
        assert funder_subform_role_yes_lbl.text == 'Yes', funder_subform_role_yes_lbl.text
        self._get(self._subform_funder_role_yes_radio_required_icon)
        sub_no_radio = subform_encl_div.find_element(*self._subform_funder_role_radio_no)
        funder_subform_role_no_lbl = \
            subform_encl_div.find_element(*self._subform_funder_role_radno_lbl)
        self.validate_input_field_external_label_style(funder_subform_role_no_lbl)
        assert funder_subform_role_no_lbl.text == 'No', funder_subform_role_no_lbl.text
        subform_encl_div.find_element(*self._subform_funder_role_no_radio_required_icon)
        # These locators are not within the repeater subform enclosing div, BUT, their display is
        #     conditional on a top level Yes radio selection
        add_funder_link = self._get(self._add_funder_link)
        self.validate_default_link_style(add_funder_link)
        assert add_funder_link.text == '+ Add Funder', add_funder_link.text
        fun_summary_div = self._get(self._funder_summary_div)
        fun_summary_intro = fun_summary_div.find_element(*self._funder_summary_intro_text)
        self.validate_application_body_text(fun_summary_intro)
        assert fun_summary_intro.text == \
            'Please note that if your manuscript is accepted, this statement will be published.\n' \
            'Your Financial Disclosure Statement will appear as:', fun_summary_intro.text
        # The following locators can occur multiple times per summary div and should be used within
        #     a find_element structure
        # This stanza validates the summary in the top level "Yes" default sublevel no choice state
        fun_sum_funder_name = \
            fun_summary_div.find_element(*self._funder_summary_statement_funder_name)
        self.validate_application_body_text(fun_sum_funder_name)
        # Why on God's green earth is the value 700 treated as a string?
        assert fun_sum_funder_name.value_of_css_property('font-weight') == '700', \
            fun_sum_funder_name.value_of_css_property('font-weight')
        assert fun_sum_funder_name.text == '[funder name]', fun_sum_funder_name.text
        fun_summary = fun_summary_div.find_element(*self._funder_summary_statement)
        self.validate_application_body_text(fun_summary)
        assert fun_summary.text == '[funder name]\nThe funder had no role in study design, data ' \
                                   'collection and analysis, decision to publish, or preparation ' \
                                   'of the manuscript', fun_summary.text
        # The following items only show if the subform Yes selection is made
        assert self._check_for_invisible_element_boolean(self._subform_funder_role_field_label)
        assert self._check_for_invisible_element_boolean(self._subform_funder_role_field)
        sub_no_radio.click()
        assert self._check_for_invisible_element_boolean(self._subform_funder_role_field_label)
        assert self._check_for_invisible_element_boolean(self._subform_funder_role_field)
        sub_yes_radio.click()
        sub_fun_role_lbl = self._get(self._subform_funder_role_field_label)
        self.validate_input_field_external_label_style(sub_fun_role_lbl)
        assert sub_fun_role_lbl.text == 'Role of sponsors or funders:'
        sub_fun_role_field = self._get(self._subform_funder_role_field)
        sub_fun_role_field.send_keys('The funder washed my bicycle while I worked on this '
                                     'manuscript.')
        self.pause_to_save()
        # Have to grab the summary anew to avoid a stale reference exception
        fun_summary_div = self._get(self._funder_summary_div)
        fun_summary = fun_summary_div.find_element(*self._funder_summary_statement)
        # The one thing that *should* change with the sub-form Yes selection/entering a role is
        #     the fun_summary text should reflect the entered text
        assert fun_summary.text == '[funder name]\nThe funder washed my bicycle while I worked ' \
                                   'on this manuscript.', fun_summary.text

    def complete_form(self, choice=''):
        """
        Fill out the single item EV form with supplied data or random data if none provided
        :param choice: If supplied, will fill out the form accordingly, else, will make a random
          choice. A boolean.
        :returns choice, name, grant, site, comment, subform_role_choice, role: all strings
            choice - top level radio selection Yes or No
            name - the funder name
            grant - the funder grant number
            site - the funder website
            comment - the comment about the funder
            subform_role_choide - whether the funder had a role in the study Yes or No
            role - the role of the funder
        """
        choices = ['Yes', 'No']
        yes_rad = self._get(self._yes_radio)
        no_rad = self._get(self._no_radio)
        name = 'Central Services'
        grant = '27b-6'
        site = 'https://en.wikipedia.org/wiki/Brazil_(1985_film)'
        comment = 'Thanks Lowry, You\'re a good man in a tight corner.'
        role = 'Things don\'t just fix themselves'
        subform_role_choice = ''
        if choice:
            assert choice in choices, 'Selected can only be Yes or No. Supplied: ' \
                                      '{0}'.format(choice)
        else:
            choice = random.choice(choices)
        logging.info('Funder disclosure selection is: {0}'.format(choice))
        if choice == 'Yes':
            yes_rad.click()
            subform_encl_div = self._get(self._subform_enclosing_div)
            funder_subform_name = subform_encl_div.find_element(*self._subform_funder_name_field)
            funder_subform_name.send_keys(name)
            self.pause_to_save()
            funder_subform_grant = subform_encl_div.find_element(*self._subform_grant_number_field)
            funder_subform_grant.send_keys(grant)
            self.pause_to_save()
            funder_subform_site = subform_encl_div.find_element(*self._subform_website_field)
            funder_subform_site.send_keys(site)
            self.pause_to_save()
            funder_subform_comments = \
                subform_encl_div.find_element(*self._subform_addl_comments_field)
            funder_subform_comments.send_keys(comment)
            self.pause_to_save()
            subform_role_choice = random.choice(choices)
            if subform_role_choice == 'Yes':
                subform_encl_div.find_element(*self._subform_funder_role_radio_yes).click()
                self.pause_to_save()
                sub_fun_role_field = self._get(self._subform_funder_role_field)
                sub_fun_role_field.send_keys(role)
                self.pause_to_save()
            else:
                subform_encl_div.find_element(*self._subform_funder_role_radio_no).click()
                role = ''
            self.pause_to_save()
        else:
            no_rad.click()
        self.pause_to_save()
        return choice, name, grant, site, comment, subform_role_choice, role
