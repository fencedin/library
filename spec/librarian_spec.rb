require 'spec_helper'

describe Librarian do
  it 'initializes a librarian' do
    new_user = Librarian.new
    new_user.should be_an_instance_of Librarian
  end

  it '.add_author' do
    new_author = Librarian.add_author('Name of Author')
    Librarian.authors.should eq ['Name of Author']
  end

  it '.add_title' do
    new_title = Librarian.add_title('To the Sea')
    Librarian.titles.should eq ['To the Sea']
  end

  it '.give_credit' do
    new_title = Librarian.add_title('Castkes and Ikrons')
    new_author = Librarian.add_author('James Bury')
    Librarian.give_credit('Castkes and Ikrons', 'James Bury')
    Librarian.books.should eq [['Castkes and Ikrons', ['James Bury']]]
  end

  it '.give_credit' do
    new_title = Librarian.add_title('Ninjas of the Sand')
    new_title = Librarian.add_title('Ninjas of the Leaf')
    new_author = Librarian.add_author('Cake Man')
    new_author = Librarian.add_author('Bobby sams')
    new_author = Librarian.add_author('Kamikazi')
    new_author = Librarian.add_author('Blob Man')

    Librarian.give_credit('Ninjas of the Sand', 'Cake Man')
    Librarian.give_credit('Ninjas of the Sand', 'Bobby sams')
    Librarian.give_credit('Ninjas of the Leaf', 'Bobby sams')
    Librarian.give_credit('Ninjas of the Leaf', 'Kamikazi')
    Librarian.give_credit('Ninjas of the Leaf', 'Blob Man')

    Librarian.books.should eq [['Ninjas of the Sand', ['Cake Man', 'Bobby sams']],
                               ['Ninjas of the Leaf', ['Bobby sams', 'Kamikazi', 'Blob Man']]]
  end

  it 'updates the books title' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    Librarian.update_title('Ninjas', 'Ninjars')
    Librarian.books.should eq [['Ninjars', ['Bobby']]]
  end

  it 'deletes the book' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    Librarian.update_title('Ninjas', '')
    Librarian.books.should eq []
  end

  it 'updates the author' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    Librarian.update_author('Bobby', 'jill')
    Librarian.books.should eq [['Ninjas', ['jill']]]
  end

  it 'deletes author' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    Librarian.update_author('Bobby', '')
    Librarian.books.should eq []
  end

  it 'updates number of copys @ library' do
    new_title = Librarian.add_title('Ninjas')
    new_author = Librarian.add_author('Bobby')
    Librarian.give_credit('Ninjas', 'Bobby')
    Librarian.update_copys('Ninjas', 3)
    Librarian.list_copys('Ninjas').should eq 3
  end

end
