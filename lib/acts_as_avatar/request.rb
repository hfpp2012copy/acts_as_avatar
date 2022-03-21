# frozen_string_literal: true

require "singleton"
require "forwardable"

module ActsAsAvatar
  class Request
    # private_class_method :new
    include Singleton

    URL = ActsAsAvatar.configuration.uifaces_uri
    API_KEY = ActsAsAvatar.configuration.uifaces_api_key

    %w[uifaces_gender uifaces_limit].each do |name|
      attr_writer name.to_sym

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} ||= ActsAsAvatar.configuration.instance_variable_get("@#{name}")
        end
      RUBY
    end

    class << self
      extend Forwardable
      delegate %i[read_image] => :instance
    end

    def params
      if uifaces_gender.nil?
        "popular&limit=#{uifaces_limit}"
      else
        "gender%5B%5D=#{uifaces_gender}&limit=#{uifaces_limit}"
      end
    end

    # Get a random image
    #
    # @example
    #   ActsAsAvatar::Request.read_image
    #
    #   ActsAsAvatar::Request.read_image uifaces_limit: 20, uifaces_gender: "female"
    #
    #   instance = ActsAsAvatar::Request.instance
    #   instance.uifaces_gender = "male"
    #   instance.uifaces_limit  = 20
    #   instance.read_image
    #
    # @param [String] uifaces_gender
    #   the gender is male or female
    # @param [Integer] uifaces_limit
    #   the count of the image records
    #
    # @api public
    def read_image(options={})
      # configuration = {
      #   uifaces_gender: ActsAsAvatar.configuration.uifaces_gender,
      #   uifaces_limit: ActsAsAvatar.configuration.uifaces_limit
      # }
      #
      # configuration.update(options) if options.is_a?(Hash)

      opts = ActsAsAvatar.configuration.default_options.merge(options)

      @uifaces_gender = opts[:uifaces_gender]
      @uifaces_limit = opts[:uifaces_limit]

      URI.parse(image_url).open if image_url
    end

    private

    def request
      { success: true, res: HTTP.headers("x-api-key": API_KEY).get("#{URL}?#{params}") }
    rescue StandardError => e
      { success: false, message: e.to_s }
    end

    def image_url
      return unless request[:success] && request[:res].status.success?

      result = request[:res].parse(:json)
      result[rand(uifaces_limit.to_i - 1)]["photo"]
    end
  end
end
