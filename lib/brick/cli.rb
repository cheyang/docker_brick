class Brick
  class CLI
    
    attr_accessor :logger
    
    def self.logger
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end
    
    
     # Run command line for the given +args+ (ARGV), adding +options+ to the list of
    # CLI options that the subcommand knows how to handle.
    # ===Arguments
    # args::: usually ARGV
    # options::: A Mixlib::CLI option parser hash. These +options+ are how
    # subcommands know about global knife CLI options
    def self.run(args, options={})
      load_commands
      subcommand_class = subcommand_class_from(args)
      subcommand_class.options = options.merge!(subcommand_class.options)
      subcommand_class.load_deps
      instance = subcommand_class.new(args)
      instance.configure
      instance.run_with_pretty_exceptions
    end
    
    def self.load_commands
      @commands_loaded ||= subcommand_loader.load_commands
    end
    
    
    def self.subcommand_loader
      @subcommand_loader ||= CLI::SubcommandLoader.new
    end
    
  end
end