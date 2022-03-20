# frozen_string_literal: true

module ActsAsAvatar
  class Railtie < Rails::Railtie
    initializer "acts_as_avatar.insert_into_active_record" do
      ActiveSupport.on_load :active_record do
        # include ActsAsAvatar::ClassMethods
        ActiveRecord::Base.include ActsAsAvatar::ClassMethods
      end
    end
  end
end
