# frozen_string_literal: true

module ActsAsAvatar
  class Request
    # private_class_method :new
    include Singleton

    URL = ActsAsAvatar.configuration.uri
    API_KEY = ActsAsAvatar.configuration.api_key

    %w[gender limit].each do |name|
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
      if gender.nil?
        "popular&limit=#{limit}"
      else
        "gender%5B%5D=#{gender}&limit=#{limit}"
      end
    end

    # Get a random image
    #
    # @example
    #   ActsAsAvatar::Request.read_image
    #
    #   ActsAsAvatar::Request.read_image limit: 20, gender: "female"
    #
    #   instance = ActsAsAvatar::Request.instance
    #   instance.gender = "male"
    #   instance.limit  = 20
    #   instance.read_image
    #
    # @param [String] gender
    #   the gender is male or female
    # @param [Integer] limit
    #   the count of the image records
    #
    # @api public
    def read_image(options={})
      configuration = {
        gender: ActsAsAvatar.configuration.gender,
        limit: ActsAsAvatar.configuration.limit
      }

      configuration.update(options) if options.is_a?(Hash)

      @gender = configuration[:gender]
      @limit = configuration[:limit]
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
      result[rand(limit.to_i - 1)]["photo"]
    end
  end
end
