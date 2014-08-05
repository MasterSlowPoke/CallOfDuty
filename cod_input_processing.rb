require "./cod_input_vote.rb"
require "./cod_input_create.rb"
require "./cod_input_update.rb"

module CoDInputProcessing
	include CoDInputVote
	include CoDInputCreate
	include CoDInputUpdate

	def process_command(input)
		case input
		when :menu
			set_menu_state
		when :create
			set_create_state
		when :create_person
			set_create_person_state(:voter)
		when :create_politician
			set_create_person_state(:politician)
		when :update
			set_update_state
		when :vote
			set_vote_state
		when :list
			set_list_state
		when :quit
			set_quit_state
		else
			:no_command_given
		end
	end

	def set_menu_state
		@state = :menu
		@response = "Welcome to Call of Duty!"
		@state_instructions = "What would you like to do? Create, List, Update, or Vote"
	end


	### LIST ###
	def set_list_state
		@state = :list

		list = ""
		if (@people.count > 0)
			list += "List of #{@people.count} " + (@people.count > 1 ? "people" : "person") + ":\n"

			@people.each do |name, person|
				if person.is_a? CoDPolitician
					list += "     Politician: #{name}, Party: #{person.party}\n"
				else
					list += "     Voter: #{name}, Political Leanings: #{person.politics}\n"
				end
			end
		else
			list += "No registered voters!"
		end

		@response = list
		@state_instructions = "Press [Return] to contine."
	end

	### QUIT ##
	def set_quit_state(input = nil)
		:exit_game
	end
end