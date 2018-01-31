# encoding: utf-8
=begin
Ttile : ToDo.rb
Author : Harry Kran-Annexstein
=end

# Modules ::
module Menu
  def menu
    "Please choose an option:
      1) Add new task
      2) Show tasks
      Q) Quit"
  end

  def show
    menu
  end
end

module Prompts
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
  include Menu, Prompts
  puts "<< Ruby ToDo >>"
  my_list = List.new
  until ((user_input = prompt(show).downcase) == 'q')
    case user_input
      when '1'
        my_list.add(Task.new(prompt('What task would you like to add?')))
      when '2'
        puts (my_list.show == []) ? "There are no tasks. Add one!" : 'Here are your tasks:'
        my_list.printList
      else
        puts 'Invalid input. Please enter 1, 2, or Q'
    end
  end
  puts "Quitting... Goodbye ✌️"
end
