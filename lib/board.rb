# frozen_string_literal: true

# Class to control the board in the Connect Four game
class Board
  attr_reader :board

  def reset_board
    self.board = Array.new(7) { [] }
  end

  def display_board
    5.downto(0) do |row|
      puts(board.each.reduce("|") do |str, lane|
        str + " #{lane[row] || ' '} |"
      end)
    end
  end

  def add_to_lane(marker, lane)
    board[lane].push(marker)
  end

  private

  attr_writer :board

  def initialize
    reset_board
  end
end

my_board = Board.new
my_board.display_board
