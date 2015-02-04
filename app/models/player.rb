class Player

  def initialize(scorer, max_depth)
    @scorer = scorer
    @max_depth = max_depth
  end

  def best_move(board)
    # figure out the scores for all the current possible moves.
    scores = calculate_move_scores(board, board.player, 0)
    board.moves[scores.index(scores.max)]
  end

  private

  # Intelligence in such a few lines of recursion.
  def calculate_move_scores(board, player, depth)
    # recursive base case. we're done if we've gone to max depth
    # or of there are no more moves to make.
    return [0] if (depth == @max_depth || board.moves.empty?)

    boards = board.moves.collect { |m| board.move(m) }
    scores = boards.map { |b| @scorer.score(b, player) }
    return scores if ((depth == 0) && (scores.include?(@scorer.class::WIN_FLAG)))

    next_scores = boards.collect { |b| calculate_move_scores(b, player, depth + 1).reduce(:+) }

    [scores, next_scores].transpose.map {|x| x.reduce(:+)}
  end
end