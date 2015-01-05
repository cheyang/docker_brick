require 'brick/cli'

class Brick::CLI::Run < Brick::CLI
  banner 'brick run'
  
 option :detach_mode, 
    :long  => "--detach",
    :short => "-d",
    :default => false,
    :boolean => true,
    :description => "Detached mode: run the service in the background"
    
  option :entrypoint, 
    :long  => "--entrypoint CMD",
    :default => false,
    :description => "Override the entrypoint of the image."
    
  option :deps, 
    :long  => "--[no-]deps",
    :default => false,
    :boolean => true,
    :description => "[not] start linked services."
    
   option :rm, 
    :long  => "--rm",
    :default => false,
    :boolean => true,
    :description => "Remove container after run. Ignored in detached mode."
    
    
    option :T, 
    :long  => "--T",
    :default => false,
    :boolean => true,
    :description => "Disable pseudo-tty allocation. By default `brick run` allocates a TTY."
    
    #By default, it's running in background
    def run
      #::Brick::CLI::logger.info "hello, #{banner}, option[:no_cache]=#{::Brick::Config.configuration}"
      project_name = ::Brick::Config[:project]
      
      config_file = ::Brick::Config[:config_file]
      
      project_dir = File.dirname(config_file)
           
      detach_mode = ::Brick::Config[:detach_mode]
      
      start_link_mode = ::Brick::Config[:deps]
      
      project = ::Brick::Models::Project.new(project_name,{:config_file => config_file})
      
      entrypoint = ::Brick::Config[:entrypoint]
      
      if @cmd_args.size > 0
        service_name = @cmd_args[0]
      else
        puts "You must specify the servcie name to run"
        exit 1
      end
      
      cmd_array = @cmd_args - [@cmd_args[0]]
      
      
      service = project.get_service service_name
      
      if cmd_array.size >0
        service.service_config_hash["command"] = cmd_array
      end
      
      unless entrypoint.nil?
        service.service_config_hash["entrypoint"] = entrypoint.split(" ")
      end
      
    
      project.run_service(service_name,start_link_mode)
      
      unless detach_mode
        service.attach
      end
      
      
    end
end