require 'brick/cli'

class Brick::CLI::Build
  banner 'brick build'
  
  option :no_cache, 
    :long  => "--no-cache",
    :default => false,
    :boolean => true,
    :description => "Do not use cache when building the image."
    
    def run
      CLI::logger.info "hello, #{banner}, option[:no_cache]=#{:no_cache}"
    end
    
end