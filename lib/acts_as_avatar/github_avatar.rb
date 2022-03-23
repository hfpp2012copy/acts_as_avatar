# frozen_string_literal: true

require "singleton"

module ActsAsAvatar
  class GithubAvatar
    include Singleton

    #
    # Default options:
    #
    #   comlexity: 16
    #
    #   redner_method: squad
    #
    def random_svg_avatar(size:, complexity: 5, render_method: "square", rounded_circle: false)
      source = File.join(File.expand_path("../../", File.dirname(__FILE__)), "github_avatar.js")
      js = File.read(source)
      context = ExecJS.compile(js)
      context.call("getRandomAvatar", complexity, render_method, size, rounded_circle)
    end
  end
end
