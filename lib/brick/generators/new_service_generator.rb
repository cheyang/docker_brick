require "thor/group"

module Brick::Generators
  class NewServiceGenerator
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