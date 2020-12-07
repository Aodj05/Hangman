# frozen_string_literal: true

require_relative './displayed'
require_relative './serialized'
require_relative './options'

# Game innards
class Game
  include Displayed
  include Options
  include Serialized

  attr_reader :secret_word, :incorrect_guesses
  attr_accessor :guess, :remaining_letters

  def initialize
    @secret_word = select_word
    @remaining_letters = @secret_word.clone
    @incorrect_guesses = []
    @guess = nil
  end

  def start
    puts start_splash

    option = gets.chomp.downcase until START_OPTIONS.include? option

    clear_screen

    if option == 'n'
      play
    else
      puts load_game saved_games
      proceed load_screen
    end
  end

  private

  def select_word
    dictionary = File.readlines('5desk.txt').map(&:strip)
    dictionary.select { |word| word.length.between? 5, 12 }.sample.downcase
  end

  def guessed?
    remaining_letters.length.zero? || secret_word == guess
  end

  def game_over?
    incorrect_guesses.length == 7 || guessed?
  end

  def any_matches?
    prev_rem_letters = remaining_letters

    self.remaining_letters = if guessed?
                               ' '
                             elsif guess.length == 1
                                remaining_letters.gsub(guess, '')
                             else
                                remaining_letters
                             end
    remaining_letters == prev_rem_letters
  end

  def display
    clear_screen
    puts hanging_man incorrect_guesses.length
    puts status secret_word, remaining_letters, incorrect_guesses
    puts prompt_guess unless game_over?
  end

  def proceed(selected)
    return if selected == 'e'

    return Game.new.start if selected == 'b'

    g_key = selected.to_i
    deserialize File.read(g_list[g_key])
    play
  end

  def up_incorrect_guess
    incorrect_guesses << guess if any_matches?
  end

  def save
    print save_screen
    save_to_file
    puts save_success
    sleep(1)
  end

  def correct_display
    secret_word.split('') - remaining_letters.split('')
  end

  def guessed_already?(guess)
    correct_display.include?(guess) || incorrect_guesses.include?(guess)
  end

  def guess_letter
    guess = loop do
      guess = gets.chomp.strip.downcase

      break guess unless guessed_already?(guess) || guess.empty?
    end
  end

  def game_loop
    until game_over?
      display
      self.guess = guess_letter

      if IG_OPTIONS.include? guess
        break if guess == 'E'

        save
        next
      end

      up_incorrect_guess
    end
  end

  def play
    game_loop
    return if guess == 'E'

    display
    gm_over_screen guessed?, secret_word

    option = gets.chomp.to_i until EOG_OPTIONS.include? option
    Game.new.start if option == 1
  end
end
