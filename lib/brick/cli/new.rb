class Brick
  class CLI
    class New < CLI
      banner 'brick new MODEL(options)'
      
      def run
        logger.info "hello, #{banner}"
      end
      
    end
  end
end