# frozen_string_literal: true

# == Schema Information
#
# Table name: act_as_avatars
#
#  id              :bigint           not null, primary key
#  avatarable_type :string           not null
#  default_avatar  :string
#  upload_avatar   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  avatarable_id   :bigint           not null
#
# Indexes
#
#  index_avatars_on_avatarable  (avatarable_type,avatarable_id)
#
require "marcel"

module ActsAsAvatar
  class Avatar < ActiveRecord::Base
    # Table name
    self.table_name = "act_as_avatars"

    # belongs_to :avatarable, polymorphic: true
    delegated_type :avatarable, types: ActsAsAvatar.configuration.class_type
    validates :avatarable_type, presence: true
    # delegate :email, to: :avatarable
    # accepts_nested_attributes_for :avatarable
    has_one_attached :upload_avatar
    has_one_attached :default_avatar
    after_commit :add_default_avatar, on: %i[create update]
    validates :upload_avatar, size: { less_than: ActsAsAvatar.configuration.upload_max_size },
                              content_type: %r{\Aimage/.*\z}

    def current_avatar
      upload_avatar.attached? ? upload_avatar : default_avatar
    end

    private

    def add_default_avatar
      return if default_avatar.attached?

      if avatarable.class.uifaces_random_avatar
        # uifaces random image
        ActsAsAvatar::UiFacesAvatarJob.perform_later(id)
      else
        add_letter_avatar
      end
    end

    def add_letter_avatar
      io = File.open(LetterAvatar.generate(avatarable.name, 200))

      default_avatar.attach(
        io: io,
        filename: ActsAsAvatar.configuration.default_file_name,
        content_type: Marcel::MimeType.for(io)
      )
    end
  end
end