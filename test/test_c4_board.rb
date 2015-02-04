require 'helper'

class TestC4Board < Minitest::Should::TestCase

  should "know black's opponent is red" do
    assert_equal(:red, C4Board.opponent_of(:black))
  end

  should "know red's opponent is black" do
    assert_equal(:black, C4Board.opponent_of(:red))
  end

  context "with a new starting board" do
    setup do
      @board = C4Board.starting_board
    end

    should "have an empty history" do
      assert_equal([], @board.history)
    end

    should "have the black player to move first" do
      assert_equal(:black, @board.player)
    end

    should "have all the cells set to nil" do
      @board.cells.each do |x|
        x.each do |y|
          assert_equal(nil, y)
        end
      end
    end

    should "be able to make a move" do
      b = @board.move(3)
      assert_equal(:black, b.cells[3][0])
    end

    should "know it has 7 possible moves" do
      assert_equal(7, @board.moves.size)
    end

    should "know it hasn't been won" do
      assert_equal(nil, @board.won?)
    end

  end


  context "a board with one filled column" do

    setup do
      @board = C4Board.new([[nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [:black,:red,:black,:red,:black,:red],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil]], :black, [3])
    end

    should "should only have 6 possible moves" do
      assert_equal(6, @board.moves.size)
    end

  end


  context "a winning board" do
    setup do
      @board = C4Board.new([[nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [:black,:black,:black,:black,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil],
                       [nil,nil,nil,nil,nil,nil]], :red, [3])
    end

    should "know when a board has been won" do
      assert_equal([[3, 0], [3, 1], [3, 2], [3, 3]], @board.won?)
    end

    should "know who the board winner is" do
      assert_equal(:black, @board.winner)
    end
  end

  context "a board ending in a draw" do
    setup do
      @board = C4Board.new([[:red,:black,:red,:black,:red,:black],
                       [:red,:black,:red,:black,:red,:black],
                       [:black,:red,:black,:red,:black,:red],
                       [:black,:red,:black,:red,:black,:red],
                       [:red,:black,:red,:black,:red,:black],
                       [:red,:black,:red,:black,:red,:black],
                       [:red,:black,:red,:black,:red,:black]], :red, [3])
    end

    should "not have a winner" do
      assert_equal(nil, @board.winner)
    end

    should "know it is a draw" do
      assert(@board.draw?)
    end
  end

  context "an arbitrary board" do

    should "keep track of the last move" do
      b = C4Board.starting_board
      assert_equal([3,0], b.move(3).last_cell)
    end

  end

end