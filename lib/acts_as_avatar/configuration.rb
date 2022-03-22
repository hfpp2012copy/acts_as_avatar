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
    attr_accessor :uifaces_gender,
                  :uifaces_limit,
                  :uifaces_uri,
                  :uifaces_api_key,
                  :random_image_engine,
                  :default_file_name,
                  :upload_max_size,
                  :class_type,
                  :avatar_name,
                  :inline_svg_engine

    def initialize
      @uifaces_uri         = "https://api.uifaces.co"
      @uifaces_api_key     = "72694e5b5dee4706edc0acad3d4291"
      @uifaces_gender      = nil
      @uifaces_limit       = 72
      @random_image_engine = nil
      @default_file_name   = "default_avatar"
      @upload_max_size     = 2.megabytes
      @class_type          = %w[User]
      @avatar_name         = :name
      @inline_svg_engine   = :initial_avatar
    end

    def default_options
      instance_variables.map { |key| [key.to_s.sub("@", "").to_sym, instance_variable_get(key)] }.to_h
    end
  end
end
