module Mixlib
  module CLI
    def parse_options(argv=ARGV)
      argv = argv.dup
      
      #redefine the method from parse! to order!
      opt_parser.order!(argv)
      

      # Deal with any required values
      options.each do |opt_key, opt_value|
        if opt_value[:required] && !config.has_key?(opt_key)
          reqarg = opt_value[:short] || opt_value[:long]
          puts "You must supply #{reqarg}!"
          puts @opt_parser
          exit 2
        end
      end

      @cli_arguments = argv
      argv
    end
  end
end
