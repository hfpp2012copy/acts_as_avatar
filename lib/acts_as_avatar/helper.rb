# frozen_string_literal: true

require "initials"
require "execjs"
require "initial_avatar"
require "icodi"

module ActsAsAvatar
  module Helper
    def acts_as_avatar_tag(object, name: nil, size: 60, **options)
      if object.current_avatar.attached?
        image_tag object.current_avatar.variant(resize_to_fill: [size, size]), **options
      else
        name = name.presence || ActsAsAvatar.configuration.avatar_name
        text = object.send(name.to_sym)

        inline_svg_engine = object.class.inline_svg_engine.to_sym

        case inline_svg_engine.to_sym
        when :initial_avatar
          initial_avatar_tag(text, size: size, **options)
        when :icodi_avatar
          icodi_avatar_tag(text, **options)
        when :initials
          initials_tag(text, size: size, **options)
        end
      end
    end

    def initial_avatar_tag(text, size:, **options)
      opts = options.extract!(:colors, :text_color, :font_weight, :font_family).compact

      limit = options[:limit] || 1

      image_tag InitialAvatar.avatar_data_uri(text.first(limit), size: size, **opts), **options
    end

    def initials_tag(text, size:, **options)
      #
      # number of different colors, default: 12
      # maximal initials length, default: 3
      # background shape, default: :cirlce
      #
      opts = options.extract!(:colors, :limit, :shape).compact

      Initials.svg text, size: size, **opts
    end

    def github_avatar_tag(**options)
      ActsAsAvatar::GithubAvatar.instance.random_svg_avatar(**options).html_safe
    end

    def icodi_avatar_tag(text, **options)
      #
      # https://github.com/DannyBen/icodi
      #
      # Default value:
      #
      # pixels: 5
      # mirror: :x
      # color:
      # density: 0.5
      # stroke: 0.1
      # jitter: 0
      # background: #fff
      # id: icodi
      #
      # SVG template to use.
      # Can be :default, :html or a path to a file. Read more on Victor SVG Templates.
      #
      # template: default
      opts = options.extract!(:pixels,
                              :density,
                              :mirror,
                              :color,
                              :stroke,
                              :jitter,
                              :id,
                              :template,
                              :background)

      pixels = opts[:pixels] || 8
      density = opts[:density] || 0.33

      svg = Icodi.new text, pixels: pixels, density: density, **opts
      svg.render.html_safe
    end
  end
end
