class C4BoardScorer
  WIN_FLAG = 10000
  LOSE_FLAG = -WIN_FLAG

  # should these be configured state?
  WEIGHT = 10
  THREAT_VALUE = 8
  OPPORTUNITY_VALUE = 2
  OPENING_VALUE = 1

  def score(board, from_player_perspective)
    winner = board.winner
    return WIN_FLAG if winner == from_player_perspective
    return LOSE_FLAG if winner != from_player_perspective && winner != nil

    my_threats = board.threat_count_for(from_player_perspective)
    their_threats = board.threat_count_for(C4Board.opponent_of(from_player_perspective))
    threat_weight = (((my_threats - their_threats) * WEIGHT) * THREAT_VALUE)

    my_opportunities = board.opportunity_count_for(from_player_perspective)
    their_opportunities = board.opportunity_count_for(C4Board.opponent_of(from_player_perspective))
    opportunity_weight = (((my_opportunities - their_opportunities) * WEIGHT) * OPPORTUNITY_VALUE)

    my_openings = board.opening_count_for(from_player_perspective)
    their_openings = board.opening_count_for(C4Board.opponent_of(from_player_perspective))
    opening_weight = (((my_openings - their_openings) * WEIGHT) * OPENING_VALUE)

    threat_weight + opportunity_weight + opening_weight
  end

end