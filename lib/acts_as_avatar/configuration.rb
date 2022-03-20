# frozen_string_literal: true

require "active_support/core_ext/numeric/bytes"

module ActsAsAvatar
  @mutex = Mutex.new

  class << self
    def configuration
      @mutex.synchronize do
        @configuration ||= Configuration.new
      end
    end
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :gender,
                  :limit,
                  :uifaces_random_avatar,
                  :uri,
                  :api_key,
                  :default_file_name,
                  :upload_max_size,
                  :class_type

    def initialize
      @uri                   = "https://api.uifaces.co"
      @api_key               = "72694e5b5dee4706edc0acad3d4291"
      @gender                = nil
      @limit                 = 72
      @uifaces_random_avatar = nil
      @default_file_name     = "default_avatar"
      @upload_max_size       = 2.megabytes
      @class_type            = %w[User]
    end
  end
end
