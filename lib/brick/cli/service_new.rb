require 'brick/cli'

class Brick::CLI::ServiceNew < Brick::CLI
  banner 'brick service new PROJECT(options)'
  
  def run
    puts banner
  end
end