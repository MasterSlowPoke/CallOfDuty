require "./cod_graphics.rb"
require "./cod_input_processing.rb"
require "./cod_person.rb"
require "./cod_politician.rb"

class CoDGame
	attr_reader :person
	attr_reader :people
	attr_reader :politicians
	attr_reader :response
	attr_reader :victor

	attr_accessor :state

	include CoDInputProcessing

	PARTY_NAMES = {democrat: "Democratic", republican: "Republican"}
	DELAY = 0.75 

	#set the game to the menu state
	def initialize
		@people = {}
		@debug = false
		set_menu_state 
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
			display_state

			input = get_input_based_on_state
			break if input == :exit_game
			process_command(input)

			CoDGraphics.clear_screen
		end

		display_outro
	end

	def display_state
		puts @response
		puts @state_instructions 
		puts "STATE: " + @state.to_s if @debug
	end

	def make_people
		newPeople = [
			CoDPerson.Random,
			CoDPerson.Random,
			CoDPolitician.Random,
			CoDPolitician.Random,
			CoDPolitician.Random,
			CoDPolitician.Random,
			CoDPolitician.Random,
			CoDPolitician.Random,
		]
		newPeople.each do |person|
			@people[person.name] = person
		end
	end

	def get_input_based_on_state(input = nil)
		input = gets.chomp unless input

		case @state
		when :menu
			get_menu_command(input)
		when :create_person_or_politician
			get_create_command(input)
		when :list
			set_menu_state
		when :create_person
			set_create_person_state(:voter)
		when :create_politician
			set_create_person_state(:politician)
		when :create_person_name
			set_create_person_name_state(input)
		when :create_person_partisanization
			set_create_person_partisanization(input)
		when :update_person
			set_update_person_state(input)
		when :update_person_name
			set_update_person_name_state(input)
		when :update_person_partisanization
			set_update_person_partisanization(input)
		when :vote
			set_vote_state
		when :vote_primary_stumping
			set_vote_primary_stumping_state
		when :vote_primary_election
			set_vote_primary_election_state
		when :vote_general_stumping
			set_vote_general_stumping_state
		when :vote_general_election
			set_vote_general_election_state
		else
			raise StandardError.new("No commands valid for state:" + @state.to_s)
		end
	end

	# Take input from the user, and return a symbol representing the command. input argument for testing
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
		when "d"
			@debug = !@debug
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

