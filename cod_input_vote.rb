module CoDInputVote
	### VOTE ###
	attr_reader :active_primary
	attr_reader :politicians
	attr_reader :winners
	attr_reader :victor

	DELAY = 0.5

	def prepare_voting
		@politicians = @people.select { |name, person|
			@people[name].is_a?(CoDPolitician) && @people[name].active?
		}

		@active_primary = get_current_primary
	end

	def get_current_primary
		candidates = {}

		@politicians.each do |name, politician|
			if !politician.active?
				next
			elsif candidates[politician.party]
				return politician.party
			else
				candidates[politician.party] = politician
			end
		end

		return nil
	end

	def set_vote_state
		prepare_voting

		if(@people.count < 3)
			set_menu_state
			@response = "You need more people for a successful election!"
			return
		end

		if(@politicians.length < 2)
			set_menu_state
			@response = "There aren't any politicians to vote on!" if(@politicians.length == 0)
			@response = "There's only one politician on the General Election ballot! No one should win the presidency unopposed!" if(@politicians.length == 1)
			return
		end

		if(active_primary)
			@state = :vote_primary_stumping
			@response = "The #{CoDGame::PARTY_NAMES[@active_primary]} Primary begins!"
			@state_instructions = "Press [Return] to begin selecting the candidates."
		else
			@state = :vote_general_stumping
			@response = "The campagin begins!"
			@state_instructions = "Press [Return] to begin the stumping."
		end
	end

	def set_vote_primary_stumping_state
		run_campaign

		puts "The primary day is here! Press [Return] to continue."	
		gets

		@state = :vote_primary_election
		@response = "It's the #{CoDGame::PARTY_NAMES[@active_primary]} Primary day!"
		@state_instructions = "Press [Return] to open the polls."
	end

	def set_vote_primary_election_state
		tally_votes

		if(@winners.length > 1)
			puts "The primary ends in a tie! The #{@winners.length} candidates will have to have a Runoff Election!"
		else
			puts "#{CoDGame::PARTY_NAMES[@active_primary]} candidate #{@victor} has secured the party's nomination! The party is sure they selected the candidate America needs."
		end

		reset_voting
		puts "Press [Return] to continue."
		gets

		set_vote_state
	end

	def set_vote_general_stumping_state
		run_campaign

		puts "Voting Day is here! Press [Return] to continue."	
		gets

		@state = :vote_general_election
		@response = "It's finally the General Election!!"
		@state_instructions = "Press [Return] to open the polls."
	end

	def set_vote_general_election_state
		tally_votes

		if(@winners.length > 1)
			puts "The election ends in a tie! The country tears itself apart trying to solve the Great Electoral Schism. America is dead."
		else
			puts "Politician #{@victor} has secured the presidency, and gives an amazing victory speach!\n\"I am #{@victor}. As overlord, all will kneel trembling before me and obey my brutal commands.\""
		end
		gets
		set_quit_state
	end

	def run_campaign
		@politicians.each do |pol_name, politician|
			if active_primary && politician.party != @active_primary
				# puts "Politician #{politician.name} is #{politician.party.to_s}, not #{@active_primary.to_s}\n\n"
				next
			end

			puts "#{pol_name}'s campagin begins!"
			@people.each do |per_name, person|
				if(politician == person)
					next
				end				
				puts "   #{pol_name} talks to #{per_name}: \"#{politician.give_speach}\""
				sleep DELAY

				response = person.recieve_stump(politician, @active_primary)
				puts "       #{per_name} responds: \"#{response}\"\n\n"
				sleep DELAY
			end
			puts ""
		end
	end


	def tally_votes
		puts "The ballots are open!"

		@tallied_votes = {}
		@people.each do |name, person|
			if(person.vote)
				puts "    #{name} voted for #{person.vote.name}."
				@tallied_votes[person.vote.name] = 0 if @tallied_votes[person.vote.name].nil?
				@tallied_votes[person.vote.name] += 1
			else
				puts "    #{name} abstained from voting!"
			end
			sleep DELAY
		end

		puts "", "The votes are in!"

		most_votes = 0
		@tallied_votes.each do |name, num_votes|
			puts "    #{name} has #{num_votes} votes!"
			most_votes =[most_votes, num_votes].max
			sleep DELAY
		end

		puts "" 

		@winners = @tallied_votes.select { |politician, num_votes|
			if num_votes == most_votes
				@victor = politician
				true
			else
				false
			end
		}
	end

	def reset_voting
		@people.each do |name, person|
			person.reset_vote
			if person.is_a? CoDPolitician
				if person.party == active_primary && @winners[name].nil?
					person.active = false
				end
			end
		end

		@victor = nil
		@winners = nil 
		@active_primary = nil
	end
end