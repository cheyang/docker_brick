require "thor/group"

module Brick::Generators
  class NewServiceGenerator < Thor::Group
     argument :working_dir
     argument :project_name
      
    def a
      'a'    
    end
    
    def b
      'b'
    end
    
    def c
      'c'
    end
  end
end