require 'minitest/autorun'
require './cod_game.rb'

class Test_CoDGame < Minitest::Test
	def test_game_creatable?
		game = CoDGame.new
	end

	def test_game_show_titlescreen
		game = CoDGame.new
		game.display_splash
	end

	def test_people_creatable?
		person = CoDPerson.new
		politician = CoDPolitician.new
		people = [person, politician]
		people.each do |human| 
			assert_equal true, (human.is_a? CoDPerson)
			human.name
			human.politics
			if human.is_a? CoDPolitician
				human.party 
				human.votes 
			end

		end
	end

	def test_random_people_exhaustion
		people = []

		loop do
			randomPerson = CoDPerson.Random
			break unless randomPerson
			people << randomPerson
		end

		people.each do |person|
			CoDPerson.RestoreName person.name
		end

		refute people.length == 0, "no random people created"
	end

	def test_random_politician_exhaustion
		people = []

		loop do
			randomPerson = CoDPolitician.Random
			break unless randomPerson
			people << randomPerson
		end

		people.each do |person|
			CoDPolitician.RestoreName person.name
		end

		refute people.length == 0, "no random people created"
	end

	def test_assign_person_politics
		person = CoDPerson.new
		politics = %w[1 2 3 4 5 neutral Neutral liberal Conservative Tea Party Socialist]
		politics.each do |alignment|
			person.politics = alignment

			refute_nil person.politics
		end
	end

	def test_input_command_create
		game = CoDGame.new
		assert_equal game.get_command("create"), :create
		assert_equal game.get_command("Create"), :create
		assert_equal game.get_command("C"), :create
		assert_equal game.get_command("c"), :create
	end

	def test_input_command_update
		game = CoDGame.new
		assert_equal game.get_command("update"), :update
		assert_equal game.get_command("Update"), :update
		assert_equal game.get_command("u"), :update
		assert_equal game.get_command("U"), :update
	end

	def test_input_command_vote
		game = CoDGame.new
		assert_equal game.get_command("vote"), :vote
		assert_equal game.get_command("Vote"), :vote
		assert_equal game.get_command("V"), :vote
		assert_equal game.get_command("v"), :vote
	end

	def test_input_command_list
		game = CoDGame.new
		assert_equal game.get_command("List"), :list
		assert_equal game.get_command("list"), :list
		assert_equal game.get_command("L"), :list
		assert_equal game.get_command("l"), :list
	end

	def test_input_command_quit
		game = CoDGame.new
		assert_equal game.get_command("quit"), :quit
		assert_equal game.get_command("Quit"), :quit
		assert_equal game.get_command("q"), :quit
		assert_equal game.get_command("Q"), :quit
	end

	def test_state_changes
		game = CoDGame.new
		states = [:menu, :create]
		states.each do |state|
			game.state = :some_weird_state
			game.process_command(state)
			assert_equal state, game.state
		end
	end

	def test_return_to_menu
		game = CoDGame.new
		states = [:create]
		states.each do |state|
			game.state = state
			game.process_command(:menu)
			assert_equal :menu, game.state
		end	
	end

	def test_show_list
		game = CoDGame.new
		person = CoDPerson.new
		person.name = "fart"
		person.politics = :tea_party
		game.process_command(:list)
		game.process_list
	end

	def test_create_people_state_changes
		game = CoDGame.new
		inputs = ["person", "politician"]
		inputs.each do |input|
			game.process_create
			game.process_command(game.get_command(input))
			assert_equal :create_person, game.state
		end
	end

	def test_create_person_commands
		game = CoDGame.new
		game.process_create_person(:voter)
		inputs = ["a gross bug", "4"] 
		
		inputs.each do |input|
			game.process_create_person(input)
		end

		refute_nil game.people["a gross bug"]
	end

	def test_create_politician_commands
		game = CoDGame.new
		game.process_create_person(:politician)
		inputs = ["pekel", "2"] 

		inputs.each do |input|
			game.process_create_person(input)
		end

		refute_nil game.people["pekel"]
	end

	def test_update_autoclose
		game = CoDGame.new
		game.process_command(:update)
		assert_equal :menu, game.state
	end

	def test_update
		game = CoDGame.new
		person = CoDPerson.new({name: "guy", politics: :liberal})
		game.people["guy"] = person
		game.process_update()
		game.process_update("guy")
		game.process_update("girl")
		game.process_update("2")
		
		refute_nil game.people["girl"]
	end

	def test_vote
		game = CoDGame.new()
		game.make_people

		game.process_vote()
		game.process_vote(0.01)
		game.process_voting_over(0.01)
		refute_nil game.victor
	end

	def test_game_show_outro
		game = CoDGame.new
		game.display_outro
	end
end