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

	def run_campaign(delay = 0.75, primary = false)
		@politicians.each do |pol_name, politican|
			puts "#{pol_name}'s campagin begins!"
			@people.each do |per_name, person|
				if(politican == person)
					next
				end				
				puts "   #{pol_name} talks to #{per_name}: \"#{politican.give_speach}\""
				response = person.recieve_stump(politican)
				sleep delay

				puts "       #{per_name} responds: #{response}"
				sleep delay
			end
			puts ""
		end
	end

	def process_vote(delay = 0.75)
		@politicians = @people.select { |name, person|
			@people[name].is_a? CoDPolitician
		}

		if primary_necessary?
			puts "PRIMARY NECESSARY!"
		end

		
		if(@politicians.length == 0)
			@response = "The last politician is in captivity. The country is at peace."
			@state_instructions = "No one is a winner!"

			# I want to display the final response, so run through the game loop one more time
			if(@state == :vote)
				process_quit
			else
				@state = :vote 
			end
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

	def process_voting_over(delay = 0.75)
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

		winners = tallied_votes.select { |politican, num_votes|
			if num_votes == most_votes
				@victor = politican
				true
			else
				false
			end
		}

		puts ""

		if(winners.length > 1)
			puts "The election ends in a tie! The country tears itself apart trying to solve the Great Electoral Schism. America is dead."
		else
			puts "Politician #{@victor} has secured the presidency, and gives an amazing victory speach!\n \"I am #{@victor}. As overlord, all will kneel trembling before me and obey my brutal commands.\""
		end
		gets
		process_quit
	end
end