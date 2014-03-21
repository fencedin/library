class Librarian
  def initialize
  end

  def self.add_author(name)
    DB.exec("INSERT INTO authors (name) VALUES ('#{name}');")
  end

  def self.add_title(title)
    DB.exec("INSERT INTO books (title) VALUES ('#{title}');")
  end

  def self.update_title(old_title, new_title)
    if new_title == ''
      DB.exec("DELETE FROM books WHERE title = '#{old_title}';")
      DB.exec("DELETE FROM authbook WHERE titleid = '#{old_title}';")
    else
      DB.exec("UPDATE books SET title = '#{new_title}' WHERE title = '#{old_title}';")
      DB.exec("UPDATE authbook SET titleid = '#{new_title}' WHERE titleid = '#{old_title}';")
    end
  end

  def self.history
    your_books = []
    results = DB.exec("SELECT * FROM history;")
    results.each do |book|
      your_books << [book['titleid'], book['nameid'], book['date']]
    end
    your_books
  end

  def self.update_author(old_author, new_author)
    if new_author == ''
      DB.exec("DELETE FROM authors WHERE name = '#{old_author}';")
      DB.exec("DELETE FROM authbook WHERE authorid = '#{old_author}';")
    else
      DB.exec("UPDATE authors SET name = '#{new_author}' WHERE name = '#{old_author}';")
      DB.exec("UPDATE authbook SET authorid = '#{new_author}' WHERE authorid = '#{old_author}';")
    end
  end

  def self.give_credit(title, author, copys=1)
    DB.exec("INSERT INTO authbook (titleid, authorid) VALUES ('#{title}', '#{author}');")
    DB.exec("INSERT INTO copys (book, copys) VALUES ('#{title}', '#{copys}');")
  end

  def self.update_copys(title, copys)
    DB.exec("UPDATE copys SET copys = #{copys} WHERE book = '#{title}';")
  end

  def self.list_copys(title)
    DB.exec("SELECT copys FROM copys WHERE book = '#{title}';").first['copys'].to_i
  end

  def self.authors
    results = DB.exec("SELECT * FROM authors;")
    authors = []
    results.each do |result|
      authors << result['name']
    end
    authors
  end

  def self.titles
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |result|
      books << result['title']
    end
    books
  end

  def self.books
    results = DB.exec("SELECT * FROM authbook;")
    books = []
    book = []
    results.each do |result|
      title = result['titleid']
      author = result['authorid']
      counter = 0
      books.each do |cat|
        if cat[0] == title
          counter = 1
          cat[1] << author
        end
      end
      if counter == 0
        book = [title, [author]]
        books << book
      end
    end
    books
  end
end
