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
end

# rubocop:enable Metrics/BlockLength
