module CoDInputCreate
	### CREATE ###
	def set_create_state
		@response = "Create an individual:"
		@state_instructions = "What would you like to create? Politician or Person, or Return?"
		@state = :create_person_or_politician
	end

	## Similar process for both creates. If a person hasn't been started, create a new one and ask for name. Then, ask for party/politics, 
	##   add it to the master list, nilify @person, and then send the user back to the menu
	def set_create_person_state(input)
		if (input == :voter)
			@person = CoDPerson.new
			@response = "Create a regular voter:"
			@state_instructions = "The person's name? Leave blank to generate a random voter."
		else
			@person = CoDPolitician.new
			@response = "Create a politician:"
			@state_instructions = "The politician's name? Leave blank to generate a random politician."
		end
		@state = :create_person_name
	end

	def set_create_person_name_state(input)
		process_naming(input)

		if @person && @person.name  # name is set
			@state = :create_person_partisanization
		end
	end

	def set_create_person_partisanization(input)
		process_partisanization(input)
	end

	def process_naming(input)
		if input == "" || input.nil?
			result = nil

			if @person.is_a? CoDPolitician
				result = CoDPolitician.Random
			else
				result = CoDPerson.Random
			end

			# result is nil if you run out of names
			if(result)
				@person = result
				set_menu_state
				if @person.is_a? CoDPolitician
					@response = "Politician '#{@person.name}' with party '#{@person.party}' created!"
				else
					@response = "Person '#{@person.name}' with politics '#{@person.politics}' created!"
				end
				@people[@person.name] = @person
				@person = nil
				return
			else
				@response = "Out of random names!"
				return 
			end
		elsif @people[input]
			@response = "Name is already taken."
			return
		end

		@person.name = input
		@response = "Accepted \"#{@person.name}\"."

		if @person.is_a? CoDPolitician
			@state_instructions = "The politician's party? You can use the number as a shortcut. \n(1) Democrat or (2) Republican? Do you want to vote third party? Go ahead, throw your vote away!"
		else
			@state_instructions = "The person's politicial leanings? You can use the number as a shortcut. \n(1) Liberal, (2) Conservative, (3) Tea Party, (4) Socialist, or (5) Neutral?"
		end
	end

	def process_partisanization(input)
		responseString = ""

		if(@person.is_a? CoDPolitician)
			@person.party = input
			if @person.party.nil?
				@response = "Not a valid party."
				return
			end
			responseString = "Politician '#{@person.name}' of the party '#{@person.party}' created!"
		else
			@person.politics = input
			if @person.politics.nil?
				@response = "Not a valid political affiliation."
				return
			end
			responseString = "Person '#{@person.name}' with politics '#{@person.politics}' created!"
		end

		# return to the menu state, but with a succssful response string, and add the person to the master list, and delete the temp person
		set_menu_state
		@response = responseString

		@people[@person.name] = @person
		@person = nil
	end
end