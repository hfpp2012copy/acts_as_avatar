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
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 7.0.2"
  spec.add_dependency "singleton", "~> 0.1.1"
  spec.add_dependency "forwardable", "~> 1.3.2"
end
