#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2012-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class MeetingParticipant < ActiveRecord::Base
  unloadable

  belongs_to :meeting
  belongs_to :user

  scope :invited, :conditions => {:invited => true}
  scope :attended, :conditions => {:attended => true}

  attr_accessible :email, :name, :invited, :attended, :user, :user_id, :meeting

  User.before_destroy do |user|
    MeetingParticipant.update_all ['user_id = ?', DeletedUser.first], ['user_id = ?', user.id]
  end

  def name
    user.present? ? user.name : self.name
  end

  def mail
    user.present? ? user.mail : self.mail
  end

  def <=>(participant)
    self.to_s.downcase <=> participant.to_s.downcase
  end

  alias :to_s :name
end

