require "./cod_input_vote.rb"
require "./cod_input_create.rb"

module CoDInputProcessing
	include CoDInputCreate
	include CoDInputVote

	def process_command(input)
		result = case input
		when :menu
			process_menu
		when :create
			process_create
		when :create_person
			process_create_person(:voter)
		when :create_politician
			process_create_person(:politician)
		when :update
			process_update
		when :vote
			process_vote
		when :list
			process_list
		when :quit
			process_quit
		else
			:command_failed
		end	

		return result
	end

	def process_menu
		@state = :menu
		@response = "Welcome to Call of Duty!"
		@state_instructions = "What would you like to do? Create, List, Update, or Vote"
	end


	### LIST ###
	def process_list
		#if the list is on the screen already, send a menu command to return
		if @state == :list
			process_menu
			return
		end
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
	def process_update(input=nil)
		if @people.count == 0 && @state != :update # if the update takes the count to zero, don't trigger this code
			@response = "There is no one to update."
			return
		elsif @state != :update
			@state = :update
			@response = "Update a person."
			@state_instructions = "Type the name of a person to update. Esc to exit."
			return

		# @Person will be nil until the user enters in a valid name
		elsif @person.nil? 
			# escape quites update
			if(input == "\e")
				process_menu
				@response = "Update quit."
			elsif (@people[input])
				@person = @people[input]

				@response = "Updating #{@person.name}."
				@state_instructions = "Enter new name:"


				@people.delete(@person.name)
				@person.name = nil
				(@person.is_a? CoDPolitician) ? @person.party = nil : @person.politics = nil
			else
				@response = "No one is named '#{input}'."
			end
			return
		elsif @person.name.nil?
			process_naming(input)
		else
			process_partistanization(input)

			# replace the last instance of "created" with "updated"
			# TODO: this would probably be clearer with a regex, unfortunately there's no rsub
			@response.reverse!
			@response.sub!("detaerc","detadpu") 
			@response.reverse!
		end
	end

	### QUIT ##
	def process_quit(input = nil)
		@quit_game = true
	end
end