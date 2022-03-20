# frozen_string_literal: true

class UiFacesAvatarJob < ApplicationJob
  queue_as :default

  def perform(admin_user_id)
    admin_user = AdminUser.find(admin_user_id)

    random_image = ActsAsAvatar::Request.read_image

    return unless random_image

    admin_user.default_avatar.attach(
      io: random_image,
      filename: "default_avatar.jpg"
    )
  end
end
