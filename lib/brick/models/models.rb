module Brick
  module Models 
    class ServicesNotFoundException < RuntimeError
      
    end
  end
end

#BKm = Brick::Models

require 'brick/models/service'

require 'brick/models/project'