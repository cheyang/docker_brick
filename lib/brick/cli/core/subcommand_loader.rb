

require 'brick/version'
module Brick
  class CLI
    class SubcommandLoader

     
      attr_reader :env

      def initialize( env=ENV)
        @env =  env
      end

      # Load all the sub-commands
      def load_commands
        subcommand_files.each { |subcommand| Kernel.load subcommand }
        true
      end

     

      def subcommand_files
        @subcommand_files ||= (find_subcommands_via_dirglob.values).flatten.uniq
      end

      def find_subcommands_via_dirglob
        # The "require paths" of the core knife subcommands bundled with chef
        files = Dir[File.expand_path('../../../cli/*.rb', __FILE__)]
        subcommand_files = {}
        files.each do |cli_file|
          rel_path = cli_file[/#{BRICK_ROOT}#{Regexp.escape(File::SEPARATOR)}(.*)\.rb/,1]
          subcommand_files[rel_path] = cli_file
        end
        subcommand_files
      end

   

    end
  end
end
