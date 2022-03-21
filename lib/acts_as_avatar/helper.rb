require "initials"

module ActsAsAvatar
  module Helper
    def acts_as_avatar_tag(object, name:, size: 60, **options)
      if object.current_avatar.attached?
        image_tag object.current_avatar.variant(resize_to_fill: [size, size]), **options
      else
        name = object.send(name.to_sym)

        if ActsAsAvatar.configuration.inline_svg_engine.to_sym == :initial_avatar
          image_tag InitialAvatar.avatar_data_uri(name.first, size: size), **options
        else
          opts = {
            colors: options[:colors], # number of different colors, default: 12
            limit: options[:limit], # maximal initials length, default: 3
            shape: options[:shape], # background shape, default: :cirlce
          }.compact

          Initials.svg name, size: size, **opts
        end
      end
    end
  end
end
