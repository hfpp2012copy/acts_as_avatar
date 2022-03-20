# frozen_string_literal: true

require "marcel"

class ActsAsAvatar::UiFacesAvatarJob < ActiveJob::Base
  queue_as :default

  def perform(admin_user_id)
    admin_user = AdminUser.find(admin_user_id)

    random_image = ActsAsAvatar::Request.read_image

    return unless random_image

    admin_user.default_avatar.attach(
      io: random_image,
      filename: ActsAsAvatar.configuration.default_file_name,
      content_type: Marcel::MimeType.for(random_image)
    )
  end
end
