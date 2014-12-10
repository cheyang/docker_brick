require 'mixlib/cli'

class Brick
  class CLI
    
    extend Brick::Mixin::ConvertToClassName
    include Mixlib::CLI
    
    attr_accessor :logger
    
    def self.logger
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::INFO
      @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
       end
      @logger
    end
    
    
    def self.inherited(subclass)
      unless subclass.unnamed?
        subcommands[subclass.snake_case_name] = subclass
      end
    end
    
    def self.unnamed?
      name.nil? || name.empty?
    end
    
     # Run command line for the given +args+ (ARGV), adding +options+ to the list of
    # CLI options that the subcommand knows how to handle.
    # ===Arguments
    # args::: usually ARGV
    # options::: A Mixlib::CLI option parser hash. These +options+ are how
    # subcommands know about global knife CLI options
    def self.run(args, options={})
      CLI_Validator::validate
      logger.info "begin to run the comand #{args}"
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
    
    def self.subcommands_by_category
      unless @subcommands_by_category
        @subcommands_by_category = Hash.new { |hash, key| hash[key] = [] }
        subcommands.each do |snake_cased, klass|
          @subcommands_by_category[klass.subcommand_category] << snake_cased
        end
      end
      @subcommands_by_category
    end
    
    def self.snake_case_name
      convert_to_snake_case(name.split('::').last) unless unnamed?
    end
    
    def self.load_commands
      @commands_loaded ||= subcommand_loader.load_commands
    end
    
    
    def self.subcommand_loader
      @subcommand_loader ||= CLI::SubcommandLoader.new
    end
    
    #Add catergory 
     def self.category(new_category)
      @category = new_category
    end

    def self.subcommand_category
      @category || snake_case_name.split('_').first unless unnamed?
    end
    
    def self.dependency_loaders
      @dependency_loaders ||= []
    end
    
    def self.deps(&block)
      dependency_loaders << block
    end
    
     def self.load_deps
      dependency_loaders.each do |dep_loader|
        dep_loader.call
      end
    end
    
    def initialize(argv=[])
      command_name_words = self.class.snake_case_name.split('_')
      
      # Mixlib::CLI ignores the embedded name_args
      @name_args = parse_options(argv)
      @name_args.delete(command_name_words.join('-'))
      @name_args.reject! { |name_arg| command_name_words.delete(name_arg) }

=begin
      if config[:help]
        logger.info opt_parser
        exit 1
      end
=end
      
    end
    
  end
end