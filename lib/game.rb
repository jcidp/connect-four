# frozen_string_literal: true

require "./lib/board"

# Class to control game flow
class Game
  def play_game
    self.tie = false
    board.reset_board
    puts "First player to connect 4 markers in a row wins"
    play_turn until game_over?
    end_game
  end

  private

  attr_accessor :board, :current_marker, :tie

  def initialize
    @current_marker = "\u26AA"
    @board = Board.new
  end

  def play_turn
    next_player
    puts "Current board:"
    board.display_board
    puts "#{current_marker.encode('utf-8')} to play"
    board.add_to_lane(current_marker, player_input)
  end

  def player_input
    input = 10
    until board.valid_lane?(input)
      puts "Input a lane number between 1-7. Remember you can't play in a full lane."
      input = gets.chomp.to_i - 1
    end
    input
  end

  def next_player
    self.current_marker = current_marker == "\u26AA" ? "\u26AB" : "\u26AA"
  end

  def game_over?
    if board.won?(current_marker)
      true
    elsif board.full?
      self.tie = true
      true
    else
      false
    end
  end

  def end_game
    board.display_board
    puts "Game over!"
    puts tie == "tie" ? "It's a tie!" : "#{current_marker} won the game!"
    puts "Type 'r' to play a rematch, anything else to quit."
    play_game if gets.chomp == "r"
  end
end
