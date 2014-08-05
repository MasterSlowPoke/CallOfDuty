module CoDInputUpdate
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
		@state = :update_person_partisanization unless @person.name.nil?
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
end