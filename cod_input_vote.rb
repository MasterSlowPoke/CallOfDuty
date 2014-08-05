module CoDInputVote
	### VOTE ###
	def primary_necessary?
		candidates = {}

		@politicians.each do |name, politician|
			if politician.active && candidates[politician.party]
				return true
			else
				candidates[politician.party] = politician
			end
		end

		return false
	end

	def run_campaign(params = {})
		defaults = {delay: 0.75, primary: nil}
		params = defaults.merge(params)
		delay = params[:delay]
		primary = params[:primary]

		@politicians.each do |pol_name, politician|
			next if primary && politician.party != primary

			puts "#{pol_name}'s campagin begins!"
			@people.each do |per_name, person|
				if(politician == person)
					next
				end				
				puts "   #{pol_name} talks to #{per_name}: \"#{politician.give_speach}\""
				response = person.recieve_stump(politician, primary)
				sleep delay

				puts "       #{per_name} responds: \"#{response}\""
				sleep delay
			end
			puts ""
		end
	end

	def process_vote(delay = 0.75)
		unless (@politicians)
			@politicians = @people.select { |name, person|
				@people[name].is_a? CoDPolitician
			}
		end
		
		if(@politicians.length == 0)
			@response = "The last politician is in captivity. The country is at peace."
			@state_instructions = "No one is a winner!"

			# I want to display the final response, so run through the game loop one more time
			if(@state == :vote)
				set_quit_state
			else
				set_menu_state
				set_quit_state
			end
			return
		end

		if primary_necessary?
			build_primary_pools
			@state = :vote_primary
			@response = "The primaries begin!"
			@state_instructions = "Press [Return] to begin selecting the candidates."
			return
		end

		# prepare the ballot_boxes
		unless (@state == :vote)
			@state = :vote
			@response = "The campagin begins!"
			@state_instructions = "Press [Return] to begin the stumping."
			return
		end

		run_campaign

		puts "The campagin has ended! Press [Return] to start voting."
		gets 

		@state = :voting_over
		@response = "Election Day is here!"
		@state_instructions = "Press [Return] to open the polls."
	end

	def tally_votes(delay = 0.75)
		puts "The ballots are open!"

		tallied_votes = {}
		@people.each do |name, person|
			if(person.vote)
				puts "    #{name} voted for #{person.vote.name}."
				tallied_votes[person.vote.name] = 0 if tallied_votes[person.vote.name].nil?
				tallied_votes[person.vote.name] += 1
			else
				puts "    #{name} abstained from voting!"
			end
			sleep delay
		end

		puts ""
		puts "The votes are in!"
		most_votes = 0
		tallied_votes.each do |name, num_votes|
			puts "#{name} has #{num_votes} votes!"
			most_votes =[most_votes, num_votes].max
			sleep delay
		end

		@winners = tallied_votes.select { |politician, num_votes|
			if num_votes == most_votes
				@victor = politician
				true
			else
				false
			end
		}
	end

	def build_primary_pools
		@primary_pools = {}

		@politicians.each do |name, politician|
			@primary_pools[politician.party] = [] unless @primary_pools[politician.party]
			@primary_pools[politician.party] << politician
		end
	end

	def process_primaries
		puts "PROCESSING PRIMARIES"

		# get the first key, process the primary, delete the key from the pool, and restart the loop until there aren't any more keys
		@current_party = @primary_pools.keys[0]

		case @primary_pools[@current_party].length
		when 0
			finish_primary(@current_party)
			return
		when 1
			politician = @primary_pools[@current_party][0]
			puts "#{politician.name} is the only one running, and is the nominee by default!"
			@victor = politician.name
			gets
			finish_primary(@current_party)
			return
		end

		run_campaign({primary: @current_party})
		@state = :primary_voting_over

		@response = "It's the #{CoDPolitician::PARTY_NAMES[@current_party]} Primary day!"
		@state_instructions = "Press [Return] to open the polls."
	end

	def process_primary_vote
		tally_votes

		if(@winners.length > 1)
			puts "The primary ends in a tie! The #{@winners.length} candidates will be running in the General Election!"
		else
			puts "#{CoDPolitician::PARTY_NAMES[@current_party.party]} #{@victor} has secured the party's nomination! The party is sure they seleceted the candidate America needs."
		end
		puts "Press [Return] to continue."
		gets
		finish_primary
		@state = :vote
	end

	def finish_primary(primary)
		@victor = nil
		@people.each do |person|
			person.reset_vote
			if person.is_a CoDPolitician?
				if person.party == primary && person.name != @victor
					person.active = false
				end
			end
		end

		@primary_pools.delete(primary)
	end

	def process_voting_over(params = {})
		defaults = {delay: 0.75, primary: nil}
		params = defaults.merge(params)
		delay = params[:delay]
		primary = params[:primary]

		tally_votes

		puts ""

		if(@winners.length > 1)
			puts "The election ends in a tie! The country tears itself apart trying to solve the Great Electoral Schism. America is dead."
		else
			puts "Politician #{@victor} has secured the presidency, and gives an amazing victory speach!\n \"I am #{@victor}. As overlord, all will kneel trembling before me and obey my brutal commands.\""
		end
		gets
		process_quit
	end
end