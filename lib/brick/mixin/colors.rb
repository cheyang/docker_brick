require 'set'
require 'colorize'

module Brick::Mixin::Colors
  COLORS = [:blue, :red, :yellow, :light_red, :green, :light_green, :light_yellow, :black, :light_black,  :light_blue, :magenta, :light_magenta, :cyan, :light_cyan, :white, :light_white]
  
  @@current = -1
  
  def determine_color
    if $stdout.isatty
      @@current = (@@current+1)%COLORS.size
    end
  end
  
  def color_generator str
    
    if $stdout.isatty
      
      str=str.colorize(COLORS[@@current])
    end
    
    str
  end
end