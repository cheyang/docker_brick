require 'brick/cli'

module Brick
  class CLI
    class ModelCreate < CLI
      
      
      #it's from Mixlib::CLI
      banner 'brick model create MODEL(options)'
      
      def run
        CLI::logger.info "hello, #{banner}"
      end
      
    end
  end
end
