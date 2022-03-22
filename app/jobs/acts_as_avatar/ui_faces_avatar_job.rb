# frozen_string_literal: true

class ActsAsAvatar::UiFacesAvatarJob < ActiveJob::Base
  queue_as :default

  def perform(global_id)
    object = GlobalID::Locator.locate global_id

    object.avatar.send(:add_uifaces_avatar)
  end
end
