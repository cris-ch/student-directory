require 'csv'

@students = [] # an empty array accessible to all methods

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to file"
  puts "4. Load the list from file"
  puts "9. Exit" # 9 because we'll be adding more items  
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      puts "Choose file to save:"
      filename = gets.chomp
      save_students(filename)
    when "4"
      puts "Choose file to save:"
      filename = gets.chomp
      load_students(filename)
    when "9"
      exit
    else
      puts "I don't know what you meant, try again"
  end
end

# write students data to @students array
def write_array
  @students << {name: @name, cohort: @cohort, hobbies: @hobbies, country: @country}
end

def input_students
  puts "Please enter the informatiom of the students."
  puts "To finish, don't enter any name and hit return"
  # get the first name
  puts "Enter name:"
  @name = STDIN.gets.chomp
  # while the name is not empty, repeat this code
  while !@name.empty? do
    # get the rest of the information for student
    puts "Enter cohort:"
    @cohort = STDIN.gets.gsub("\n","")
    puts "Enter hobbies:"
    @hobbies = STDIN.gets.chomp
    puts "Enter country of birth:"
    @country = STDIN.gets.chomp
    # call method to add student info to students array
    write_array
    puts "Now we have #{@students.count} students"
    # get another name from the user
    puts "Enter name:"
    @name = STDIN.gets.chomp
  end
  puts "You succesfully updated student(s) information."
end

def show_students
  print_header
  print_students_list
  print_footer
end

def print_header
  puts "The students of Villains Academy".center(100)
  puts "-------------".center(100)
end

def print_students_list
  @students.each_with_index() do |student, idx|
    puts "#{idx}. #{student[:name]}. Cohort: #{student[:cohort]}, Hobbies: #{student[:hobbies]}, Country: #{student[:country]} "
  end
end

def print_footer
  if @students.length == 1 
    puts "Overall, we have #{@students.count} great student".center(100)
  else
    puts "Overall, we have #{@students.count} great students".center(100)
  end
end

def ask_file
  puts "Choose file:"
  filename = gets.chomp
  filename
end

# save students data to file
def save_students(filename)
  File.open(filename, "w")  do |file| # open the file for writing
    @students.each do |student|  # iterate over the array of students
      student_data = [student[:name], student[:cohort], student[:hobbies], student[:country]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
  end
  puts "Succesfully saved students to #{filename}"
end

# load students data from file
def load_students(filename)
  File.open(filename, "r") do |file| # open file for reading
    counter = 0
    file.readlines.each do |line|   # iterate over the array of students
      @name, @cohort, @hobbies, @country = line.chomp.split(',')
      write_array     # call method to add student info to students array
      counter += 1
    end
    puts "Loaded #{counter} students from #{filename}"
  end
end

def try_load_students
  filename = ARGV.first # first argument from the command line
  filename = "students.csv" if filename.nil? # load "students.csv" by default if it isn't given
  if File.exists?(filename) # if it exists
    load_students(filename)
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit # quit the program
  end
end

try_load_students
interactive_menu