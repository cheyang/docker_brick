module Brick::Mixin
  module DockerSupport
   
    def create_config hsh
      hash = transform_docker_hash hsh
        
        
      exposed_ports = []
      
     
      #add expose ports  
      unless hash["ports"].nil?
        ports = hash.delete "ports"
        
        ports.each{|port| 
        
          container_port = (port.split(':'))[-1]
         
          exposed_ports << container_port
        }
        
      end
      
      #Add expose to exposed ports
      unless hash["expose"].nil?
         exposes = hash.delete "expose"
         
         exposes.each{|expose| 
            exposed_ports << expose
         }
      end
      
      
      
      if exposed_ports.size > 0
        
         proto = 'tcp'
        
        exposed_ports.map!{|container_port| {"#{container_port}/#{proto}"=>{}}}
        
        hash["ExposedPorts"]=exposed_ports
      end
      
    end
    
    def start_config hsh
      hash = transform_docker_hash hsh
    end
    
    #the format is captalize
    def transform_docker_hash hsh
       hash= Hash[hsh.map {|k,v| [k.capitalize, v]}]
       
   end
   
   private :transform_docker_hash
   
  end
end