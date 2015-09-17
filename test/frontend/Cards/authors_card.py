#!/usr/bin/env python2

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

from frontend.Cards.basecard import BaseCard
from Base.Resources import author

__author__ = 'sbassi@plos.org'

class AuthorsCard(BaseCard):
  """
  Page Object Model for Authors Card
  """
  def __init__(self, driver, url_suffix='/'):
    super(AuthorsCard, self).__init__(driver)

    #Locators - Instance members
    self._click_task_completed = (By.CSS_SELECTOR, '#task_completed')
    self._close_button_bottom = (By.CSS_SELECTOR, 'footer > div > a.button-secondary')
    self._authors_title = (By.TAG_NAME, 'h1')
    self._authors_text = (By.CSS_SELECTOR, 'div.authors-overlay-header > p')
    self._add_new_author_btn = (By.CLASS_NAME, 'button-primary')
    self._first_lbl = (By.XPATH, ".//div[contains(@class, 'author-name')]/span")
    self._first_input = (By.XPATH, ".//div[contains(@class, 'author-name')]/input")
    self._middle_lbl = (By.XPATH, ".//div[contains(@class, 'author-middle')]/span")
    self._middle_input = (By.XPATH, ".//div[contains(@class, 'author-middle')]/input")
    self._last_lbl = (By.XPATH, ".//div[contains(@class, 'author-top')]/div[3]/span")
    self._last_input = (By.XPATH, ".//div[contains(@class, 'author-top')]/div[3]/input")
    self._email_lbl = (By.XPATH, ".//div[contains(@class, 'author-half')]/span")
    self._email_input = (By.XPATH, ".//div[contains(@class, 'author-half')]/input")
    self._title_lbl = (By.XPATH, ".//div[contains(@class, 'add-author-form')]/div[2]/div/span")
    self._title_input = (By.XPATH, ".//div[contains(@class, 'add-author-form')]/div[2]/div/input")
    self._department_lbl = (By.XPATH,
      ".//div[contains(@class, 'add-author-form')]/div[2]/div[2]/span")
    self._department_input = (By.XPATH,
      ".//div[contains(@class, 'add-author-form')]/div[2]/div[2]/input")
    self._institution_div = (By.CLASS_NAME, 'did-you-mean-input')
    self._author_lbls = (By.CLASS_NAME, 'author-label')
    self._author_contrib_lbl = (By.TAG_NAME, 'h4')
    self._add_author_cancel_lnk = (By.CSS_SELECTOR, 'span.author-form-buttons a')
    self._add_author_add_btn = (By.CSS_SELECTOR, 'span.author-form-buttons button')


    #Author Contributions

   #POM Actions
  def click_task_completed_checkbox(self):
    """Click task completed checkbox"""
    self._get(self._click_task_completed).click()
    return self

  def click_close_button_bottom(self):
    """Click close button on bottom"""
    self._get(self._close_button_bottom).click()
    return self

  def get_stylegiude(self):
    self._driver.get('https://staging.tahi-project.org/styleguide')
    import time; time.sleep(2)
    self._cardtabs = (By.XPATH, '//ul[@id="tabs"]/li[2]/a')
    self._get(self._cardtabs).click()
    #self._authors_title = (By.TAG_NAME, 'h1')
    #title = self._get(self._authors_title)
    i = (By.CSS_SELECTOR, 'div.constrain h4')
    #h4 = self._get(self._author_contrib_lbl)
    h4 = self._get(i)
    print h4.text, h4.value_of_css_property('font-size'), h4.value_of_css_property('font-weight'), h4.value_of_css_property('line-height'), h4.value_of_css_property('color')
    kk


  def validate_author_card_styles(self):
    """Validate """
    authors_title = self._get(self._authors_title)
    assert authors_title.text == 'Authors', authors_title.text
    # Commented out until bug #103346066 is fixed
    #self.validate_card_h1_style(authors_title)
    authors_text = self._get(self._authors_text)
    assert authors_text.text == (
    "Our criteria for authorship are based on the 'Uniform Requirements for Manuscripts "
    "Submitted to Biomedical Journals: Authorship and Contributorship'. Individuals whose "
    "contributions fall short of authorship should instead be mentioned in the "
    "Acknowledgments. If the article has been submitted on behalf of a consortium, all "
    "author names and affiliations should be listed at the end of the article."
    )
    self.validate_p_style(authors_text)
    add_new_author_btn = self._get(self._add_new_author_btn)
    assert 'ADD A NEW AUTHOR' == add_new_author_btn.text, add_new_author_btn.text
    self.validate_green_backed_button_style(add_new_author_btn)

  def validate_author_card_action(self):
    """ """
    # Add a new author
    self._get(self._add_new_author_btn).click()
    # Check form elements
    first_lbl = self._get(self._first_lbl)
    first_input = self._get(self._first_input)
    middle_lbl = self._get(self._middle_lbl)
    middle_input = self._get(self._middle_input)
    last_lbl = self._get(self._last_lbl)
    last_input = self._get(self._last_input)
    email_lbl = self._get(self._email_lbl)
    email_input = self._get(self._email_input)
    title_lbl = self._get(self._title_lbl)
    title_input = self._get(self._title_input)
    department_lbl = self._get(self._department_lbl)
    department_input = self._get(self._department_input)
    assert first_lbl.text == 'First Name', first_lbl.text
    assert middle_lbl.text == 'MI', middle_lbl.text
    assert last_lbl.text == 'Last Name', last_lbl.text
    assert email_lbl.text == 'Email', email_lbl.text
    assert title_lbl.text == 'Title', title_lbl.text
    assert department_lbl.text == 'Department', department_lbl.text
    assert first_input.get_attribute('placeholder') == 'Jane'
    assert middle_input.get_attribute('placeholder') == 'M'
    assert last_input.get_attribute('placeholder') == 'Goodall'
    assert email_input.get_attribute('placeholder') == 'jane.goodall@science.com'
    assert title_input.get_attribute('placeholder') == "World's Foremost Expert on Chimpanzees"
    assert department_input.get_attribute('placeholder') == 'Primatology'
    institution_div, sec_institution_div = self._gets(self._institution_div)
    institution_input = institution_div.find_element_by_tag_name('input')
    assert institution_input.get_attribute('placeholder') == 'Institution'
    institution_icon = institution_div.find_element_by_css_selector('button i')
    assert set(['fa', 'fa-search']) == set(institution_icon.get_attribute('class').split(' '))
    sec_institution_input = sec_institution_div.find_element_by_tag_name('input')
    assert sec_institution_input.get_attribute('placeholder') == 'Secondary Institution'
    sec_institution_icon = sec_institution_div.find_element_by_css_selector('button i')
    assert set(['fa', 'fa-search']) == set(sec_institution_icon.get_attribute('class').split(' '))
    corresponding_lbl, deceased_lbl, chck_1_lbl, chck_2_lbl, chck_3_lbl, chck_4_lbl, \
      chck_5_lbl, chck_6_lbl = self._gets(self._author_lbls)
    assert corresponding_lbl.text == ('This person will be listed as the corresponding author'
      ' on the published article'), corresponding_lbl.text
    assert deceased_lbl.text == 'This person is deceased'
    assert chck_1_lbl.text == 'Conceived and designed the experiments'
    assert chck_2_lbl.text == 'Performed the experiments'
    assert chck_3_lbl.text == 'Analyzed the data'
    assert chck_4_lbl.text == 'Contributed reagents/materials/analysis tools'
    assert chck_5_lbl.text == 'Contributed to the writing of the manuscript'
    assert chck_6_lbl.text == 'Other'
    author_contrib_lbl = self._get(self._author_contrib_lbl)
    assert author_contrib_lbl.text == 'Author Contributions'
    self.validate_card_h4_style(author_contrib_lbl)
    add_author_cancel_lnk = self._get(self._add_author_cancel_lnk)
    add_author_add_btn = self._get(self._add_author_add_btn)
    self.validate_green_on_green_button_style(add_author_add_btn)
    self.validate_default_link_style(add_author_cancel_lnk)
    # fill the data
    first_input.send_keys(author['first'] + Keys.ENTER)
    middle_input.send_keys(author['middle'] + Keys.ENTER)
    last_input.send_keys(author['last'] + Keys.ENTER)
    email_input.send_keys(author['email'] + Keys.ENTER)
    title_input.send_keys('Dr' + Keys.ENTER)
    department_input.send_keys(author['department'] + Keys.ENTER)
    institution_input.send_keys(author['1_institution'] + Keys.ENTER)
    sec_institution_input.send_keys(author['2_institution'] + Keys.ENTER)
    import time; time.sleep(10)
    add_author_add_btn.click()

  def validate_styles(self):
    """Validate all styles for Authors Card"""
    ##self.get_stylegiude()
    # validate elements that are common to all cards
    ##self.validate_author_card_styles()
    self.validate_author_card_action()
    ##self.validate_common_elements_styles()




    return self
