# frozen_string_literal: true

require "tempfile"

class ActsAsAvatar::SanitizeSvgJob < ActiveJob::Base
  include ActsAsAvatar::Scrubber
  queue_as :default

  def perform(blob)
    return unless blob.svg?
    return if blob.metadata[:sanitized]

    sanitized = sanitize(blob.download)
    Tempfile.open([blob.filename.base, blob.filename.extension]) do |file|
      file.print sanitized
      file.rewind
      blob.upload file
    end

    blob.metadata[:sanitized] = true
    blob.save
  end
end
