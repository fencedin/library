class Patron
  attr_reader :name
  def initialize(name, password)
    @name = name
    @password = password
    DB.exec("INSERT INTO patrons (name, password) VALUES ('#{name}', '#{password}');")
  end

  def check_out(title)
    duedate = (Date.today + 14).to_s
    DB.exec("INSERT INTO check_outs (nameid, titleid, duedate) VALUES ('#{name}', '#{title}', '#{duedate}');")
  end

  def check_in(title)
    DB.exec("DELETE FROM check_outs WHERE titleid = '#{title}' AND nameid = '#{name}';")
  end

  def validate_pass(attempt)
    attempt == @password
  end

  def #check what books user has checked out and duesdates

  def self.all
    patrons = []
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |patron|
      name = patron['name']
      password = patron['password']
      patron = Patron.new(name, password)
      patrons << patron
    end
    patrons
  end

  def ==(another)
    self.name == another.name
  end
end
