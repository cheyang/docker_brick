require 'brick/cli'

class Brick::CLI::Build < Brick::CLI
  banner 'brick build'
  
  option :no_cache, 
    :short => "-N",
    :long  => "--no-cache",
    :default => false,
    :boolean => true,
    :description => "Do not use cache when building the image."
    
    def run
      #::Brick::CLI::logger.info "hello, #{banner}, option[:no_cache]=#{::Brick::Config.configuration}"
      project_name = ::Brick::Config[:project]
      
      config_file = ::Brick::Config[:config_file]
      
      project_dir = File.dirname(config_file)
      
      no_cache = ::Brick::Config[:no_cache]
      
      project = ::Brick::Models::Project.new(project_name,{:config_file => config_file})
      
      project.build_services(no_cache, project_dir)
      
    end
    
end