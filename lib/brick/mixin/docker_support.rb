module Brick::Mixin
  module DockerSupport
    
    #the format is captalize
    def transform_docker_hash hsh
      Hash[hsh.map {|k,v| [k.capitalize, v]}]
    end
  end
end