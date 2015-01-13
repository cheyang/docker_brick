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
  :default => nil,
  :description => "Override the entrypoint of the image."
  
  option :deps, 
  :long  => "--[no-]deps",
  :default => true,
  :boolean => true,
  :description => "[not] start linked services."
  
  option :rm, 
  :long  => "--rm",
  :default => false,
  :boolean => true,
  :description => "Remove container after run. Ignored in detached mode."
  
  option :rebuild, 
  :long  => "--rebuild",
  :default => false,
  :boolean => true,
  :description => "rebuild the image template."
  
  
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
    
    disable_tty=::Brick::Config[:T]
    
    if disable_tty
      service.service_config_hash["tty"] = false
    else
      service.service_config_hash["tty"] = true
    end
    
    
    
    exec_option = {:detach => detach_mode, 
                   :tty => service.service_config_hash["tty"],
                   :stdin => STDIN,
                   :stdout => STDOUT,
                   :stderr => STDERR }
                   
    if detach_mode
      exec_option[:stdin]=false
      exec_option[:stdout]=false
      exec_option[:stderr]=false
    end
    
    puts "running service #{service_name}"
    
    if service.running?
      puts "exec #{cmd_array} on running service #{service_name}"
      
      service.exec
      
    else
      puts "start service #{service_name}"
      project.run_services(service_name,start_link_mode)
      
      unless service.running?
        raise "#{service_name} is failed to start"
      end
      
      unless detach_mode
        service.attach
      end
    end
    
    
    
  end
end