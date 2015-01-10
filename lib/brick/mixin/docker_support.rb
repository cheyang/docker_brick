require 'shellwords'
require 'pathname'

module Brick::Mixin
  module DockerSupport
    
    #from yml file to the configuration for creating container
    def create_config hash
      hash=transform_docker_hash hash
      
      create_config_for_port hash
      
      create_config_for_volumes hash
      
      hash
    end
    
    def start_config hash
      hash=transform_docker_hash hash
      
      start_config_for_port hash
      
      start_config_for_volumes hash
      
      hash 
    end
    
    #the format is captalized
    private
    def transform_docker_hash hash
      hash= Hash[hash.map do |k,v| 
        keys=k.split('_')
        
        keys.map!{|key|key.capitalize}
        
        [keys.join(''), v]
      end
      ]
      
      common_config_for_cmd hash
      
      common_config_for_env hash
      
      common_config_for_volumes hash
            
      hash
    end
    
    
    
    def common_config_for_cmd hash
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
    
    #common configuration for environment variable
    def common_config_for_env hash
      #Support environment variables
      env_variables = hash.delete('Environment')
      
      unless env_variables.nil?
        if env_variables.instance_of? Array
          hash['Env'] = env_variables
        elsif env_variables.instance_of? Hash
          var_arrays = []
          env_variables.each {|key, value| var_arrays<<"#{key}=#{value}" }
          hash['Env'] = var_arrays       
        end
      end
      hash
    end
    
    def common_config_for_volumes hash
      #volumes 
      unless hash["Volumes"].nil?
        volumes = hash["Volumes"]
        
        if volumes.instance_of? Array
          volumes.map!{|vo| 
            vo_parts = vo.split(":")
            
            container_volume = nil
            
            host_volume = vo_parts[0]
            
            option = "rw"
            
            if(Pathname.new(host_volume).relative?)
                 host_volume = File.absolute_path(File.join(::Brick::Config[:project_dir],host_volume))
            end
            
            
            if vo_parts.size==1    
              container_volume = host_volume
            elsif vo_parts.size>=2
              container_volume = vo_parts[1]
              
              if(Pathname.new(container_volume).relative?)
                 container_volume = File.absolute_path(File.join(::Brick::Config[:project_dir],container_volume))
             end
           end
           
           if vo_parts.size==3
             option = vo_parts[2]
           end
           
            
            [host_volume, container_volume, option].join(':')
          }
        else
          raise "the value of volumes should be an array"
        end
      end
      
      hash
    end
    
    def create_config_for_volumes hash
      #create config for volumes
      unless hash["Volumes"].nil?
        volumes = hash.delete('Volumes')
        
        volume_hash={}
        
        volumes.each{|vo| 
          vo_parts = vo.split(':')
          
          volume_hash[vo_parts[1]] = {}
          
        }
        
        hash['Volumes'] = volume_hash
        
        hash
      end
      hash
    end
    
    def start_config_for_volumes hash
      #start config for volumes
      #start config for volumes
      unless hash["Volumes"].nil?
        binds = hash.delete('Volumes')
        
        hash["Binds"] = binds
      end
      hash
    end
    
    #the port configuration for creating container 
    def create_config_for_port hash
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
        
        exposed_port_hash = Hash.new
        
        exposed_ports.each {|container_port| exposed_port_hash["#{container_port}/#{proto}"]={}}
        
        hash["ExposedPorts"]=exposed_port_hash
      end
      
      hash
    end
    
    #the port configuration for starting container  
    def start_config_for_port hash
      #the setting for start config  
      port_bindings = {}
      
      unless hash["Ports"].nil?
        ports = hash.delete "Ports"
        
        ports.each{|port| 
          
          port_definition = port.split(':')
          
           proto ="tcp"
          
          if port_definition.size > 1
            
            container_port = port_definition[-1]
            
            host_port = port_definition[-2]
      
            port_bindings["#{container_port}/#{proto}"] = [{"HostPort"=>host_port}]
            
            # port_bindings << {"#{container_port}/#{proto}"=>[{"HostPort"=>host_port}]}
          else
            port_bindings["#{port}/#{proto}"] = [{"HostPort"=>port}]
          end
        }
        
        hash["PortBindings"]=port_bindings
      end
      hash
    end
    
    def determine_dockerfile_path dockerfile_path, project_dir
      
      pathname= Pathname.new(dockerfile_path)
      
      if pathname.absolute?
        real_dockerfile_path = dockerfile_path
      else
        unless project_dir.nil?
          real_dockerfile_path = File.absolute_path(File.join(project_dir, dockerfile_path))
        end
      end
      
      real_dockerfile_path
    end
    
  end
end