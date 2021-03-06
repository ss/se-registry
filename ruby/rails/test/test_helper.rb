ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'minitest/unit'
require 'mocha/minitest'

class ActiveSupport::TestCase

  def create_user(attrs={})
    attrs = {:login => attrs} if attrs.is_a?(String)

    attrs[:login]                 = 'quire'                         unless attrs.has_key?(:login)
    attrs[:password]              = 'my password'                   unless attrs.has_key?(:password)
    attrs[:password_confirmation] = 'my password'                   unless attrs.has_key?(:password_confirmation)
    attrs[:lead_time]             = 10                              unless attrs.has_key?(:lead_time)
    attrs[:email]                 = "#{attrs[:login]}@example.com"  unless attrs.has_key?(:email)

    User.create!(attrs)
  end

  def create_event(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring Event'     unless attrs.has_key?(:description)
    attrs[:class]       = Event                 unless attrs.has_key?(:class)
    attrs[:user]        = create_user('event')  unless attrs.has_key?(:user)
    attrs[:event_date]  = 10.days.from_now      unless attrs.has_key?(:event_date)
    attrs[:recur]       = true                  unless attrs.has_key?(:recur)

    attrs.delete(:class).create!(attrs)
  end

  def create_occasion(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring Occasion'  unless attrs.has_key?(:description)
    attrs[:class]       = Occasion

    create_event(attrs)
  end

  def create_reminder(attrs={})
    attrs = {:description => attrs} if attrs.is_a?(String)

    attrs[:description] = 'Recurring reminder' unless attrs.has_key?(:description)
    attrs[:class]       = Reminder

    create_event(attrs)
  end

  def create_gift(attrs={})
    attrs = {:description=>attrs} if attrs.is_a?(String)

    attrs[:user]        = create_user('gift') unless attrs.has_key?(:user)
    attrs[:description] = 'gift'              unless attrs.has_key?(:description)
    attrs[:url]         = 'url'               unless attrs.has_key?(:url)
    attrs[:price]       = 1.00                unless attrs.has_key?(:price)

    Gift.create!(attrs)
  end

  def login_as(user)
    user = user.login if user.respond_to?(:login)
    UserSession.create(User.where(:login => user).first || create_user(user))
  end

  def logout
    UserSession.find.destroy
  end

  def escape(string)
    ERB::Util.h(string)
  end

end

class Object
  def tap_pp(*args)
    tap {|ii| pp *args, ii}
  end
end

class ActionController::TestCase
  setup :activate_authlogic
end
