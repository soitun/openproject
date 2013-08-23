#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2010-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module OpenProject::GlobalRoles::Patches
  module AccessControlPatch
    def self.included(base)
      base.send(:extend, ClassMethods)

      base.class_eval do
        class << self
          alias_method :available_project_modules_without_no_global, :available_project_modules unless method_defined?(:available_project_modules_without_no_global)
          alias_method :available_project_modules, :available_project_modules_with_no_global
        end
      end
    end

    module ClassMethods
      def available_project_modules_with_no_global
        @available_project_modules = (
            @permissions.reject{|p| p.global? }.collect(&:project_module) +
            @project_modules_without_permissions
          ).uniq.compact
        available_project_modules_without_no_global
      end

      def global_permissions
        @permissions.select {|p| p.global?}
      end
    end
  end
end

Redmine::AccessControl.send(:include, OpenProject::GlobalRoles::Patches::AccessControlPatch)
