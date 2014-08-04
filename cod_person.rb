class CoDPerson
	attr_reader :vote
	attr_accessor :name
	attr_accessor :politics
	attr_accessor :role

	@@random_names = [
		"Sarah Stamper",
		"Barack Obama",
		"Rick Scott",
		"Charlie Crist",
		"Jeb Bush",
		"Joe Biden",
		"Ed Toro",
		"Craig Sniffen",
		"Andy Weiss",
		"Hassan Mian",
		"Joel Lusky",
		"Jose Martinez-Rubio",
		"Sam Zorbel",
		"Alfonzo Pintos",
		"Bayrdo Navarro",
		"Bryce Kerley",
		"Burt Rosenburg",
		"Diego Lugo",
		"Eziquiel Politzer",
		"Frank Ortiz",
		"Jesus Brazon",
		"Johanna Mikkola",
		"Johnathon Lyons",
		"Josh Powell",
		"Juancarlo Perez",
		"Widney St. Louis",
		"Juha Mikkola",
		"Lion El'Johnson",
		"Fulgrim",
		"Perturabo",
		"Jaghatai Khan",
		"Leman Russ",
		"Rogal Dorn",
		"Konrad Kruze",
		"Sanguinius",
		"Ferrus Manus",
		"Angron",
		"Roboute Guilliman",
		"Mortarion",
		"Magnus the Red",
		"Horus Lupercal",
		"Logar Aurallian",
		"Vulkan",
		"Corvus Corax",
		"Alpharius Omegon"
	]

	REPUBLICAN_SUCCCESS = {neutral: 50, conservative: 75, liberal: 25, tea_party: 90, socialist: 10}
	DEMOCRAT_SUCCCESS = {neutral: 50, conservative: 25, liberal: 75, tea_party: 10, socialist: 90}

	def initialize(params = {})
		@name = params[:name]
		self.politics = params[:politics]
		@role = :voter
		@best_roll = 100
	end

	def self.Random
		names_count = @@random_names.length
		return nil if names_count == 0

		CoDPerson.new ({name: self.SelectName(names_count), politics: rand(1..5).to_s})
	end

	# TODO: Is there a better way to 'reset' class variables?
	def self.RestoreName (name)
		@@random_names << name
	end

	def self.SelectName(names_count)
		random_index = rand(names_count)
		name = @@random_names[random_index]
		@@random_names.delete_at(random_index)
		name
	end

	def politics= (alignment)
		return alignment if alignment.is_a? Symbol
		return unless alignment.respond_to? :to_s

		@politics = case alignment.to_s.downcase
		when "1","liberal"
			:liberal
		when "2", "conservative"
			:conservative
		when "3", "tea party", "tea", "party"
			:tea_party
		when "4", "socialist"
			:socialist
		when "5", "neutral"
			:neutral
		else
			nil
		end
	end

	def recieve_stump(politician)
		roll = rand(0..99)
		success = retrieve_success_rate(@politics, politician.party)

		if roll < success
			# the person should vote for the person they agree with the most on, not just the last one they agree with
			if roll < @best_roll
				changed_mind_text = ""
				changed_mind_text = " Forget about that #{@vote.name} jerk!" if @vote

				@vote = politician
				@best_roll = roll
				return "You're thinking what I'm thinking!" + changed_mind_text
			else
				return "While I like what you are saying, #{vote.name} still has my vote."
			end
		else
			return "I'll never vote for you!"
		end
	end

	def retrieve_success_rate(politics, party)
		case party
		when :republican
			REPUBLICAN_SUCCCESS[politics]
		when :democrat
			DEMOCRAT_SUCCCESS[politics]
		end
	end
end

class CoDPolitician < CoDPerson
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

	def initialize(params ={})
		super
		@role = :politician
		self.party = params[:party]
		@vote = self
	end

	def recieve_stump(*rest)
		"I'm running against you!"
	end

	def give_speach
		STUMPS.sample
	end


	def self.Random
		names_count = @@random_names.length
		return nil if names_count == 0

		CoDPolitician.new ({name: self.SelectName(names_count), party: rand(1..2).to_s})
	end

	def party= (alignment)
		return alignment if alignment.is_a? Symbol
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
end