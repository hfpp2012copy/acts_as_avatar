# frozen_string_literal: true

require "marcel"

class ActsAsAvatar::UiFacesAvatarJob < ActiveJob::Base
  queue_as :default

  def perform(global_id)
    object = GlobalID::Locator.locate global_id

    random_image = ActsAsAvatar::Request.read_image

    return unless random_image

    object.default_avatar.attach(
      io: random_image,
      filename: ActsAsAvatar.configuration.default_file_name,
      content_type: Marcel::MimeType.for(random_image)
    )
  end
end
