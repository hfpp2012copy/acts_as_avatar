require "initials"

module ActsAsAvatar
  module Helper
    def acts_as_avatar_tag(object, name:, size: 60, **options)
      if object.current_avatar.attached?
        image_tag object.current_avatar.variant(resize_to_fill: [size, size]), **options
      else
        name = object.send(name.to_sym)

        if ActsAsAvatar.configuration.inline_svg_engine.to_sym == :initial_avatar
          initial_avatar_tag(name, size: size, **options)
        else
          initials_tag(name, size: size, **options)
        end
      end
    end

    def initial_avatar_tag(name, size:, **options)
      opts = {
        colors: options[:colors],
        text_color: options[:text_color],
        font_weight: options[:font_weight],
        font_family: options[:font_family],
        seed: options[:seed]
      }.compact

      limit = options[:limit] || 1

      image_tag InitialAvatar.avatar_data_uri(name.first(limit), size: size, **opts), **options
    end

    def initials_tag(name, size:, **options)
      opts = {
        colors: options[:colors], # number of different colors, default: 12
        limit: options[:limit], # maximal initials length, default: 3
        shape: options[:shape], # background shape, default: :cirlce
      }.compact

      Initials.svg name, size: size, **opts
    end
  end
end
