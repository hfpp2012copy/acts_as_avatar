# frozen_string_literal: true

module ActsAsAvatar
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_avatar(*args)
      options = args.extract_options!
      # options.extract!
      random_image_engine = options.delete(:random_image_engine)
      inline_svg_engine = options.delete(:inline_svg_engine)

      define_singleton_method :random_image_engine do
        if random_image_engine.nil?
          ActsAsAvatar.configuration.random_image_engine
        else
          random_image_engine
        end
      end

      define_singleton_method :inline_svg_engine do
        if inline_svg_engine.nil?
          ActsAsAvatar.configuration.inline_svg_engine
        else
          inline_svg_engine
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
