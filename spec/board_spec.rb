# frozen_string_literal: true

require "./lib/board"

# rubocop:disable Metrics/BlockLength

describe Board do
  let(:test_board) { described_class.new }

  describe "#reset_board" do
    context "when creating the board" do
      it "creates it from scratch" do
        board = test_board.board
        expect(board).to eql([[], [], [], [], [], [], []])
      end
    end

    context "when reseting a board" do
      before do
        test_board.instance_variable_set(:@board, [%w[x o], %w[x o], ["x"], %w[x o x o], %w[x o], ["o"], ["x"]])
      end

      it "overwrites the existing board with a clean one" do
        test_board.reset_board
        board = test_board.board
        expect(board).to eql([[], [], [], [], [], [], []])
      end
    end
  end

  describe "#add_to_lane" do
    context "when adding a marker to an empty lane" do
      it "adds the marker" do
        test_board.add_to_lane("x", 4)
        board = test_board.board
        expect(board).to eql([[], [], [], [], ["x"], [], []])
      end
    end

    context "when adding a marker to a lane with existing markers" do
      before do
        test_board.instance_variable_set(:@board, [%w[x o], %w[x o], ["x"], %w[x o x o], %w[x o], ["o"], ["x"]])
      end

      it "adds marker at the end/top" do
        test_board.add_to_lane("o", 4)
        board = test_board.board
        expect(board).to eql([%w[x o], %w[x o], ["x"], %w[x o x o], %w[x o o], ["o"], ["x"]])
      end
    end

    context "when adding a marker to a full lane" do
      before do
        test_board.instance_variable_set(:@board, [%w[x o], %w[x o], ["x"], %w[x o x o x o], %w[x o], ["o"], ["x"]])
      end

      it "doesn't add a marker" do
        test_board.add_to_lane("x", 3)
        board = test_board.board
        expect(board).to eql([%w[x o], %w[x o], ["x"], %w[x o x o x o], %w[x o], ["o"], ["x"]])
      end
    end

    context "when adding a marker to a non-existing lane" do
      it "doesn't add a marker" do
        test_board.add_to_lane("x", 7)
        board = test_board.board
        expect(board).to eql([[], [], [], [], [], [], []])
      end
    end
  end

  describe "#full?" do
    context "when board isn't full" do
      it "returns false" do
        expect(test_board).not_to be_full
      end
    end

    context "when board is full" do
      before do
        test_board.instance_variable_set(:@board, Array.new(7) { %w[x o x o x o] })
      end

      it "returns true" do
        expect(test_board).to be_full
      end
    end
  end

  describe "#won?" do
    context "when the marker hasn't won" do
      before do
        test_board.instance_variable_set(:@board,
                                         [
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[o x o x o x],
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[x o x o x o]
                                         ])
      end

      it "returns false" do
        result = test_board.won? "x"
        expect(result).to be false
      end
    end

    context "when the marker wins vertically" do
      before do
        test_board.instance_variable_set(:@board, [%w[x o], %w[x o], ["x"], %w[x x x x], %w[x o], ["o"], ["x"]])
      end

      it "returns true" do
        result = test_board.won? "x"
        expect(result).to be true
      end
    end

    context "when the marker wins horizontally" do
      before do
        test_board.instance_variable_set(:@board, [%w[x o], %w[x o], ["x"], %w[x o x o x o], %w[x o], ["o"], ["x"]])
      end

      it "returns true" do
        result = test_board.won? "x"
        expect(result).to be true
      end
    end

    context "when the marker wins in an upward-right diagonal" do
      before do
        test_board.instance_variable_set(:@board,
                                         [
                                           %w[o o x o x o],
                                           %w[x x x o x o],
                                           %w[x o x o x o],
                                           %w[o x o x o x],
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[x o x o x o]
                                         ])
      end

      it "returns true" do
        result = test_board.won? "x"
        expect(result).to be true
      end
    end

    context "when the marker wins in an downward-right diagonal" do
      before do
        test_board.instance_variable_set(:@board,
                                         [
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[x o x o x o],
                                           %w[o x o x o x],
                                           %w[x o o o x o],
                                           %w[x o x x x o],
                                           %w[x o x o x o]
                                         ])
      end

      it "returns true" do
        result = test_board.won? "x"
        expect(result).to be true
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
