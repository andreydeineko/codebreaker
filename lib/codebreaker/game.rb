module Codebreaker

  class Game
    def initialize(output)
	  #@input = input
	  @output = output
	end

	def secret_code
	  options = %w[1 2 3 4 5]
	  (1..4).map { options.delete_at(rand(options.length))}.join
	end

	def start(secret)
	  @secret = secret_code
	  @output.puts "Welcome to Codebreaker! \nAt any point of the game you can request hint by typing 'hint' \nYou have 10 attempt, good luck!"
      @output.puts 'Enter guess (4 numbers between 1 and 5): '	
	end

	def guess(guess)
	  marker = Marker.new(@secret, guess)
	  @output.puts '+'*marker.exact_match_count + '-'*marker.number_match_count

	  win if marker.exact_match_count == 4

	#  guess_count = 0
	#  guess_count += 1
	#  loose if guess_count == 10
	end

	def save_score
	end

	def try_again
 	  @output.puts "Want to try once more? Type 'Y' or 'N'"
 	  start if @input.gets.chomp == ("Y" || "y")
 	  exit  if @input.gets.chomp == ("N" || "n")
	end

	def hint
	  @output.puts @secret[0]  if @input.gets.chomp == "hint"  	
	end

	def win
 	  @output.puts 'Congratulations, you win!'
 	  save_score
 	  try_again
	end

	def loose
 	  @output.puts 'That is sad, - game is over. You lose!'
 	  try_again
	end
  end

end