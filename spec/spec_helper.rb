require 'rspec'
require 'pg'
require 'librarian'
require 'patron'


DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM authbook *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM check_outs *;")
    DB.exec("DELETE FROM history *;")
  end
end
