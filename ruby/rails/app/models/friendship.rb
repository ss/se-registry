# == Schema Information
#
# Table name: friends
#
#  user_id   :integer(4)      not null
#  friend_id :integer(4)      not null
#

class Friendship < ActiveRecord::Base

  set_table_name 'friends'

  belongs_to :user, :class_name=>'User', :foreign_key=>'user_id'
  belongs_to :friend, :class_name=>'User', :foreign_key=>'friend_id'

  attr_accessor :login_or_email

  # pseudo id since this class is primaliry used in the context of a user
  def id
    friend_id
  end

  def login_or_email
    @login_or_email ||= friend ? friend.login : ''
  end

  # overridden because there is no id on this model
  def destroy
    Friendship.delete_all ["user_id=? and friend_id=?", user_id, friend_id]
  end

  def validate_on_create

    if login_or_email.blank?
      errors.add(:login_or_email, "cannot be blank.")
      return
    end

    unless self.friend = User.find(:first, :conditions=>["login = ? or email = ?", login_or_email, login_or_email])
      errors.add_to_base "'#{login_or_email}' not found."
      return
    end

    if user_id == friend_id
      errors.add_to_base "You cannot befriend yourself."
      return
    end

    if Friendship.find(:first, :conditions=>["user_id = ? and friend_id = ?", user.id, friend.id])
      errors.add_to_base "'#{login_or_email}' is already your friend."
      return
    end

  end

end
