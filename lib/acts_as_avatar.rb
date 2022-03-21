# frozen_string_literal: true

require_relative "acts_as_avatar/generators/install_generator"

module ActsAsAvatar
  autoload :VERSION, "acts_as_avatar/version"
  autoload :Request, "acts_as_avatar/request"

  require_relative "acts_as_avatar/configuration"
  require_relative "acts_as_avatar/class_methods"
  require_relative "acts_as_avatar/helper"
  require_relative "acts_as_avatar/engine" if defined? Rails::Engine
end
