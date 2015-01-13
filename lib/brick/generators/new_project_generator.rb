require "thor/group"
require "fileutils"

module Brick::Generators
  class NewProjectGenerator < Thor::Group
    
     class_options :project_directory
     
     def self.source_root
        File.join(File.dirname(__FILE__), "new_project_generator", "templates")
     end
    
     def create_root
        self.destination_root = File.expand_path(option[:project_directory])
        empty_directory '.'
        FileUtils.cd(destination_root)
    end
    
    def fig_file
      copy_file "fig.yml"
    end
    
  end
end