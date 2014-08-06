class CoDPerson
	attr_reader :vote
	attr_accessor :name
	attr_accessor :politics

	@@random_names = [
		"Sarah Stamper",
		"Barack Obama",
		"Rick Scott",
		"Charlie Crist",
		"Jeb Bush",
		"Joe Biden",
		"Ron Paul",
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
		"Chris Scott",
		"Jesus Brazon",
		"Johanna Mikkola",
		"Johnathon Lyons",
		"Josh Powell",
		"Juancarlo Perez",
		"Widney St. Louis",
		"Juha Mikkola",
		"Bill Clinton",
		"Ronald Reagan",
	]

	REPUBLICAN_SUCCCESS = {neutral: 50, conservative: 75, liberal: 25, tea_party: 90, socialist: 10}
	DEMOCRAT_SUCCCESS = {neutral: 50, conservative: 25, liberal: 75, tea_party: 10, socialist: 90}

	def initialize(params = {})
		@name = params[:name]
		self.politics = params[:politics]
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
		return @politics = alignment if alignment.is_a? Symbol
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

	def recieve_stump(politician, primary = nil)
		roll = rand(0..99)
		success = retrieve_success_rate(@politics, politician.party)

		# you want to roll under the success rate
		if roll < success
			# the person should vote for the person they agree with the most on, not just the last one they agree with
			if roll < @best_roll
				changed_mind_text = ""
				changed_mind_text = " Forget about that #{@vote.name} jerk!" if @vote

				@vote = politician
				@best_roll = roll
				return "You're thinking what I'm thinking!" + changed_mind_text
			else
				return "While I like what you are saying, #{@vote.name} still has my vote."
			end
		else
			return "I'll never vote for you!"
		end
	end

	def retrieve_success_rate(politics, party)
		# used when politicians are voting in primaries they aren't running in
		if @party  
			if @party == party
				return 75
			else
				return 50 
			end
		end

		case party
		when :republican
			REPUBLICAN_SUCCCESS[politics]
		when :democrat
			DEMOCRAT_SUCCCESS[politics]
		end
	end

	def reset_vote
		@best_roll = 100
		@vote = nil
	end
end