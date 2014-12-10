class Brick
  class CLI
    class New < CLI
      banner 'brick new MODEL(options)'
      
      def run
        logger "hello, #{banner}"
      end
      
    end
  end
end