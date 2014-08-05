module CoDInputVote
	### VOTE ###
	attr_reader :active_primary
	attr_reader :politicians
	attr_reader :winners
	attr_reader :victor

	DELAY = 0.083

	def prepare_voting
		@politicians = @people.select { |name, person|
			@people[name].is_a?(CoDPolitician) && @people[name].active?
		}

		@active_primary = get_primary
	end

	def get_primary
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

		if(@politicians.length == 0)
			set_menu_state
			@response = "There aren't any politicians to vote on!"
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

			# @politicians.each do |name, person|
			# 	puts "Politician #{name}, #{person.party.to_s}, is active? #{person.active.to_s}"
			# end
			# gets
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
			puts "The primary ends in a tie! The #{@winners.length} candidates will be running in a Runoff Election!"
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
			puts "Politician #{@victor} has secured the presidency, and gives an amazing victory speach!\n \"I am #{@victor}. As overlord, all will kneel trembling before me and obey my brutal commands.\""
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
				puts "       #{per_name} responds: \"#{response}\""
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

		puts ""
		puts "The votes are in!"
		most_votes = 0
		@tallied_votes.each do |name, num_votes|
			puts "#{name} has #{num_votes} votes!"
			most_votes =[most_votes, num_votes].max
			sleep DELAY
		end

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

	# def process_vote(delay = 0.75)
	# 	unless (@politicians)

	# 	end

	# 	if primary_necessary?
	# 		build_primary_pools

	# 		return
	# 	end

	# 	# prepare the ballot_boxes
	# 	unless (@state == :vote)
	# 		@state = :vote

	# 		return
	# 	end

	# 	run_campaign

	# 	puts "The campagin has ended! Press [Return] to start voting."
	# 	gets 

	# 	@state = :voting_over
	# 	@response = "Election Day is here!"
	# 	@state_instructions = "Press [Return] to open the polls."
	# end

	# def build_primary_pools
	# 	@primary_pools = {}

	# 	@politicians.each do |name, politician|
	# 		@primary_pools[politician.party] = [] unless @primary_pools[politician.party]
	# 		@primary_pools[politician.party] << politician
	# 	end
	# end

	# def process_primaries
	# 	puts "PROCESSING PRIMARIES"

	# 	# get the first key, process the primary, delete the key from the pool, and restart the loop until there aren't any more keys
	# 	@current_party = @primary_pools.keys[0]

	# 	case @primary_pools[@current_party].length
	# 	when 0
	# 		finish_primary(@current_party)
	# 		return
	# 	when 1
	# 		politician = @primary_pools[@current_party][0]
	# 		puts "#{politician.name} is the only one running, and is the nominee by default!"
	# 		@victor = politician.name
	# 		gets
	# 		finish_primary(@current_party)
	# 		return
	# 	end

	# 	run_campaign({primary: @current_party})
	# 	@state = :primary_voting_over
	# end

	# def process_primary_vote
	# 	tally_votes

	# 	finish_primary
	# 	@state = :vote
	# end

	# def finish_primary(primary)

	# 	@primary_pools.delete(primary)
	# end

	# def process_voting_over(params = {})
	# 	defaults = {delay: 0.75, primary: nil}
	# 	params = defaults.merge(params)
	# 	delay = params[:delay]
	# 	primary = params[:primary]

	# 	tally_votes

	# 	puts ""


	# end
end