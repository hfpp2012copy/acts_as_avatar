# frozen_string_literal: true

require_relative "acts_as_avatar/generators/install_generator"

module ActsAsAvatar
  autoload :VERSION, "acts_as_avatar/version"
  require_relative "acts_as_avatar/configuration"

  autoload :Request, "acts_as_avatar/request"
  autoload :Model, "acts_as_avatar/model"

  require_relative "acts_as_avatar/class_methods"

  require_relative "acts_as_avatar/railtie" if defined? Rails::Railtie
end
