# frozen_string_literal: true

module ActsAsAvatar
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_avatar(*args)
      options = args.extract_options!
      # options.extract!
      uifaces_random_avatar = options.delete(:uifaces_random_avatar)

      define_singleton_method :uifaces_random_avatar do
        if uifaces_random_avatar.nil?
          ActsAsAvatar.configuration.uifaces_random_avatar
        else
          uifaces_random_avatar
        end
      end
      has_one :avatar, as: :avatarable, class_name: "ActsAsAvatar::Avatar"
      accepts_nested_attributes_for :avatar
      delegate :current_avatar, :default_avatar, :upload_avatar, to: :avatar
      # include InstanceMethods
      after_create_commit { create_avatar }
    end
  end

  # module InstanceMethods
  #   def avatar
  #     super || build_avatar
  #   end
  # end
end
