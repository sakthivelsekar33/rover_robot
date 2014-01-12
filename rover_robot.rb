class Robot
	attr_accessor :x_cord, :y_cord, :direction

	def initialize(x_cord, y_cord, direction)
		@x_cord = x_cord
		@y_cord = y_cord
		@direction = direction
	end

	def left_turn
		possible_directions = {
			:N => :W,
			:S => :E,
			:E => :N,
			:W => :S
		}
		@direction = possible_directions[@direction.to_sym]
	end

	def right_turn
		possible_directions = {
			:N => :E,
			:S => :W,
			:E => :S,
			:W => :N
		}
		@direction = possible_directions[@direction.to_sym]
	end

	def move_forward
		co_ordinate_values = {
			:N => [x_cord, y_cord + 1],
			:E => [x_cord + 1, y_cord], 
			:S => [x_cord, y_cord - 1],
			:W => [x_cord - 1, y_cord]
		}
		@x_cord, @y_cord = *co_ordinate_values[@direction.to_sym]
	end

	def get_position
		"#{@x_cord} #{@y_cord} #{@direction}"
	end

	def moved_out_of_plateau(plateau)
		@x_cord > plateau.width || @y_cord > plateau.length
	end
end


class Plateau
	attr_accessor :width, :length
	def initialize(width, length)
		@width = width
		@length = length
	end 
end

puts "WELCOME TO NASA MARS ROVER - CONTROL PROGRAM"
puts "Enter the Plateau Co-ordinates(separated by one space). Eg: 5 5"

plateau_co_ordinates = gets.split(' ').map(&:to_i)
raise "Invalid Entry... More than 2 co ordinates entered" if plateau_co_ordinates.length > 2
plateau = Plateau.new(plateau_co_ordinates.first, plateau_co_ordinates[1])

puts "Please enter the number of robots to be deployed for the mission"
no_of_robots = gets.chomp.to_i

deployed_robots = []
(0...no_of_robots).each do |number|
	puts "Enter the Robot #{number + 1} Details \n Enter the Robot #{number + 1} Position & Facing Direction separated by one space. Eg., 1 2 N"
	robot_position = gets.chomp.split(' ')
	raise "Invlaid Entry...More than 3 Values entered" if robot_position.length > 3

	puts "Please enter Robot #{number +1} movement sequence Eg., LMLMLMLMM"
	move_sequence = gets.chomp
	deployed_robots << [Robot.new(robot_position[0].to_i, robot_position[1].to_i, robot_position[2].upcase.to_sym), move_sequence]
end

deployed_robots.each_with_index do |dr, index|
	robot = dr.first
	move_sequence = dr.last

	move_sequence.each_char do |command|
		case command.upcase.to_sym
		when :L
			robot.left_turn
		when :R
			robot.right_turn
		when :M
			robot.move_forward
		end
	end

	robot_position = robot.get_position
	robot_position = "Lost in space. Moved out of Plateau(Position : #{robot_position})" if robot.moved_out_of_plateau(plateau)

	puts "Robot #{index + 1} Position : #{robot_position}"
end

