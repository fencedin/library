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

  it 'returns books checked out with due date by patron' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    patron = Patron.new("bob", "p@$$w0rd")
    patron.check_out('Ninjas')
    patron.checked_out[0][0].should eq 'Ninjas'
  end

  it 'returns nothing once all books are checked in' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    patron = Patron.new("bob", "p@$$w0rd")
    patron.check_out('Ninjas')
    patron.check_in('Ninjas')
    patron.checked_out.should eq []
  end

  it 'shows history of patron' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    patron = Patron.new("bob", "p@$$w0rd")
    patron.check_out('Ninjas')
    patron.history[0][0].should eq 'Ninjas'
  end
end
