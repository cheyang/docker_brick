require 'shellwords'

module Brick::Mixin
  module DockerSupport
   
    #from yml file to the configuration for creating container
    def create_config hsh
      hash = transform_docker_hash hsh
        
        
      exposed_ports = []
      
     
      #add expose ports  
      unless hash["Ports"].nil?
        ports = hash.delete "Ports"
        
        ports.each{|port| 
        
          container_port = (port.split(':'))[-1]
         
          exposed_ports << container_port
        }
        
      end
      
      #Add expose to exposed ports
      unless hash["Expose"].nil?
         exposes = hash.delete "Expose"
         
         exposes.each{|expose| 
            exposed_ports << expose
         }
      end
      
      
      
      if exposed_ports.size > 0
        
         proto = 'tcp'
        
        exposed_ports.map!{|container_port| {"#{container_port}/#{proto}"=>{}}}
        
        hash["ExposedPorts"]=exposed_ports
      end
      
      hash
    end
    
    def start_config hsh
      hash = transform_docker_hash hsh
        
      port_bindings = {}
      
      unless hash["Ports"].nil?
        ports = hash.delete "Ports"
        
        ports.each{|port| 
          
          port_definition = port.split(':')
          
          if port_definition.size > 1
            
            container_port = port_definition[-1]
            
            host_port = port_definition[-2]
            
            proto ="tcp"
            
            port_bindings["#{container_port}/#{proto}"] = [{"HostPort"=>host_port}]
            
           # port_bindings << {"#{container_port}/#{proto}"=>[{"HostPort"=>host_port}]}
            
          end
        }
        
        hash["PortBindings"]=port_bindings
      end
      
      hash 
    end
    
    #the format is captalize
    def transform_docker_hash hsh
      hash= Hash[hsh.map {|k,v| [k.capitalize, v]}]
      
      cmd= hash.delete('Command')
      
      #hash['Cmd']=cmd.split(' ') unless cmd.nil? 
      
      unless cmd.nil?
        if cmd.instance_of? Array
          hash['Cmd'] = cmd
        else
          hash['Cmd'] = Shellwords.split(cmd)       
        end
        
        
      end
      
      hash
    end
    
   private :transform_docker_hash
   
  end
end