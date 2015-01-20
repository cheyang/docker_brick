require "thor/group"

module Brick::Generators
  class NewServiceGenerator < Thor::Group
     argument :working_dir
     
   
      
    def create_a
      puts "a"
      'a'    
    end
    
    def create_b
      puts "b"
      'b'
    end
    
    def create_c
      puts "c"
      'c'
    end
  end
end