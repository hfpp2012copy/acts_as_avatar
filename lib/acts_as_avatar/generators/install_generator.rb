# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module ActsAsAvatar
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.join(__dir__, "templates")
      desc "Install acts_as_avatar"

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          format("%<migration_number>.3d",
                 migration_number: current_migration_number(dirname) + 1)
        end
      end

      def create_initializer
        template "initializer.rb", "config/initializers/acts_as_avatar.rb"
      end

      def create_migration_file
        migration_template(
          "migration.rb.erb",
          "db/migrate/acts_as_avatar_migration.rb",
          migration_version: migration_version
        )
        puts "\nPlease run this migration:\n\n    rails db:migrate"
      end

      private

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
