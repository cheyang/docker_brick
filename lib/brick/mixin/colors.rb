require 'set'

module Brick::Mixin::Colors
  COLORS = [:black, :light_black, :red, :light_red, :green, :light_green, :yellow, :light_yellow, :blue, :light_blue, :magenta, :light_magenta, :cyan, :light_cyan, :white, :light_white]
  
  @@used_color = Set.new []
  
  @current_color
  
  def color_generator str
    
    if $stdout.isatty
      if @current_color.nil?
        usable_colors = COLORS -  @@used_color.to_a
        
        if usable_colors.size == 0
          usable_colors = COLORS.dup
        end
        
        @current_color = usable_colors[random(usable_colors.size)]
      end
      
      str=str.colorize(@current_color)
    end
    
    str
  end
end