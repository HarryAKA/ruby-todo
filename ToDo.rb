# encoding: utf-8
=begin
Ttile : ToDo.rb
Author : Harry Kran-Annexstein
=end

# Modules ::
module Menu
  def menu
    "\nPlease choose an option:
    1) Add new task
    2) Show tasks
    3) Save list to .txt file
    Q) Quit"
  end

  def show
    menu
  end
end

module Prompt
  def prompt(message = 'What would you like to do? ', symbol = ':> ')
    puts message
    print symbol
    gets.chomp
  end
end


# Classes ::
# List Class
class List
  attr_reader :tasks
  def initialize
    @created = Time.now
    @tasks = []
  end

  def add(task)
    tasks << task
    puts "New task added: '#{task.title}'"
  end

  def show
    tasks
  end

  def printList
    @tasks.each {|task| puts task.show}
  end

  def writeToFile(filename)
    filename << ".txt" if !(filename.include? ".txt")
    IO.write(filename, @tasks.map(&:show).join("\n"))
    puts "#{filename} was saved."
  end
end

# Task Class
class Task
  attr_reader :title
  def initialize(title)
    @title = title
    @completed = false
  end

  def to_s
    @title
  end

  def show
    @completed ? "+ #{title}" : "- #{title}"
  end
end

# Actions ::
if __FILE__ == $PROGRAM_NAME
  include Menu, Prompt
  puts "<< Ruby ToDo >>"
  list = List.new
  until ((user_input = prompt(show).downcase) == 'q')
    case user_input
      when '1'
        list.add(Task.new(prompt("\nWhat task would you like to add?")))
      when '2'
        puts (list.show == []) ? "\nThere are no tasks. Add one!" : "\nHere are your tasks:"
        list.printList
      when '3'
        list.writeToFile(prompt("\nWhat should the filename be?"))
      else
        puts 'Invalid input. Please enter 1, 2, or Q'
    end
  end
  puts "Quitting... Goodbye ✌️"
end
