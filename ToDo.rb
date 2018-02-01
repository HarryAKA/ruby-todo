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
    2) Delete a task
    3) Show tasks
    4) Save list to .txt file
    5) Import list from a file
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

  def delete(task_number)
    puts "Deleting task: '#{tasks[task_number].title}'"
    tasks.delete_at(task_number)
  end

  def show
    tasks
  end

  def printList
    @tasks.each_with_index {|task, index| print task.show; puts " [#{index}]"}
  end

  def writeToFile(filename)
    # append .txt to filename if user does not specify file extension
    filename << ".txt" if !(filename.include? ".")
    IO.write(filename, @tasks.map(&:show).join("\n"))
    puts "ToDo list saved to file: #{filename}"
  end

  def readFromFile(filename)
    IO.readlines(filename).each do |line|
      task = line.split(' ')
      # if task line begins with '☑︎' import task as completed
      task[0] == '☑︎' ? add(Task.new(task[1], true)) : add(Task.new(task[1]))
    end
  end
end

# Task Class
class Task
  attr_accessor :title
  attr_accessor :completed
  def initialize(title, completed = false)
    @title = title
    @completed = completed
  end

  def to_s
    @title
  end

  def show
    @completed ? "☑︎ #{title}" : "☐ #{title}"
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
        if list.show == []
          puts "\nToDo list is empty! There's nothing to delete."
        else
          puts "\nWhat task would you like to delete?"
          list.printList
          begin
            list.delete(prompt("Please provide the corresponding task number.").to_i)
          rescue Errno::ENOENT
            puts 'Error: Invalid task number.'
          end
        end
      when '3'
        puts (list.show == []) ? "\nThere are no tasks to show. Add one!" : "\nHere are your tasks:"
        list.printList
      when '4'
        if list.show == []
          puts "\nToDo list is empty! Please add at least one task before saving."
        else
          list.writeToFile(prompt("\nWhat should the filename be?"))
        end
      when '5'
        begin
          list.readFromFile(prompt("\nWhat file would you like to import?"))
        rescue Errno::ENOENT
          puts 'Error: File not found. Please verify the file name and path then try again.'
        end
      else
        puts 'Invalid input. Please enter 1, 2, or Q'
    end
  end
  puts "Quitting... Goodbye ✌️"
end
