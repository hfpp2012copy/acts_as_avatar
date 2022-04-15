# frozen_string_literal: true

require_relative "lib/acts_as_avatar/version"

Gem::Specification.new do |spec|
  spec.name = "acts_as_avatar"
  spec.version = ActsAsAvatar::VERSION
  spec.authors = ["hfpp2012"]
  spec.email = ["hfpp2012@gmail.com"]

  spec.summary = "自定义头像"
  spec.homepage = "https://github.com/hfpp2012/acts_as_avatar"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/hfpp2012/acts_as_avatar/issues",
    "changelog_uri" => "https://github.com/hfpp2012/acts_as_avatar/releases",
    "source_code_uri" => "https://github.com/hfpp2012/acts_as_avatar",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt github_avatar.js README.md {exe,lib,app}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "active_storage_validations", "~> 0.9.6"
  spec.add_dependency "execjs", "~> 2.8.1"
  spec.add_dependency "forwardable", "~> 1.3.2"
  spec.add_dependency "http", "~> 5.0.4"
  spec.add_dependency "icodi", "~> 0.1.3"
  spec.add_dependency "initial_avatar", "~> 0.2.2"
  spec.add_dependency "initials", "~> 0.4.2"
  spec.add_dependency "letter_avatar", "~> 0.3.9"
  spec.add_dependency "marcel", "~> 1.0"
  spec.add_dependency "rails", "~> 7.0.2"
  spec.add_dependency "ruby_identicon", "~> 0.0.6"
  spec.add_dependency "singleton", "~> 0.1.1"
  spec.add_dependency "stringio", "~> 3.0.1"
  spec.add_dependency "uri", "~> 0.10.0"
  spec.add_dependency "nokogiri", "~> 1.13.3"
end
