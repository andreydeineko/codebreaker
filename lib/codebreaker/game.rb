module Codebreaker

  class Game
    SECRET_LENGTH  = 4
    ATTEMPTS_COUNT = 10

    SAVE_SCORE_MESSAGE = 'Do you wish to save your score? (Y/N)'
    SHOW_SCORE_MESSAGE = 'Do you want to see your score entries? (Y/N)'

    def initialize(output = $stdout, input = $stdin)
      @input = input
      @output = output
      @score  = []

      @attempts_count = 0
      @started_at   = nil
      @completed_at = nil
    end

    def secret_code
      numbers = []

      until numbers.count == SECRET_LENGTH
        num = rand(10)
        numbers.push(num) unless numbers.include?(num)
      end

      numbers.join
    end

    def start
      reset_assets!

      @output.puts "Welcome to Codebreaker! \nAt any point of the game you can request hint by typing 'hint' \nYou have 10 attempt, good luck!"
      @output.puts "Enter guess: "

      @started_at = Time.now

      while @attempts_count < ATTEMPTS_COUNT do
        attempt = @input.gets.chomp
        #break if win
        @attempts_count += 1

        case attempt
        when 'hint'
          hint
        when 'Y'
          @attempts_count = 0
          guess(attempt)
        when 'N'
          exit
        else
          guess(attempt)
        end
      end

      loose
    end

    def guess(attempt)
      marker = Marker.new(@secret, attempt)
      @output.puts marker.output

      win if marker.exact_match_count == 4
    end

    def try_again
      @output.puts "Want to try once again? Type 'Y' or 'N'"
      if @input.gets.chomp == 'Y'
        start
      else
        show_score and exit
      end
    end

    def hint
      @output.puts "The first number is: #{@secret[0]} ;)"
    end

    def win
      @output.puts 'Congratulations, you win!'
      @completed_at = Time.now

      save_score if save_score?

      try_again
    end

    def save_score
      @score << Score.new(@attempts_count, @started_at, @completed_at)
    end

    def save_score?
      @output.puts(SAVE_SCORE_MESSAGE)
      @input.gets.chomp == 'Y'
    end

    def loose
      @output.puts 'That is sad, - game is over. You lose!'

      try_again
    end

    private

    def reset_assets!
      @secret = secret_code
      @attempts_count = 0
      @started_at     = nil
      @completed_at   = nil
    end

    def show_score?
      @output.puts SHOW_SCORE_MESSAGE
      @input.gets.chomp == 'Y'
    end

    def show_score
      @score.each_with_index do |score_entry, index|
        game_index = index + 1
        @output.puts "Game #{game_index}: #{score_entry.output}"
      end
    end
  end

  class Marker
    SUCCESS        = '+'
    WRONG_POSITION = '-'
    FAILURE        = ' '

    def initialize(secret, guess)
      @secret, @guess = secret, guess
    end

    def number_match_count
      total_match_count - exact_match_count
    end

    def output
      buffer = ''
      secret, guess = @secret.split('').map(&:to_i), @guess.split('').map(&:to_i)

      guess.each_with_index do |digit, index|
        if digit == secret[index]
          buffer << SUCCESS
        elsif secret.include?(digit)
          buffer << WRONG_POSITION
        else
          buffer << FAILURE
        end
      end

      buffer
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

  class Score
    attr_reader :attempts_count, :time_taken

    def initialize(attempts_count, started_at, completed_at)
      @attempts_count = attempts_count
      @time_taken     = (completed_at - started_at).to_i # seconds
    end

    def output
      "It took you #{attempts_count} attempts to win the game (#{@time_taken} seconds)."
    end
  end

end
