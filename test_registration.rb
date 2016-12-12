require 'test/unit'
require 'selenium-webdriver'
require_relative 'our_module'

class TestRegistration < Test::Unit::TestCase
  include OurModule

  #Initial Setup
  def setup
    @profile = Selenium::WebDriver::Firefox::Profile.new
    @profile['reader.parse-on-load.enabled'] = false

    @driver = Selenium::WebDriver.for :firefox, :profile => @profile, :desired_capabilities => {:marionette => false}
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  #Registration
  def test_registration
    register_user

    @wait.until {@driver.find_element(:id => 'flash_notice').displayed?}
    register_success = @driver.find_element(:id => 'flash_notice')
    assert(register_success.displayed?)
  end

  #Log Out after registration
  def test_log_out_r
    register_user
    logout_click

    @wait.until {@driver.find_element(:class => 'login').displayed?}
    login_button = @driver.find_element(:class => 'login')
    assert(login_button.displayed?)
  end

  #Log In
  def test_log_in
    register_user
    logout_click
    login

    @wait.until {@driver.find_element(:id => 'loggedas').displayed?}
    expected_login = @login
    #actual_login = @driver.find_element(:css => 'div[id="loggedas"] a.user.active').text
    actual_login = @driver.find_element(:css => '#loggedas .user').text
    assert_equal(expected_login,actual_login)
  end

  #Log Out after logging in
  def test_log_out_i
    register_user
    logout_click
    login
    logout_click

    @wait.until {@driver.find_element(:class => 'login').displayed?}
    login_button = @driver.find_element(:class => 'login')
    assert(login_button.displayed?)
  end

  #Change Password
  def test_change_password
    register_user
    change_password

    @wait.until {@driver.find_element(:id => 'flash_notice').displayed?}
    pwd_change_success = @driver.find_element(:id => 'flash_notice')
    assert(pwd_change_success.displayed?)
  end

  #Create Project
  def test_create_project
    register_user
    create_project

    @wait.until {@driver.find_element(:id => 'flash_notice').displayed?}
    project_create_success = @driver.find_element(:id => 'flash_notice')
    assert(project_create_success.displayed?)
  end

  #Add another (your) user to the Project
  def test_add_user_to_project
    register_user
    @additional_user = @login
    logout_click
    register_user
    create_project
    add_user_to_project
    @wait.until {@driver.find_element(:css => '.even.member').displayed?}
    user_role_resolve_name

    @wait.until {@driver.find_elements(:css => '.name.user')[@name_index].displayed?}
    expected_added_user = (@additional_user + ' ' + @additional_user)
    actual_added_user = @driver.find_elements(:css => '.name.user')[@name_index].text
    assert_equal(expected_added_user,actual_added_user)
  end

  #Edit their (users’) roles
  def test_edit_user_role
    register_user
    @additional_user = @login
    logout_click
    register_user
    create_project
    add_user_to_project
    @wait.until {@driver.find_element(:css => '.even.member').displayed?}
    user_role_resolve_name
    edit_user_role

    #Слип нужен, чтоб сортировка списка обновилась до начала метода юзер_резолв
    #!!! ПЕРЕДЕЛАТЬ !!!
    sleep 1
    user_role_resolve_name

    @wait.until {@driver.find_elements(:css => '.roles span')[@name_index].displayed?}
    expected_new_role = 'Developer'
    actual_new_role = @driver.find_elements(:css => '.roles span')[@name_index].text
    assert_equal(expected_new_role,actual_new_role)
  end

  #Create Project version
  def test_create_project_version
    register_user
    create_project
    create_project_version

    @wait.until {@driver.find_element(:id => 'flash_notice').displayed?}
    project_ver_create_success = @driver.find_element(:id => 'flash_notice')
    assert(project_ver_create_success.displayed?)
  end

  ###Create all 3 types of issues
  #Create Bug Issue
  def test_create_issue_bug
    register_user
    create_project
    create_project_version
    issue_type_bug
    create_issue

    @wait.until {@driver.find_element(:css => '.subject h3').displayed?}
    expected_issue_subj = @issue_subj
    actual_issue_subj = @driver.find_element(:css => '.subject h3').text
    assert_equal(expected_issue_subj,actual_issue_subj)
  end

  #Create Feature Issue
  def test_create_issue_feature
    register_user
    create_project
    create_project_version
    issue_type_feature
    create_issue

    @wait.until {@driver.find_element(:css => '.subject h3').displayed?}
    expected_issue_subj = @issue_subj
    actual_issue_subj = @driver.find_element(:css => '.subject h3').text
    assert_equal(expected_issue_subj,actual_issue_subj)
  end

  #Create Support Issue
  def test_create_issue_support
    register_user
    create_project
    create_project_version
    issue_type_support
    create_issue

    @wait.until {@driver.find_element(:css => '.subject h3').displayed?}
    expected_issue_subj = @issue_subj
    actual_issue_subj = @driver.find_element(:css => '.subject h3').text
    assert_equal(expected_issue_subj,actual_issue_subj)
  end

  #Ensure all 3 types of issues are visible on ‘Issues’ tab
  #Visible Bug Issue
  def test_visible_issue_bug
    register_user
    create_project
    create_project_version
    issue_type_bug
    create_issue
    tab_open_issues

    @wait.until {@driver.find_element(:css => '.subject a').displayed?}
    issue_added_resolve_name

    expected_visible_issue = @issue_subj
    actual_visible_issue = @driver.find_elements(:css => '.subject a')[@issue_index].text
    assert_equal(expected_visible_issue,actual_visible_issue)
  end

  #Visible Feature Issue
  def test_visible_issue_feature
    register_user
    create_project
    create_project_version
    issue_type_feature
    create_issue
    tab_open_issues

    @wait.until {@driver.find_element(:css => '.subject a').displayed?}
    issue_added_resolve_name

    expected_visible_issue = @issue_subj
    actual_visible_issue = @driver.find_elements(:css => '.subject a')[@issue_index].text
    assert_equal(expected_visible_issue,actual_visible_issue)
  end

  #Visible Support Issue
  def test_visible_issue_support
    register_user
    create_project
    create_project_version
    issue_type_support
    create_issue
    tab_open_issues

    @wait.until {@driver.find_element(:css => '.subject a').displayed?}
    issue_added_resolve_name

    expected_visible_issue = @issue_subj
    actual_visible_issue = @driver.find_elements(:css => '.subject a')[@issue_index].text
    assert_equal(expected_visible_issue,actual_visible_issue)
  end

  def teardown
    @driver.quit
  end
end