class Brick
  class CLI
    
    attr_accessor :logger
    
    def self.logger
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end
    
    
    def self.inherited(subclass)
      unless subclass.unnamed?
        subcommands[subclass.snake_case_name] = subclass
      end
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
    
    def self.subcommand_class_from(args)
      command_words = args.select {|arg| arg =~ /^(([[:alnum:]])[[:alnum:]\_\-]+)$/ }

      subcommand_class = nil

      while ( !subcommand_class ) && ( !command_words.empty? )
        snake_case_class_name = command_words.join("_")
        unless subcommand_class = subcommands[snake_case_class_name]
          command_words.pop
        end
      end
      # see if we got the command as e.g., brick model create
      subcommand_class ||= subcommands[args.first.gsub('-', '_')]
      subcommand_class || subcommand_not_found!(args)
    end
    
    def self.subcommands
      @@subcommands ||= {}
    end
    
    def self.subcommand_not_found!(args)
      logger.fatal("Cannot find sub command for: '#{args.join(' ')}'")

     
      list_commands
      

      exit 10
    end
    
     # is given, only subcommands in that category are shown
    def self.list_commands(preferred_category=nil)
      load_commands

      category_desc = preferred_category ? preferred_category + " " : ''
      logger.info "Available #{category_desc}subcommands: (for details, brick SUB-COMMAND --help)\n\n"

      if preferred_category && subcommands_by_category.key?(preferred_category)
        commands_to_show = {preferred_category => subcommands_by_category[preferred_category]}
      else
        commands_to_show = subcommands_by_category
      end

      commands_to_show.sort.each do |category, commands|
        next if category =~ /deprecated/i
        logger.info "** #{category.upcase} COMMANDS **"
        commands.sort.each do |command|
          logger.info subcommands[command].banner if subcommands[command]
        end
        logger.info 
      end
    end
    
    def self.load_commands
      @commands_loaded ||= subcommand_loader.load_commands
    end
    
    
    def self.subcommand_loader
      @subcommand_loader ||= CLI::SubcommandLoader.new
    end
    
  end
end