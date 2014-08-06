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
		assert_equal game.get_menu_command("create"), :create
		assert_equal game.get_menu_command("Create"), :create
		assert_equal game.get_menu_command("C"), :create
		assert_equal game.get_menu_command("c"), :create
	end

	def test_input_command_update
		game = CoDGame.new
		assert_equal game.get_menu_command("update"), :update
		assert_equal game.get_menu_command("Update"), :update
		assert_equal game.get_menu_command("u"), :update
		assert_equal game.get_menu_command("U"), :update
	end

	def test_input_command_vote
		game = CoDGame.new
		assert_equal game.get_menu_command("vote"), :vote
		assert_equal game.get_menu_command("Vote"), :vote
		assert_equal game.get_menu_command("V"), :vote
		assert_equal game.get_menu_command("v"), :vote
	end

	def test_input_command_list
		game = CoDGame.new
		assert_equal game.get_menu_command("List"), :list
		assert_equal game.get_menu_command("list"), :list
		assert_equal game.get_menu_command("L"), :list
		assert_equal game.get_menu_command("l"), :list
	end

	def test_input_command_quit
		game = CoDGame.new
		assert_equal game.get_menu_command("quit"), :quit
		assert_equal game.get_menu_command("Quit"), :quit
		assert_equal game.get_menu_command("q"), :quit
		assert_equal game.get_menu_command("Q"), :quit
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
		game.set_list_state
	end

	def test_create_people_state_changes
		game = CoDGame.new
		inputs = ["person", "politician"]
		inputs.each do |input|
			game.set_create_state
			game.process_command(game.get_create_command(input))
			assert_equal :create_person_name, game.state
		end
	end

	def test_create_person
		game = CoDGame.new
		game.set_create_person_state(:voter)
		game.set_create_person_name_state("a gross bug")
		game.set_create_person_partisanization("4")

		refute_nil game.people["a gross bug"]
	end

	def test_create_politician_commands
		game = CoDGame.new
		game.set_create_person_state(:politician)
		game.set_create_person_name_state("pekel")
		game.set_create_person_partisanization("2")

		refute_nil game.people["pekel"]
		assert game.people["pekel"].is_a? CoDPolitician
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

		game.set_update_person_state("guy")
		game.set_update_person_name_state("girl")
		game.set_update_person_partisanization("2")
		
		refute_nil game.people["girl"]
	end

	def test_game_show_outro
		game = CoDGame.new
		game.display_outro
	end
end