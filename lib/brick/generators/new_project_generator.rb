require "thor/group"
require "fileutils"

module Brick::Generators
  class NewProjectGenerator < Thor::Group
     include Thor::Actions
    
     argument :working_dir
     argument :project_name
     
     attr_accessor :project_root
     
     def self.source_root
        File.join(File.dirname(__FILE__), "new_project_generator", "templates")
     end
    
     def create_root
        self.destination_root = File.expand_path(working_dir)
        empty_directory(project_name)
        self.project_root=File.join(working_dir,project_name)
        FileUtils.cd(project_root)
    end
    
    def fig_file
      copy_file("fig.yml","#{project_name}/fig.yml")
      puts "the project is created at #{project_root}"
    end
    
    def init_git
      puts "Initializing git repo in #{project_root}"
      FileUtils.cd(project_root)
      git :init
      git :add => "."
      git :commit => "-m 'Initial commit'"
      
    end
    
    private
    
     def git(commands={})
        if commands.is_a?(Symbol)
          `git #{commands}`
        else
          commands.each do |cmd, options|
           `git #{cmd} #{options}`
          end
        end
      end
    
  end
end