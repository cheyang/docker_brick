class Brick::CLI
  
    class New < CLI
      banner 'brick new MODEL(options)'
      
      def run
        CLI::logger.info "hello, #{banner}"
      end
      
    end
  
end