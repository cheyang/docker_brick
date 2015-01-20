require 'brick/cli'
require 'brick/generators'

class Brick::CLI
  
  class ProjectNew < Brick::CLI
    banner 'brick project new PROJECT(options)'
    
    def run
     
      if @cmd_args.size > 0
        project_name = @cmd_args[0]
      else
        puts "You must specify the project name to create"
        puts banner
        exit 1
      end
      
      
      working_dir = Dir.pwd
      
      values = Brick::Generators::NewProjectGenerator.start([working_dir, project_name])
      
      puts "value=#{value}"
    end
    
  end
  
end