# frozen_string_literal: true

module Styled

  BOLD = 1

  def stylize(string, style)
    "\e[#{style}m#{string}\e[0m"
  end

  HANGMAN_PARTS = {
                    head: [0, 'O'],
                    neck: [1, '|'],
                    left_arm: [2, "\u2572"],
                    right_arm: [3, "\u2571"],
        torso: [4, '|'],
        left_leg: [5, "\u2571"],
        right_leg: [6, "\u2572"]
      }.freeze

      SCREEN_WIDTH = 80
      LEFT_OFFSET = 25
      TOP_BAR_WIDTH = 22
      SQUARE_WIDTH = 2
      BOTTOM_BAR_OFFSET = TOP_BAR_WIDTH - 2 * SQUARE_WIDTH
      ROPE_TO_POLE_INDENT = TOP_BAR_WIDTH - 1
    
      SCREEN_INDENT = ' ' * LEFT_OFFSET
      BOTTOM_BAR_INDENT = ' ' * BOTTOM_BAR_OFFSET
      POLE_INDENT = ' ' * TOP_BAR_WIDTH
      HEAD_AND_TORSO_INDENT = ' ' * (TOP_BAR_WIDTH - 2)
      EXTREMITIES_INDENT = ' ' * (TOP_BAR_WIDTH - 3)
    
      SQUARE = "\e[47m  \e[0m"
      BULLET = "\u27a0"
      TOP_BAR = SQUARE * (TOP_BAR_WIDTH / SQUARE_WIDTH + 1)
      ROPE = '|'
      POLE = SQUARE
      BOTTOM_BAR = SQUARE * 5
end



