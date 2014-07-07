require File.join(File.dirname(__FILE__), 'app/controllers/users_controller_patch')
require File.join(File.dirname(__FILE__), 'app/controllers/members_controller_patch')
require File.join(File.dirname(__FILE__), 'app/models/mailer')
require "redmine"

Redmine::Plugin.register :invitable do
  name 'Invitable plugin'
  author 'Dotgee'
  description 'Invite people to projects'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
