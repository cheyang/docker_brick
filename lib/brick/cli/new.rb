require 'brick/cli'
require 'brick/generators'

class Brick::CLI
  
  class New < Brick::CLI
    banner 'brick new PROJECT(options)'
    
    def run
     
      if @cmd_args.size > 0
        project_name = @cmd_args[0]
      else
        puts "You must specify the project name to create"
        puts banner
        exit 1
      end
      
      project_dir=File.join(::Brick::Config[:project_dir],project_name)
      
      Brick::Generators::NewProjectGenerator.start([project_dir])
    end
    
  end
  
end