# frozen_string_literal: true

require_relative './styled'

# displaying all the parts
module Displayed
  include Styled

  def title
    <<~HEREDOC
      #{'~~~~~~~~~~~~~~~~~~'.center 80}
      #{stylize '[  H A N G M A N  ]'.center(80), BOLD}
      #{'~~~~~~~~~~~~~~~~~~'.center 80}
    HEREDOC
  end

    def start_splash
        clear_screen
      <<~HEREDOC
          Welcome to hangman, guess the word before the man gets hanged.

          To start press...
          (n) New game
          (s) Saved game
      HEREDOC
    end

    def save_screen
        clear_screen
        'Name your file'
    end

  def filenames(files)
      files.map.with_index do |file, index|
          "   (#{index + 1}) #{File.basename(file, '.*').capitalize}"
      end.join("\n")
  end

    def no_saves
        "No saves, press B to return"
    end

    def save_success
        "save successful"
    end

    def load_game(files)
      return no_saves if files.empty?

        <<~HEREDOC
        #{filenames files}
        HEREDOC
    end

    def drawn_parts(incorrect_guesses)
        HANGMAN_PARTS.each_with_object({}) do |(part, content), hash|
            min_mistakes = content[0]
            symbol = content[1]

            hash[part] = incorrect_guesses.to_i > min_mistakes.to_i ? symbol : ' '
        end
    end

    def stick_fig(incorrect_guesses)
        draw_parts = drawn_parts incorrect_guesses

        <<~HEREDOC.chomp
      #{SCREEN_INDENT} #{draw_parts[:head]}#{HEAD_AND_TORSO_INDENT}#{SQUARE}
      #{SCREEN_INDENT}#{draw_parts[:left_arm]}#{draw_parts[:neck]}#{draw_parts[:right_arm]}#{EXTREMITIES_INDENT}#{SQUARE}
      #{SCREEN_INDENT} #{draw_parts[:torso]}#{HEAD_AND_TORSO_INDENT}#{SQUARE}
      #{SCREEN_INDENT}#{draw_parts[:left_leg]} #{draw_parts[:right_leg]}#{EXTREMITIES_INDENT}#{SQUARE}
    HEREDOC
    end

    def hanging_man(incorrect_guesses)
        <<~HEREDOC

      #{SCREEN_INDENT}#{TOP_BAR}#{SQUARE}#{SQUARE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 3)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 2)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 1)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * ROPE_TO_POLE_INDENT}#{POLE}
      #{stick_fig incorrect_guesses}
      #{SCREEN_INDENT}#{POLE_INDENT}#{POLE}
      #{SCREEN_INDENT}#{BOTTOM_BAR_INDENT}#{BOTTOM_BAR}
    HEREDOC
    end

    def hide_secret(secret, remaining_letters)
        remaining_letters.to_s.split('').each do |remaining_letter|
            secret = secret.gsub remaining_letter, '_'
        end

        mystery = secret.to_s.split('').join(' ')
        <<~HEREDOC

      #{stylize mystery.center(80), BOLD}

    HEREDOC
    end

    def incorrect_list(incorrect_guesses)
        "#{incorrect_guesses.to_s.center(80)}\n \n"
    end

    def status(secret, remaining_letters, incorrect_guesses)
        "#{hide_secret secret, remaining_letters}#{incorrect_list incorrect_guesses}"
    end

    def prompt_guess
      puts 'Make a guess => '
    end

    def clear_screen
      puts title
    end

    WINNER = 'Congrats another one lives'
    LOSER = 'Another brought to justice'

    def gm_over_screen(game_won, secret)
        if game_won
            puts "#{WINNER}, the word was #{secret}"
        else
            puts "#{LOSER}, the word was #{secret}"
        end
        print 'Would you like to play again? (1/2)'
    end
end