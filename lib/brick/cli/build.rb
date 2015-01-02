require 'brick/cli'

class Brick::CLI::Build < Brick::CLI
  banner 'brick build'
  
  option :no_cache, 
    :long  => "--no-cache",
    :default => false,
    :boolean => true,
    :description => "Do not use cache when building the image."
    
    def run
      ::Brick::CLI::logger.info "hello, #{banner}, option[:no_cache]=#{::Brick::Config.configuration}"
    end
    
end