module Codebreaker

  class Game
  	@@attempts_count = 0
    def initialize(output = $stdout, input = $stdin)
	  @input = input
	  @output = output
	end

 	def secret_code
	  (1..4).map { %w[1 2 3 4 5].delete_at(rand(%w[1 2 3 4 5].length))}.join
	end

	def start
	  @secret = secret_code
	  @output.puts "Welcome to Codebreaker! \nAt any point of the game you can request hint by typing 'hint' \nYou have 10 attempt, good luck!"
      @output.puts "Enter guess (4 numbers between 1 and 5): "
      while @@attempts_count < 10 do
      	attempt = @input.gets.chomp
      	#break if win
      	case attempt
      	  when 'hint'
      	    hint
      	  when 'Y'
      	  	@@attempts_count = 0
      	  	guess(attempt)
      	  when 'N'
      	  	exit
      	  else
      	  	guess(attempt)
      	end
      	  @@attempts_count += 1
      end
      loose
	end

	def guess(attempt)
	  marker = Marker.new(@secret, attempt)
	  @output.puts '+'*marker.exact_match_count + '-'*marker.number_match_count

	  win if marker.exact_match_count == 4
	end

	def save_score
	end

	def try_again
 	  @output.puts "Want to try once again? Type 'Y' or 'N'"
 	  @attempt == "Y" ? start : exit
 	end

	def hint
	 @output.puts "The first number is: #{@secret[0]} ;)"
	end

	def win
	  #if attempt == @secret
 	  	  @output.puts 'Congratulations, you win!'
 	  #end
 	#  save_score
 	  try_again
	end

	def loose
 	  @output.puts 'That is sad, - game is over. You lose!'
 	  try_again
	end

  end

  class Marker
    def initialize(secret, guess)
      @secret, @guess = secret, guess
    end
    def number_match_count
      total_match_count - exact_match_count
    end
    def total_match_count
      secret = @secret.split('')
      @guess.split('').inject(0) do |count, n|
      count + (delete_first(secret, n) ? 1 : 0)
      end
    end
    def delete_first(code, n)
      code.delete_at(code.index(n)) if code.index(n)
    end
    def exact_match_count
      (0..3).inject(0) do |count, index|
      count + (exact_match?(@guess, index) ? 1 : 0)
      end
    end
    def exact_match?(guess, index)
      @guess[index] == @secret[index]
    end
    def number_match?(guess, index)
      @secret.include?(@guess[index]) && !exact_match?(@guess, index)
    end
  end

end
