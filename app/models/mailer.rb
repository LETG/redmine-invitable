require 'active_support/concern'
module Invitable
  extend ActiveSupport::Concern
  included do

    def account_information(user, password, is_new_member = false, project_name = nil, inviter = nil)
      set_language_if_valid user.language
      @user = user
      @password = password

      if is_new_member
        #@login_url = url_for(:controller => 'my', :action => 'account')
        @password = ""
	      @login_url = "https://www-iuem.univ-brest.fr/pops"
	      @project_name = project_name
	      @inviter = inviter

        mail :to => user.mail,
            :subject => "Invitation au projet #{project_name} par #{inviter}"
      else
        @login_url = url_for(:controller => 'account', :action => 'login')
        
        mail :to => user.mail,
             :subject => l(:mail_subject_register, Setting.app_title)
      end
    end
  end
end

Mailer.send(:include, Invitable)
