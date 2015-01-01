require 'brick/cli'

class Brick::CLI::ModelCreate < CLI
      
      
      #it's from Mixlib::CLI
      banner 'brick model create MODEL(options)'
      
      def run
        CLI::logger.info "hello, #{banner}"
      end

  
end
