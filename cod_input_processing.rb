require "./cod_input_vote.rb"
require "./cod_input_create.rb"

module CoDInputProcessing
	include CoDInputCreate
	include CoDInputVote

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
			process_vote
		when :list
			set_list_state
		when :quit
			set_quit_state
		else
			:command_failed
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

	### UPDATE ###
	def set_update_state(input=nil)
		if @people.count == 0 && @state != :update # if the update takes the count to zero, don't trigger this code
			set_menu_state
			@response = "There is no one to update."
			return
		end

		@state = :update_person
		@response = "Update a person."
		@state_instructions = "Type the name of a person to update. Esc to exit."
	end

	def set_update_person_state(input)
		# escape quites update
		if(input == "\e")
			set_menu_state
			@response = "Update quit."
		elsif (@people[input])
			@person = @people[input]

			@people.delete(@person.name)
			@person.name = nil
			(@person.is_a? CoDPolitician) ? @person.party = nil : @person.politics = nil

			@response = "Updating #{input}."
			@state_instructions = "Enter new name. Leave blank to randomize the person."
			@state = :update_person_name
		else
			@response = "No one is named '#{input}'."
		end
	end
		
	def set_update_person_name_state(input)
		process_naming(input)
		@state = :update_person_partisaniization unless @person.name.nil?
	end

	def set_update_person_partisaniization(input)
		process_partisanization(input)

		# the person will be set to nil and the state set to :menu if the partisanization is successful 
		if @person.nil?
			# replace the last instance of "created" with "updated"
			# TODO: this would probably be clearer with a regex, unfortunately there's no rsub
			@response.reverse!
			@response.sub!("detaerc","detadpu") 
			@response.reverse!
		end
	end

	### QUIT ##
	def set_quit_state(input = nil)
		:exit_game
	end
end