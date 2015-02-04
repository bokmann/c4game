desc "plays the game"
task :play, [:color] => :environment do |t, args|
  p = Player.new(C4BoardScorer.new, 4)
  b = C4Board.starting_board
  
  # move first if the player specified they want to play red
  if args[:color] == "red"
    b = b.move(p.best_move(b))
  end
  
  Displayer.display(b)
  until(b.won?) do
    STDOUT.flush
    move = STDIN.gets.chomp.to_i
    b = b.move(move)
    b = b.move(p.best_move(b))
    Displayer.display(b)
  end
  App.logger.info("#{b.winner} player won")
end