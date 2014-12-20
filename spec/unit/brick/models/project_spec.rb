require 'spec_helper'


describe Brick::Models::Project do
   subject { described_class.new({:config_file=>'fig_complete.yml'}) }
   
   describe '#initialize' do
     it "parse services correctly" do
       subject.services.each{|x| puts x}
     end
   end
end