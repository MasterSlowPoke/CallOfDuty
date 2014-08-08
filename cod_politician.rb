class CoDPolitician < CoDPerson
	attr_accessor :active
	attr_accessor :party
	attr_accessor :votes

	STUMPS = [
		"Blessed is the mind too small for doubt.",
		"An open mind is like a fortress with its gates unbarred and unguarded.",
		"Innocence proves nothing.",
		"Hope is the first step on the road to disappointment.",
		"Success is measured in blood; yours or your enemy´s.",
		"Burn the heretic. Kill the mutant. Purge the unclean.",
		"Educate men without faith and you but make them clever devils.",
		"Beginning reform is beginning revolution.",
		"There is no such thing as innocence, only degrees of guilt.",
		"Prayer cleanses the soul, Pain cleanses the body.",
		"A small mind is easily filled with faith.",
		"Happiness is a delusion of the weak.",
		"In an hour of darkness a blind man is the best guide. In an age of insanity look to a madman to show the way.",
		"War is Peace, Freedom is Slavery, Ignorance is Strength.",
		"The rewards of tolerance are treachery and betrayal.",
		"In days such as these we can afford no luxury of morality.",
		"Pain is an illusion of the senses, despair is an illusion of the mind.",
		"BLOOD FOR THE BLOOD GOD! SKULLS FOR THE SKULL THRONE!",
		"Even a man who has nothing can still give his life.",
		"It makes no difference which one of us you vote for. Either way, your planet is doomed. DOOMED!",
		"Abortions for some, miniature American flags for others!",
		"We must move forward, not backward, upward not forward, and always twirling, twirling, twirling towards freedom!",
		"The politics of failure have failed. We need to make them work again.",
		"I am looking forward to an orderly election tomorrow, which will eliminate the need for a violent blood bath.",
	]

	def self.Random
		names_count = @@random_names.length
		return nil if names_count == 0

		CoDPolitician.new ({name: self.SelectName(names_count), party: rand(1..2).to_s})
	end

	def initialize(params ={})
		super
		self.party = params[:party]
		@vote = self
		@active = true
	end

	# Inactive politicians vote like a regular joe
	# Politicians voting in a primary that's not their own vote like a regular joe
	def recieve_stump(politician, primary = nil)
		unless @active
			@vote = nil if @vote == self
			return super
		end

		if primary
			if primary == @party
				return "I'm trying to get the nomination myself!"
			else 
				@vote = nil if @vote == self
				return super
			end
		else
			return "I'm running against you!" 			
		end
	end

	# used when politicians are voting in primaries they aren't running in
	def retrieve_success_rate(stumping_party, current_primary)
		#if the stumping politician is the same party, yes 3/4hs the time
		if stumping_party == @party
			75
		#if there isn't a primary and the politician is of a different party, only 1/3rd the time
		elsif current_primary.nil?
			33
		#if there is a primary and it's not the politician's party, 1/2th the time
		else
			50 
		end
	end

	def give_speach
		STUMPS.sample
	end

	def party= (alignment)
		return @party = alignment if alignment.is_a? Symbol
		return unless alignment.respond_to? :downcase
		
		@party = case alignment.downcase
		when "1", "democrat", "d"
			:democrat
		when "2", "republican", "r"
			:republican
		else
			nil
		end
	end

	def active?
		return @active
	end

	def reset_vote
		@best_roll = 100
		@vote = self
	end
end