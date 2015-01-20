require 'mixlib/cli'
require 'brick/application'
require 'brick/monkey_patches/cli'
module Brick
  class CLI
    
    extend Brick::Mixin::ConvertToClassName
    include Mixlib::CLI
    #include Application
    
    
    def self.logger
      @@logger ||= Logger.new(STDOUT)
      @@logger.level = Logger::INFO
      @@logger.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
       end
      @@logger
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
      #configure brick for common attributes
      #common_optparser.configure_brick
      common_optparser.opt_parser.banner="Usage: brick SUBCOMMAND (options)"
      CLI_Validator::validate
      #logger.info "begin to run the comand #{args}"
      load_commands
      subcommand_class = subcommand_class_from(args)
      subcommand_class.options = common_optparser.class.options.merge!(subcommand_class.options)
      subcommand_class.load_deps
      instance = subcommand_class.new(args)
      #instance.configure_brick
      instance.run_with_pretty_exceptions
    end
    
    def self.common_optparser
      @@common_optparser ||= Application.new
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
    
    def self.list_parameters
      puts common_optparser.opt_parser.to_s
      puts ""
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
      
      super() 
      command_name_words = self.class.snake_case_name.split('_')
      
      # Mixlib::CLI ignores the embedded name_args
      @cmd_args = ARGV.dup - command_name_words
      
      @cmd_args = parse_options @cmd_args
      @cmd_args.delete(command_name_words.join('-'))
      #@name_args.reject! { |name_arg| command_name_words.delete(name_arg) }
      
      
      Brick::Config.merge!(config)
      
      project_name = ::Brick::Config[:project]
      
      config_file = ::Brick::Config[:config_file]
      
      project_dir = File.dirname(config_file)
      
      ::Brick::Config[:project_dir] = project_dir
=begin
      if config[:help]
        logger.info opt_parser
        exit 1
      end
=end
      
    end
    
  
    def run_with_pretty_exceptions
      unless self.respond_to?(:run)
        logger.error "You need to add a #run method to your brick command before you can use it"
      end
      run
    rescue Exception => e
      raise 
      humanize_exception(e)
      exit 100
    end
    
     def humanize_exception(e)
      case e
      when SystemExit
        raise # make sure exit passes through.
      when Errno::ECONNREFUSED, Timeout::Error, Errno::ETIMEDOUT, SocketError
        logger.error "Network Error: #{e.message}"
        logger.info "Check your network settings"
      else
        logger.error "#{e.class.name}: #{e.message}"
      end
    end
    
   def show_usage
      puts( self.opt_parser.to_s)
    end
    
#     def configure_brick
#      begin
 #     parse_options
#     rescue => e
#        ::Brick::CLI::logger.error e.message
#        exit 1
#      end
#      Brick::Config.merge!(config)
#   end
  end
end