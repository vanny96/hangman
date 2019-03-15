require 'csv'
require 'yaml'

class Hangman
	attr_reader :word

	def initialize
		@word = choose_word
		@displayed_word = []
		@word.length.times do
			@displayed_word << "_ "
		end 
	end

	def play
		if File.exist? ('savegame.yml')
			puts "Do you want to resume your game? (Y/N)"
			load_game if gets.chomp.downcase == 'y'

		end
		until @displayed_word.none?("_ ")
			letter = get_letter
		
			check_letter letter

			display_word
		end
		puts "You win!"
		File.delete 'savegame.yml'
	end

	private
	def choose_word
  	dictionary = CSV.open("words.txt").read
  	word = ""
  	until word.length > 4 && word.length < 13
			word = dictionary[rand(dictionary.length)][0].downcase
		end
	
		word
	end

	def display_word 
		puts @displayed_word.join
	end

	def get_letter
		puts "Choose a letter! (0 to save)"
		letter = gets.chomp
		if letter == "0"
		  save_game
			puts "Do you want to leave now? (Y/N)"
			exit if gets.chomp.downcase == "y"
		else
			until /[a-z]{1}/.match(letter).to_s == letter
				puts "Wrong format!"
				letter = gets.chomp
			end
		end
		letter
	end

	def check_letter letter
		right_letter = (0..@word.length).select do |index| 
			@word[index] == letter
		end
		right_letter.each do |index|
			@displayed_word[index] = letter   
		end  
	end

	#Serialization code
	def save_game
	  data = {word: @word, displayed_word: @displayed_word}
		file = File.open 'savegame.yml', 'w'
		file.puts YAML.dump(data)
	end
	def load_game
		data = YAML.load(File.open('savegame.yml'))
		@word = data[:word]
		@displayed_word = data[:displayed_word]
	end
end


game = Hangman.new
game.play

