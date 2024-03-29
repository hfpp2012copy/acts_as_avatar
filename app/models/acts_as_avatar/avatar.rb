# frozen_string_literal: true

# == Schema Information
#
# Table name: act_as_avatars
#
#  id              :bigint           not null, primary key
#  avatarable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  avatarable_id   :bigint           not null
#
# Indexes
#
#  index_avatars_on_avatarable  (avatarable_type,avatarable_id)
#
require "marcel"
require "ruby_identicon"
require "letter_avatar"
require "active_storage_validations"

module ActsAsAvatar
  class Avatar < ActiveRecord::Base
    # Table name
    self.table_name = "acts_as_avatars"

    # belongs_to :avatarable, polymorphic: true
    delegated_type :avatarable, types: ActsAsAvatar.configuration.class_type
    validates :avatarable_type, presence: true
    # delegate :email, to: :avatarable
    # accepts_nested_attributes_for :avatarable
    has_one_attached :upload_avatar
    has_one_attached :default_avatar
    after_create_commit :add_default_avatar, if: -> { random_image_engine.present? }
    validates :upload_avatar, size: { less_than: ActsAsAvatar.configuration.upload_max_size },
                              content_type: %r{\Aimage/.*\z}
    after_create_commit :sanitize_svg, if: :svg?

    def current_avatar
      upload_avatar.attached? ? upload_avatar : default_avatar
    end

    def add_default_avatar
      # return if default_avatar.attached?

      case random_image_engine.to_sym
      when :uifaces_avatar
        ActsAsAvatar::UiFacesAvatarJob.perform_later(avatarable.to_global_id.to_s)
      when :letter_avatar
        add_letter_avatar
      when :identicon_avatar
        add_identicon_avatar
      when :github_avatar
        add_github_avatar
      end
    end

    private

    def svg?
      return if current_avatar.blob.nil?

      current_avatar.blob.filename.extension == "svg"
    end

    def sanitize_svg
      ActsAsAvatar::SanitizeSvgJob.set(wait: 10.seconds).perform_later current_avatar.blob
    end

    def random_image_engine
      avatarable.class.random_image_engine
    end

    def add_identicon_avatar
      io = RubyIdenticon.create(text)

      default_avatar.attach(
        io: StringIO.new(io),
        filename: default_file_name,
        content_type: content_type(io)
      )
    end

    def add_uifaces_avatar
      io = ActsAsAvatar::Request.read_image

      return unless io

      default_avatar.attach(
        io: io,
        filename: default_file_name,
        content_type: content_type(io)
      )
    end

    def add_letter_avatar
      io = File.open(LetterAvatar.generate(text, 200))

      default_avatar.attach(
        io: io,
        filename: default_file_name,
        content_type: content_type(io)
      )
    end

    def add_github_avatar
      size = ActsAsAvatar.configuration.avatar_size

      complexity     = ActsAsAvatar.configuration.github_complexity
      render_method  = ActsAsAvatar.configuration.github_render_method
      rounded_circle = ActsAsAvatar.configuration.github_rounded_circle

      io = ActsAsAvatar::GithubAvatar.instance.random_svg_avatar(
        size: size,
        github_complexity: complexity,
        github_render_method: render_method,
        github_rounded_circle: rounded_circle
      )

      filename = "#{default_file_name}.svg"

      default_avatar.attach(
        io: StringIO.new(io),
        filename: filename,
        content_type: "image/svg+xml"
      )
    end

    def default_file_name
      ActsAsAvatar.configuration.default_file_name
    end

    def text
      name = ActsAsAvatar.configuration.avatar_name.to_sym
      avatarable.send(name.to_sym)
    end

    def content_type(io)
      Marcel::MimeType.for(io)
    end
  end
end
