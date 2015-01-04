require 'brick/cli'

class Brick::CLI::Up < Brick::CLI
  banner 'brick up'
  
  option :detach_mode, 
    :long  => "--detach",
    :short => "-d",
    :default => false,
    :boolean => true,
    :description => "Detached mode: run the service in the background"
    
  option :recreate, 
    :long  => "--[no-]recreate",
    :default => false,
    :boolean => true,
    :description => "If containers already exist but still [not] recreate them."
    
  option :deps, 
    :long  => "--[no-]deps",
    :default => false,
    :boolean => true,
    :description => "[not] start linked services."
    
    #By default, it's running in background
    def run
      #::Brick::CLI::logger.info "hello, #{banner}, option[:no_cache]=#{::Brick::Config.configuration}"
      project_name = ::Brick::Config[:project]
      
      config_file = ::Brick::Config[:config_file]
      
      project_dir = File.dirname(config_file)
           
      detach_mode = ::Brick::Config[:detach_mode]
      
      recreate_mode = ::Brick::Config[:recreate]
      
      start_link_mode = ::Brick::Config[:deps]
      
      project = ::Brick::Models::Project.new(project_name,{:config_file => config_file})
      
      project.up(detach_mode, start_link_mode, recreate_mode)
      
    end
    
end