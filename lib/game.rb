require 'colorize'

class Game
  def initialize
    @key = generate_key
    @key_clues = ''
    @key.length.times { @key_clues << '_' }
    @chances = 10
    @guessed = []
  end

  def enter_guess
    display
    begin
      puts 'Enter a letter or type save to save the game'
      guess = gets.chomp.upcase
      return 'save' if guess == 'SAVE'
      raise 'Invalid input' unless guess.length == 1 && /[[:alpha:]]/.match(guess)
      raise 'Already guessed' if @guessed.include?(guess.green) || @guessed.include?(guess.red)
      match_guess(guess)
    rescue StandardError => e
      puts e.to_s.red
      retry
    end
  end

  def game_over?
    if @key == @key_clues
      puts @key.yellow
      puts 'YOU WON'.green
      true
    elsif @chances.zero?
      puts 'GAME OVER'.red
      puts "The word is #{@key.yellow}"
      true
    else
      enter_guess
    end
  end

  private

  def match_guess(guess)
    if @key.include?(guess)
      @guessed << guess.green
      add_clue(guess)
      puts 'Good Guess'.green
    else
      @chances -= 1
      @guessed << guess.red
      puts 'Bad Guess'.magenta
    end
    # game_over?
  end

  def add_clue(guess)
    @key.split('').each_with_index do |k,i|
      @key_clues[i] = k if k == guess
    end
  end

  def display
    puts @key_clues.cyan
    @guessed.each { |g| print g.to_s + ' '}
    puts "Chances remaining - #{@chances}\n"
  end

  def generate_key
    dictionary = File.open('5desk.txt', 'r')
    words = []
    dictionary.each_line do |word|
      words << word.upcase if word.length > 5 && word.length <= 12
    end
    words.sample.chomp
  end

  def save_game
    file = prompt_file_name
    dump = YAML.dump(game)
    File.open(File.join(Dir.pwd, "/saved/#{file}.yaml"),'w') { |f| f.write dump }
  end
end
