require 'brick/cli'
require 'brick/cli__validator'

class Brick::CLI
  
    class Help < Brick::CLI
      banner 'brick help'
      
      def run
        ::Brick::CLI.common_optparser.opt_parser.banner=self.banner
        ::Brick::CLI_Validator::print_help_and_exit(0)
      end
      
    end
  
end