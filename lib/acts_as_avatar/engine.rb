# frozen_string_literal: true

module ActsAsAvatar
  class Engine < Rails::Engine
    isolate_namespace ActsAsAvatar

    initializer "acts_as_avatar.insert_into_active_record" do
      ActiveSupport.on_load :active_record do
        # include ActsAsAvatar::ClassMethods
        ActiveRecord::Base.include ActsAsAvatar
        ActiveRecord::Base.include ActsAsAvatar::ClassMethods
      end

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send(:helper, ActsAsAvatar::Helper)
      end
    end
  end
end
