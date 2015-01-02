require 'brick/cli'

class Brick::CLI
  
    class New < Brick::CLI
      banner 'brick new MODEL(options)'
      
      def run
        CLI::logger.info "hello, #{banner}"
      end
      
    end
  
end