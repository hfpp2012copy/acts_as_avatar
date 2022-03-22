# frozen_string_literal: true

require "singleton"

module ActsAsAvatar
  class GithubAvatar
    include Singleton

    def random_svg_avatar(complexity: 16, render_method: "square", size: 256, rounded_circle: false, **_options)
      source = File.join(File.expand_path("../../", File.dirname(__FILE__)), "github_avatar.js")
      js = File.read(source)
      context = ExecJS.compile(js)
      context.call("getRandomAvatar", complexity, render_method, size, rounded_circle)
    end
  end
end
