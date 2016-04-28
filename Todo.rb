require "byebug"
#Modules
module Menu
	def menu
		"Welcome to the TodoList.
		Enter 1 to Add
		Enter 2 to Show
		Enter 3 to Write
		Enter 4 to Read
		Enter 5 to Delete
		Enter 6 to Update
		Enter 7 to Toggle
		Enter Q to Quite "
	end

	def show
		puts menu
	end
end

module Promptable
	def prompt(message = 'what would yo like to do?', symbol = ':>')
		print message
		print symbol
		gets.chomp
	end
end

#Classes
class List
	attr_reader :all_tasks

	def initialize()
		@all_tasks = []
	end

	def add (task)
		unless task.to_s.chomp.empty?
			@all_tasks << task
		end
	end

	def show
		@all_tasks.each_with_index do |value, index|
			puts "#{index+1})" + value.to_machine
		end
	end

	def delete(task_number)
		@all_tasks.delete_at(task_number-1)
	end

	def update(task_number, task)
		@all_tasks[task_number - 1] = task
	end

	def write_to_file(filename)
		machine = @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, machine)
	end

	def read_from_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(':')
			status = status.include?('X')
			add(Task.new(description.join(':').strip, status))
		end
	end

	def toggle(task_number)
		@all_tasks[task_number-1].toggle_status
	end

end

class Task
	attr_reader :description
	attr_accessor :status

	def initialize (description, status = false)
		@description = description
		@status = status
	end

	def to_machine
		"#{represent_status} : #{description}"
	end

	def completed?
		status
	end

	def to_s
		description
	end

	def toggle_status
		@status = !completed?
	end

	private

	def represent_status
		"#{completed? ? '[X]' : '[ ]' }"
	end

end


#Program Runner
if __FILE__ == $PROGRAM_NAME
  my_list = List.new
  include Menu
  include Promptable
  puts "Hi, There, choose from one of these options."
  	until ['q'].include?(user_input = prompt(show).downcase)
  		case user_input
  		when '1'
  			my_list.add(Task.new(prompt("What is the task:")))
  		when '2'
  			my_list.show
  		when '3'
  			my_list.write_to_file(prompt("What is the name of the file you want to write to?"))
  		when '4'
  			begin
  			my_list.read_from_file(prompt("What is the name of the file you want to read from ?"))
			rescue Errno::ENOENT
	        puts 'File name not found, please verify your file name and path.'
	    	end
	    when '5'
	    	my_list.show
	    	my_list.delete(prompt("What task do you want to delete ?").to_i)
	    when '6'
	    	my_list.show
	    	my_list.update(prompt("which task would you like to edit").to_i, Task.new(prompt("what is the new task")) )
	    when '7'
	    	my_list.show
	    	my_list.toggle(prompt("Which task would you like to toggle").to_i)
  		else
  			puts "can't make  sense of input"
  		end
    end
    puts "Thanks for using this app :P"
end 


