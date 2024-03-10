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
        str + " #{lane[row] ? lane[row].encode('utf-8') : '  '} |"
      end)
    end
    puts "   1    2    3    4    5    6    7"
  end

  def add_to_lane(marker, lane)
    return unless valid_lane? lane

    board[lane].push(marker)
  end

  def valid_lane?(lane)
    lane.between?(0, 6) && board[lane].length < 6
  end

  def full?
    board.all? { |lane| lane.length == 6 }
  end

  def won?(marker)
    vertical_win?(marker) || horizontal_win?(marker) || diagonal_win?(marker)
  end

  private

  attr_writer :board

  def initialize
    reset_board
  end

  def vertical_win?(marker)
    board.each do |lane|
      lane.each.reduce(0) do |count, e|
        new_count = e == marker ? count + 1 : 0
        return true if new_count == 4

        new_count
      end
    end
    false
  end

  def horizontal_win?(marker)
    6.times do |row|
      7.times.reduce(0) do |count, col|
        new_count = board.dig(col, row) == marker ? count + 1 : 0
        return true if new_count == 4

        new_count
      end
    end
    false
  end

  def diagonal_win?(marker)
    up_right_starts = [[0, 2], [0, 1], [0, 0], [1, 0], [2, 0], [3, 0]]
    down_right_starts = [[0, 3], [0, 4], [0, 5], [1, 5], [2, 5], [3, 5]]
    up_right_starts.any? { |start| line_match?(marker, start) } ||
      down_right_starts.any? { |start| line_match?(marker, start, "down") }
  end

  def line_match?(marker, start, direction = "up")
    x = start[0]
    y = start[1]
    count = 0
    while x.between?(0, 6) && y.between?(0, 5)
      count = board.dig(x, y) == marker ? count + 1 : 0
      return true if count == 4

      x += 1
      y = direction == "up" ? y + 1 : y - 1
    end
    false
  end
end
