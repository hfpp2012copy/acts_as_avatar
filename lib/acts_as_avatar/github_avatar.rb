# frozen_string_literal: true

require "singleton"

module ActsAsAvatar
  class GithubAvatar
    include Singleton

    def random_svg_avatar(*args)
      source = File.join(File.expand_path("../../", File.dirname(__FILE__)), "github_avatar.js")
      js = File.read(source)
      context = ExecJS.compile(js)
      context.call("getRandomAvatar", *args)
    end
  end
end
