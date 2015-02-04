# whipped up in order to demo this to a 5th grade class.
# please forgive me.
# yes, the ugly yellow is on purpose, so it looks like the
# plastic from the toy.
class Displayer

  def self.display(board)
    unless board.history.last.nil?
      print "   ".colorize(:background => :yellow) * board.history.last
      print " v ".colorize(:background => :yellow)
      print "   ".colorize(:background => :yellow) * (6 - board.history.last)
      puts
    end

    (C4Board::HEIGHT - 1).downto(0) do |y|
      0.upto(C4Board::WIDTH - 1) do |x|
        print " ".colorize( :background => :yellow )
        print to_piece(board.cells[x][y]).colorize( :background => :yellow )
        print " ".colorize( :background => :yellow )
      end
      puts
    end
    
    puts " 0  1  2  3  4  5  6".colorize(:background => :yellow)
    
    if board.draw?
      puts "Game ended in a draw".colorize(:blue).colorize(:background => :yellow)
    elsif board.won?
      puts "#{board.winner} player wins".colorize(:blue).colorize(:background => :yellow)
    else
      puts "#{board.player} player to move".colorize(:blue).colorize(:background => :yellow)
    end
    nil
  end

  def self.to_piece(player)
    case player
      when C4Board::RED
        "O".colorize(:red)
      when C4Board::BLACK
        "O".colorize(:black)
      else
        "_"
    end
  end
end
