require "./cod_graphics.rb"
require "./cod_input_processing.rb"
require "./cod_person.rb"

class CoDGame
	attr_reader :person
	attr_reader :people
	attr_reader :politicians
	attr_reader :response
	attr_reader :victor

	attr_accessor :state

	include CoDInputProcessing

	#set the game to the menu state
	def initialize
		@people = {}
		process_menu 
	end

	def display_splash
		CoDGraphics.display_splash
		gets

    	CoDGraphics.clear_screen
	end

	def run
		display_splash
		loop do
			CoDGraphics.display_title
			puts @response
			puts @state_instructions

			input = get_command
			command_result = nil
			break if @quit_game

			process_command(input)

			CoDGraphics.clear_screen
		end

		display_outro
	end

	def make_people
		newPeople = [
			CoDPerson.new({name: "guy1", politics: :socialist}),
			CoDPerson.new({name: "guy2", politics: :tea_party}),
			CoDPerson.new({name: "guy3", politics: :neutral}),
			CoDPerson.new({name: "guy4", politics: :conservative}),
			CoDPerson.new({name: "guy5", politics: :liberal}),
			CoDPolitician.new({name: "pol1", party: :republican}),
			CoDPolitician.new({name: "pol2", party: :democrat}),
		]
		newPeople.each do |person|
			@people[person.name] = person
		end
	end

	# Take input from the user, and return a symbol representing the command. input argument for testing
	def get_command(input = nil)
		input = gets.chomp unless input

		case @state
		when :menu
			get_menu_command(input)
		when :create
			get_create_command(input)
		when :list
			process_list
		when :create_person
			process_create_person(input)
		when :update
			process_update(input)
		when :vote
			process_vote
		when :voting_over
			process_voting_over
		else
			raise Exception.new("No commands valid for state:" + @state.to_s)
		end
	end

	def get_menu_command(input = nil)
		case input.downcase
		when "create", "c"
			return :create
		when "list", "l"
			return :list
		when "quit", "q"
			return :quit
		when "vote", "v"
			return :vote
		when "update", "u"
			return :update
		when "quit"
			return :quit
		when "seed"
			make_people
			return :menu
		else
			@response = "Not a valid command."
			return :unknown
		end
	end

	def get_create_command(input = nil)
		case input.downcase
		when "person", "per"
			return :create_person
		when "politician", "pol"
			return :create_politician
		when "back", "return", ""
			return :menu
		else
			@response = "I'm not sure what you said?"
		end
			
	end
		
	def display_outro
		CoDGraphics.clear_screen
		CoDGraphics.display_title
		puts "Thanks for playing, citizen!"
		puts ""
		CoDGraphics.display_outro
	end
end

