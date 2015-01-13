require "thor/group"
require "fileutils"

module Brick::Generators
  class NewProjectGenerator < Thor::Group
     include Thor::Actions
    
     argument :working_dir
     argument :project_name
     
     def self.source_root
        File.join(File.dirname(__FILE__), "new_project_generator", "templates")
     end
    
     def create_root
        self.destination_root = File.expand_path(working_dir)
        empty_directory(project_name)
        FileUtils.cd(File.join(working_dir,project_name))
    end
    
    def fig_file
      copy_file "#{project_name}/fig.yml"
    end
    
  end
end