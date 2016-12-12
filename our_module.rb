module OurModule
  def register_user
    @driver.navigate.to 'http://demo.redmine.org'
    @driver.find_element(:class => 'register').click

    @wait.until {@driver.find_element(:id => 'user_login').displayed?}

    @login = ('login' + rand(99999).to_s)

    @driver.find_element(:id => 'user_login').send_keys @login
    @driver.find_element(:id => 'user_password').send_keys @login
    @driver.find_element(:id => 'user_password_confirmation').send_keys @login
    @driver.find_element(:id => 'user_firstname').send_keys @login
    @driver.find_element(:id => 'user_lastname').send_keys @login
    @driver.find_element(:id => 'user_mail').send_keys(@login + '@test.user')

    @driver.find_element(:name => 'commit').click
  end

  def logout_click
    @wait.until {@driver.find_element(:class => 'logout').displayed?}
    @driver.find_element(:class => 'logout').click
  end

  def login_click
    @wait.until {@driver.find_element(:class => 'login').displayed?}
    @driver.find_element(:class => 'login').click
  end

  def login_form
    @wait.until {@driver.find_element(:id => 'username').displayed?}
    @driver.find_element(:id => 'username').send_keys(@login)
    @wait.until {@driver.find_element(:id => 'password').displayed?}
    @driver.find_element(:id => 'password').send_keys(@login)
  end

  def login_confirmation
    @driver.find_element(:name => 'login').click
  end

  def login
    login_click
    login_form
    login_confirmation
  end

  def change_password
    @wait.until {@driver.find_element(:css => '.icon.icon-passwd').displayed?}
    @driver.find_element(:css => '.icon.icon-passwd').click

    password_new = @login + '1'
    @wait.until {@driver.find_element(:id => 'password').displayed?}
    @driver.find_element(:id => 'password').send_keys(@login)
    @driver.find_element(:id => 'new_password').send_keys(password_new)
    @driver.find_element(:id => 'new_password_confirmation').send_keys(password_new)

    @driver.find_element(:name => 'commit').click
  end

  def create_project_open_page
    @wait.until {@driver.find_element(:class => 'projects').displayed?}
    @driver.find_element(:class => 'projects').click

    @wait.until {@driver.find_element(:css => '.icon.icon-add').displayed?}
    @driver.find_element(:css => '.icon.icon-add').click
  end

  def create_project_fill_form
    @project_name = ('project' + rand(99999).to_s)
    @wait.until {@driver.find_element(:id => 'project_name').displayed?}
    @driver.find_element(:id => 'project_name').send_keys(@project_name)
    @driver.find_element(:id => 'project_description').send_keys('Description for ' + @project_name)
    @driver.find_element(:id => 'project_identifier').send_keys('uid_' + @project_name)
    @driver.find_element(:id => 'project_homepage').send_keys('http://demo.redmine.org/my/account')
  end

  def create_project_commit
    @driver.find_element(:css => 'input[name=commit]').click
  end

  def create_project
    create_project_open_page
    create_project_fill_form
    create_project_commit
  end

  def add_user_to_proj_open_members
    @wait.until {@driver.find_element(:id => 'tab-members').displayed?}
    @driver.find_element(:id => 'tab-members').click
  end

  def add_user_to_proj_new_member
    #клик на "Новый участник"
    @wait.until {@driver.find_element(:css => '#tab-content-members .icon.icon-add').displayed?}
    @driver.find_element(:css => '#tab-content-members .icon.icon-add').click
    #ввод юзера в сёрч
    @wait.until {@driver.find_element(:id => 'principal_search').displayed?}
    @driver.find_element(:id => 'principal_search').send_keys(@additional_user)
    #клик на чекбокс по юзеру
    sleep 1
    @wait.until {@driver.find_element(:css => '#principals input').displayed?}
    @driver.find_element(:css => '#principals input').click
  end

  def add_user_to_proj_set_role
    #клик на чекбокс роли
    @wait.until {@driver.find_element(:css => '.roles-selection input[value="3"]').displayed?}
    @driver.find_element(:css => '.roles-selection input[value="3"]').click
  end

  def add_user_to_proj_submit
    #подтверждение добавления
    @wait.until {@driver.find_element(:id => 'member-add-submit').displayed?}
    @driver.find_element(:id => 'member-add-submit').click
  end

  def add_user_to_project
    add_user_to_proj_open_members
    add_user_to_proj_new_member
    add_user_to_proj_set_role
    add_user_to_proj_submit
  end

  def user_role_resolve_name
    @name = ''
    names = @driver.find_elements(:css => '.name.user')
    names_count = @driver.find_elements(:css => '.name.user').count
    @name_index = 0
    until ((@name == (@additional_user + ' ' + @additional_user)) || (@name_index >= names_count)) do
      @name = names[@name_index].text
      @name_index+=1
    end
    @name_index = @name_index - 1
  end

  def edit_user_role_click
    #клик на "режактировать"
    @wait.until {@driver.find_elements(:css => '.roles span')[@name_index].displayed?}
    buttons = @driver.find_elements(:css => '.icon.icon-edit')
    buttons[@name_index].click
  end

  def edit_user_role_uncheck
    #анчек предыдущей роли
    @wait.until {@driver.find_elements(:css => '.roles form')[@name_index].displayed?}
    @driver.find_elements(:css => '.roles input[value="3"]')[@name_index].click
  end

  def edit_user_role_check
    #чек новой роли
    @driver.find_elements(:css => '.roles input[value="4"]')[@name_index].click
  end

  def edit_user_role_submit
    #сохранение ролей
    @driver.find_elements(:css => '.roles form input[name="commit"]')[@name_index].click
  end

  def edit_user_role
    edit_user_role_click
    edit_user_role_uncheck
    edit_user_role_check
    edit_user_role_submit
  end

  def create_proj_ver_open_versions
    #переход на "Версии"
    @wait.until {@driver.find_element(:id => 'tab-versions').displayed?}
    @driver.find_element(:id => 'tab-versions').click
  end

  def create_proj_ver_new_version
    #добавление новой версии
    @wait.until {@driver.find_element(:css => 'a[href*="versions/new"]').displayed?}
    @driver.find_element(:css => 'a[href*="versions/new"]').click
  end

  def create_proj_ver_fill_form
    #заполнение формы версии
    @version = ('Version' + rand(99999).to_s)
    @wait.until {@driver.find_element(:id => 'version_name').displayed?}
    @driver.find_element(:id => 'version_name').send_keys(@version)
    @driver.find_element(:id => 'version_description').send_keys(@version + ' Description')
    @driver.find_element(:id => 'version_wiki_page_title').send_keys(@version + ' wiki page')
    @driver.find_element(:id => 'version_effective_date').send_keys(Date.today)
  end

  def create_proj_ver_commit
    @driver.find_element(:name => 'commit').click
  end

  def create_project_version
    create_proj_ver_open_versions
    create_proj_ver_new_version
    create_proj_ver_fill_form
    create_proj_ver_commit
  end

  def issue_type_bug
    @issue_subj = 'Bug ' + rand(99999).to_s
    @issue_type = 'Bug'
  end

  def issue_type_feature
    @issue_subj = 'Feature ' + rand(99999).to_s
    @issue_type = 'Feature'
  end

  def issue_type_support
    @issue_subj = 'Support ' + rand(99999).to_s
    @issue_type = 'Support'
  end

  def create_issue_new_issue
    #переход на "Новая задача"
    @wait.until {@driver.find_element(:class => 'new-issue').displayed?}
    @driver.find_element(:class => 'new-issue').click
  end

  def create_issue_fill_form
    @wait.until {@driver.find_element(:id => 'issue_tracker_id').displayed?}
    @driver.find_element(:id => 'issue_tracker_id').send_keys(@issue_type)
    @driver.find_element(:id => 'issue_subject').send_keys(@issue_subj)
    @driver.find_element(:id => 'issue_description').send_keys('Description')
    @driver.find_element(:id => 'issue_assigned_to_id').send_keys(@login)
    @driver.find_element(:id => 'issue_fixed_version_id').send_keys(@version)
  end

  def create_issue_commit
    @driver.find_element(:css => 'input[name="commit"]').click
  end

  def create_issue
    create_issue_new_issue
    create_issue_fill_form
    create_issue_commit
  end

  def issue_added_resolve_name
    @issue_title = ''
    issues_titles = @driver.find_elements(:css => '.subject a')
    issues_count = @driver.find_elements(:css => '.subject a').count
    @issue_index = 0
    until ((@issue_title == @issue_subj) || (@issue_index >= issues_count)) do
      @issue_title = issues_titles[@issue_index].text
      @issue_index+=1
    end
    @issue_index = @issue_index - 1
  end

  def tab_open_issues
    #переход на "Задачи"
    @wait.until {@driver.find_element(:css => '.issues.selected').displayed?}
    @driver.find_element(:css => '.issues.selected').click
  end
end