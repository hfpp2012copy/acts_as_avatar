# frozen_string_literal: true

require "singleton"

module ActsAsAvatar
  class GithubAvatar
    include Singleton

    #
    # Default options:
    #
    #   complexity: 16
    #
    #   redner_method: squad
    #
    def random_svg_avatar(size:, github_complexity:, github_render_method:, github_rounded_circle:)
      source = File.join(File.expand_path("../../", File.dirname(__FILE__)), "github_avatar.js")
      js = File.read(source)
      context = ExecJS.compile(js)
      context.call("getRandomAvatar", github_complexity, github_render_method, size, github_rounded_circle)
    end
  end
end
