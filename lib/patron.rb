class Patron
  attr_reader :name
  def initialize(name, password)
    @name = name
    @password = password
  end

  def save
    DB.exec("INSERT INTO patrons (name, password) VALUES ('#{name}', '#{@password}');")
  end

  def check_out(title)
    duedate = (Date.today + 14).to_s
    DB.exec("INSERT INTO check_outs (nameid, titleid, duedate) VALUES ('#{name}', '#{title}', '#{duedate}');")
    DB.exec("INSERT INTO history (nameid, titleid, date) VALUES ('#{name}', '#{title}', '#{Date.today}');")
  end

  def check_in(title)
    DB.exec("DELETE FROM check_outs WHERE titleid = '#{title}' AND nameid = '#{name}';")
  end

  def validate_pass(attempt)
    attempt == @password
  end

  def checked_out
    your_books = []
    results = DB.exec("SELECT * FROM check_outs WHERE nameid = '#{name}';")
    results.each do |book|
      your_books << [book['titleid'], book['duedate']]
    end
    your_books
  end

  def history
    your_books = []
    results = DB.exec("SELECT * FROM history WHERE nameid = '#{name}';")
    results.each do |book|
      your_books << [book['titleid'], book['date']]
    end
    your_books
  end

  def self.all
    patrons = []
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |patron|
      patron = Patron.new(patron['name'], patron['password'])
      patrons << patron
    end
    patrons
  end

  def ==(another)
    self.name == another.name
  end
end
