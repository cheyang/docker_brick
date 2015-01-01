module Brick
  class CLI_Validator
    NO_COMMAND_GIVEN = "You need to pass a sub-command (e.g., brick SUB-COMMAND)\n"
    
    def self.validate
      if  no_command_given?
        print_help_and_exit(1, NO_COMMAND_GIVEN)
      end
      
    end
    
    def self.no_subcommand_given?
      ARGV[0] =~ /^-/
    end
    
    def self.no_command_given?
      ARGV.empty?
    end
    
    def self.print_help_and_exit(exitcode=1, fatal_message=nil)
      Brick::CLI::logger.error(fatal_message) if fatal_message
      Brick::CLI.list_parameters
      Brick::CLI.list_commands
      exit exitcode
    end
    
  end
end