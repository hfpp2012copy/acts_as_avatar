require "initials"

module ActsAsAvatar
  module Helper
    def acts_as_avatar_tag(object, name:, size: 60, **options)
      if object.current_avatar.attached?
        image_tag object.current_avatar.variant(resize_to_fill: [size, size]), **options
      else
        Initials.svg object.send(name.to_sym), size: size, **options
      end
    end
  end
end
