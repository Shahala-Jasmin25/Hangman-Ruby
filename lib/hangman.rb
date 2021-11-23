require_relative 'game'
require 'yaml'
require 'colorize'

puts 'Welcome to Hangman. New here? Would you like to start a
                                                  1) NEW GAME
      Or have you saved a game before?            2) LOAD GAME'

user_choice = gets.chomp

def save_game(game)
  file = prompt_file_name
  dump = YAML.dump(game)
  File.open(File.join(Dir.pwd, "/saved/#{file}.yaml"),'w') { |f| f.write dump }
end

def load_game
  saved_game = choose_game
  file = File.open(File.join(Dir.pwd, saved_game), 'r')
  loaded_game = YAML.load(file)
  file.close
  loaded_game
end

def choose_game
  begin
    file_names = Dir['saved/*'].map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts 'Enter name of your saved game'
    puts file_names
    saved_game = gets.chomp
    raise 'Invalid filename' unless file_names.include?(saved_game)

    puts 'loading....'
    p "/saved/#{saved_game}.yaml"
    "/saved/#{saved_game}.yaml"
  rescue StandardError => e
    puts e
  end
end

def prompt_file_name
  file_names = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))]}
  begin
    puts 'Enter filename to be saved'
    new_file = gets.chomp
    raise 'File name already exist' if file_names.include?(new_file)
    new_file
  rescue StandardError => e
    puts "#{e} Are you sure you want to overwrite? Y/N"
    answer = gets.chomp.downcase
    until %w[y n].include?(answer)
      puts 'Enter a valid input'
      answer = gets.chomp.downcase
    end
    answer == 'y' ? new_file : nil
  end
end

until %w[1 2].include?(user_choice)
  puts 'Enter a valid input - 1 OR 2'
  user_choice = gets.chomp
end

game = user_choice == '1' ? Game.new : load_game

until game.game_over?
  next unless game.enter_guess == 'save'

  save_game(game)
  puts 'SAVED'
  break
end
