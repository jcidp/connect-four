# frozen_string_literal: true

require "./lib/game"
require "./lib/board"

describe Game do
  subject(:setup_game) { described_class.new }
  describe "#play_game" do
    before do
      # allow(setup_board).to receive(:reset_board)
      allow(setup_game).to receive(:game_over?).and_return(false, false, true)
      allow(setup_game).to receive(:play_turn).and_return(nil, nil)
    end

    it "calls reset_board" do
      board = setup_game.instance_variable_get(:@board)
      expect(board).to receive(:reset_board).once
      setup_game.play_game
    end

    it "plays 2 turns" do
      expect(setup_game).to receive(:play_turn).exactly(2).times
      setup_game.play_game
    end
  end

  describe "#play_turn" do
    before do
      allow(setup_game).to receive(:current_marker).and_return("x", "x")
      allow(setup_game).to receive(:player_input).and_return(3)
      allow(setup_game).to receive(:next_player)
    end

    it "calls display_board" do
      board = setup_game.instance_variable_get(:@board)
      expect(board).to receive(:display_board).once
      setup_game.send(:play_turn)
    end

    it "calls add_to_lane" do
      board = setup_game.instance_variable_get(:@board)
      expect(board).to receive(:add_to_lane).with("x", 3).once
      setup_game.send(:play_turn)
    end
  end

  describe "#next_player" do
    context "when the current_marker is \u26AA" do
      it "changes the current_marker to \u26AB" do
        expect { setup_game.send(:next_player) }.to change {
                                                      setup_game.instance_variable_get(:@current_marker)
                                                    }.from("\u26AA").to("\u26AB")
      end
    end

    context "when the current_marker is \u26AB" do
      before do
        setup_game.instance_variable_set(:@current_marker, "\u26AB")
      end

      it "changes the current_marker to \u26AA" do
        expect { setup_game.send(:next_player) }.to change {
                                                      setup_game.instance_variable_get(:@current_marker)
                                                    }.from("\u26AB").to("\u26AA")
      end
    end
  end

  describe "#game_over?" do
    before do
      allow(setup_game).to receive(:tie).and_return(false)
      allow(setup_game).to receive(:current_marker).and_return("x")
    end

    it "calls won?" do
      board = setup_game.instance_variable_get(:@board)
      expect(board).to receive(:won?).with("x").once
      setup_game.send(:game_over?)
    end

    it "calls full?" do
      board = setup_game.instance_variable_get(:@board)
      expect(board).to receive(:full?).once
      setup_game.send(:game_over?)
    end
  end
end
