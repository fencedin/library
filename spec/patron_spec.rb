require 'spec_helper'


describe 'Patron' do

  it 'initilizes with a name and password' do
    patron = Patron.new("bob", "p@$$w0rd")
    patron.should be_an_instance_of Patron
  end

  it 'returns its name' do
    patron = Patron.new("bob", "p@$$w0rd")
    patron.name.should eq 'bob'
  end

  it 'starts as an empty array' do
    patron = Patron.new("bob", "p@$$w0rd")
    Patron.all.should eq [patron]
  end
end
