require 'pg'
require 'rspec'
require './lib/librarian'
require './lib/patron'


DB = PG.connect({:dbname => 'library'})
@current_patron

def splash_menu
  clear
  puts "©LOL 1993-05-01"
  splash_screen
  puts "\e[0;33mWelcome to the Library of Learning\e[0m"
  puts '**************************************************'
  puts "Press 'Enter' to log in or enter 'n' for a new user"
  puts "Enter 'x' to exit"
  puts '**************************************************'
  prompt
  case gets.chomp.downcase
  when 'n'
    new_patron
  when 'su'
    super_user_menu
  when 'x'
    clear
    puts "\n\n\e[0;35mREAD OR YOU'RE A ▣\e[0m\n\n"
  else
    if patron_log_in
      patron_menu
    else
      error
      splash_menu
    end
  end
end

def super_user_menu
  clear
  puts "\e[90mWelcome Master Wayne...\e[0m"
  puts "\n**************************************************"
  puts "Enter 'a' to add/delete books."
  puts "Enter 'h' to view all history."
  puts "Enter 'v' to view overdue books."
  puts "Enter 'l' to logout."
  puts '**************************************************'
  prompt
  case gets.chomp.downcase[0]
  when 'a'
    edit_data
  when 'h'
    view_all_history
    puts "Press 'enter' to go back"
    prompt
    gets.chomp
    super_user_menu
  when 'v'
    view_overdue
    puts "Press 'enter' to go back"
    prompt
    gets.chomp
    super_user_menu
  when 'l'
    splash_menu
  else
    error
    super_user_menu
  end
end

def edit_data
  clear
  puts "\n**************************************************"
  puts "Enter 'v' to view all books"
  puts "Enter 'add, book_name, author_name(s)' to add book."
  puts "Enter 'aa, author_name, book_name' to add author to a book."
  puts "Enter 'ra, author_name, book_name' to add remove author."
  puts "Enter 'rm, book_name' to remove book."
  puts "Enter 'b' to go back."
  puts '**************************************************'
  prompt
  input = gets.chomp.split(", ")
  case input[0]
  when 'v'
    Librarian.books.each do |book|
      authors = ''
      copys = Librarian.list_copys(book[0])
      authors = book[1].join(", ")
      puts "#{book[0]} | By: #{authors} | Total Copies: #{copys}"
    end
    puts "\n\nPress 'enter' to go back"
    prompt
    gets.chomp
    edit_data
  when 'add'
    begin
      input.shift
      title = input.shift
      Librarian.add_title(title)
      author1 = input.shift
      Librarian.add_author(author1)
      Librarian.give_credit(title, author1)
      input.each do |author|
        Librarian.add_author(author)
        Librarian.give_credit(title, author)
      end
      puts "\nAdd how many copies to collection?"
      prompt
      Librarian.update_copys(title, gets.chomp.to_i)
    rescue
      error
    end
    edit_data
  when 'aa'
    input.shift
    author = input.shift
    Librarian.add_author(author)
    Librarian.give_credit(input.shift, author)
    edit_data
  when 'ra'
    input.shift
    Librarian.update_author(input[0], '')
    edit_data
  when 'rm'
    input.shift
    Librarian.update_title(input[0], '')
    edit_data
  when 'b'
    super_user_menu
  else
    error
    edit_data
  end
end





def view_all_history
  Librarian.history.each do |book|
    puts book[0] + ",  " + book[1] + ", checked out on: (" + book[2] + ")"
  end
end

def view_overdue
  Librarian.history.each do |book|
    if (Date.parse(book[2]) + 14) > Date.today
      puts "\e[4;31m" + book[0] + ",  " + book[1] + ", checked out on: (" + book[2] + ")\e[0m"
    end
  end
end

def new_patron
  clear
  username = rand(100000..999999).to_s
  puts "\n\nyour username is #{username}\n\n"
  puts "enter a password"
  prompt
  password = gets.chomp
  patron = Patron.new(username, password)
  patron.save
  splash_menu
end

def patron_log_in
  puts "enter username"
  prompt
  username = gets.chomp
  puts "enter password"
  prompt
  password = gets.chomp
  Patron.all.each do |user|
    if username == user.name && user.validate_pass(password)
      @current_patron = user
      return true
    end
  end
  return false
end

def patron_menu
  clear
  checked_out_books
  puts "\n**************************************************"
  puts "Enter 'b' to browse books."
  puts "Enter 'r' to return a book."
  puts "Enter 'h' to view history."
  puts "Enter 'l' to logout."
  puts '**************************************************'
  prompt
  case gets.chomp.downcase[0]
  when 'b'
    Librarian.books.each do |book|
      authors = ''
      copys = Librarian.list_copys(book[0])
      book[1].each do |author|
        authors += author
      end
      puts "#{book[0]} | By: #{authors} | Total Copies: #{copys}"
    end
    puts "\n\nenter the name of the book you would like to check out..."
    prompt
    input = gets.chomp
      #begin
        @current_patron.check_out(input)
      #rescue
        #error
      #end
    patron_menu
  when 'r'
    prompt
    input = gets.chomp
    @current_patron.check_in(input)
  when 'h'
    @current_patron.history.each do |book|
      puts "#{book[0]}, Checked out on: #{book[1]}"
    end
    patron_menu
  when 'l'
    @current_patron = 0
    splash_menu
  else
    error
    patron_menu
  end
end

def checked_out_books
  @current_patron.checked_out.each do |book|
    puts "#{book[0]}, Due On: #{book[1]}"
  end
end

def error
  puts "\e[5;31m☭ ☭ эяяоя ☭ ☭ \e[0m"
  sleep 3
end

def clear
  system 'clear'
end

def prompt
  print "\e[5;32m▶ \e[0m"
end

def splash_screen
  puts "\e[0;32m      _________________________
     /////////////|\\\\\\\\\\\\\\\\\\\\\\\\\\
    '.-------------------------.'
     |                         |
     | [] [] [] [] [] [] [] [] |
     |          L.O.L          |
   _.-.        _ _ _ _         |
   >   )] [] []||_||||[] [] [] |,'`\\
   `.,'________||___||_________|\\  /
    ||  /  _<> _     _    (_)<>\\ ||
    '' /<>(_),:/     \\:. <>'  <>\\||
    __::::::::/ _ _ _ \\:::::::::::_
   __________           ___________
      ,.::. /           \\  _________
      `''''/             \\ \\:'-'-'-'-\e[0m"
end


splash_menu













