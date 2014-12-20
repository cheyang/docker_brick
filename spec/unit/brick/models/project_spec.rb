require 'spec_helper'


describe Brick::Models::Project do
  
   before :all do
     @config_file = File.join(File.dirname(__FILE__),'fig_completed.yml' )
   end
   
   subject { described_class.new({:config_file=>@config_file}) }
   
   describe '#initialize' do
     it "parse services correctly" do
       subject.services.each{|x| puts x.name; puts x.images}
     end
   end
end