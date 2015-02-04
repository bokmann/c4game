class C4Board
  attr_reader :cells
  attr_reader :player
  attr_reader :history

  HEIGHT = 6
  WIDTH = 7

  BLACK = :black
  RED = :red
  EMPTY = nil

  # precomputed every possible winning line combination.
  WINNING_LINES = [
    # verticals |
    [[0,0],[0,1],[0,2],[0,3]],
    [[1,0],[1,1],[1,2],[1,3]],
    [[2,0],[2,1],[2,2],[2,3]],
    [[3,0],[3,1],[3,2],[3,3]],
    [[4,0],[4,1],[4,2],[4,3]],
    [[5,0],[5,1],[5,2],[5,3]],
    [[6,0],[6,1],[6,2],[6,3]],

    [[0,1],[0,2],[0,3],[0,4]],
    [[1,1],[1,2],[1,3],[1,4]],
    [[2,1],[2,2],[2,3],[2,4]],
    [[3,1],[3,2],[3,3],[3,4]],
    [[4,1],[4,2],[4,3],[4,4]],
    [[5,1],[5,2],[5,3],[5,4]],
    [[6,1],[6,2],[6,3],[6,4]],

    [[0,2],[0,3],[0,4],[0,5]],
    [[1,2],[1,3],[1,4],[1,5]],
    [[2,2],[2,3],[2,4],[2,5]],
    [[3,2],[3,3],[3,4],[3,5]],
    [[4,2],[4,3],[4,4],[4,5]],
    [[5,2],[5,3],[5,4],[5,5]],
    [[6,2],[6,3],[6,4],[6,5]],

    # diagonals /
    [[0,2],[1,3],[2,4],[3,5]],

    [[0,1],[1,2],[2,3],[3,4]],
    [[1,2],[2,3],[3,4],[4,5]],

    [[0,0],[1,1],[2,2],[3,3]],
    [[1,1],[2,2],[3,3],[4,4]],
    [[2,2],[3,3],[4,4],[5,5]],

    [[1,0],[2,1],[3,2],[4,3]],
    [[2,1],[3,2],[4,3],[5,4]],
    [[3,2],[4,3],[5,4],[6,5]],

    [[2,0],[3,1],[4,2],[5,3]],
    [[3,1],[4,2],[5,3],[6,4]],

    [[3,0],[4,1],[5,2],[6,3]],

    # horizontals -
    [[0,0],[1,0],[2,0],[3,0]],
    [[0,1],[1,1],[2,1],[3,1]],
    [[0,2],[1,2],[2,2],[3,2]],
    [[0,3],[1,3],[2,3],[3,3]],
    [[0,4],[1,4],[2,4],[3,4]],
    [[0,5],[1,5],[2,5],[3,5]],

    [[1,0],[2,0],[3,0],[4,0]],
    [[1,1],[2,1],[3,1],[4,1]],
    [[1,2],[2,2],[3,2],[4,2]],
    [[1,3],[2,3],[3,3],[4,3]],
    [[1,4],[2,4],[3,4],[4,4]],
    [[1,5],[2,5],[3,5],[4,5]],

    [[2,0],[3,0],[4,0],[5,0]],
    [[2,1],[3,1],[4,1],[5,1]],
    [[2,2],[3,2],[4,2],[5,2]],
    [[2,3],[3,3],[4,3],[5,3]],
    [[2,4],[3,4],[4,4],[5,4]],
    [[2,5],[3,5],[4,5],[5,5]],

    [[3,0],[4,0],[5,0],[6,0]],
    [[3,1],[4,1],[5,1],[6,1]],
    [[3,2],[4,2],[5,2],[6,2]],
    [[3,3],[4,3],[5,3],[6,3]],
    [[3,4],[4,4],[5,4],[6,4]],
    [[3,5],[4,5],[5,5],[6,5]],

    # diagonals \
    [[0,3],[1,2],[2,1],[3,0]],

    [[0,4],[1,3],[2,2],[3,1]],
    [[1,3],[2,2],[3,1],[4,0]],

    [[0,5],[1,4],[2,3],[3,2]],
    [[1,4],[2,3],[3,2],[4,1]],
    [[2,3],[3,2],[4,1],[5,0]],

    [[1,5],[2,4],[3,3],[4,2]],
    [[2,4],[3,3],[4,2],[5,1]],
    [[3,3],[4,2],[5,1],[6,0]],

    [[2,5],[3,4],[4,3],[5,2]],
    [[3,4],[4,3],[5,2],[6,1]],

    [[3,5],[4,4],[5,3],[6,2]]
  ]

  CONCERNING_MAP = Hash.new
  0.upto(6) do |x|
    0.upto(5) do |y|
      CONCERNING_MAP[[x,y]] = WINNING_LINES.select { |l| l.include?([x, y]) }
    end
  end

  def self.opponent_of(player)
    player == BLACK ? RED : BLACK
  end

  def self.starting_board
    C4Board.new(Array.new(WIDTH) {Array.new(HEIGHT) { C4Board::EMPTY }}, C4Board::BLACK, [])
  end

  def initialize(cells, player, history)
    @cells = cells
    @player = player
    @history = history
  end

  def moves
    m = []
    return m if won?
    @cells.each_with_index do |row, x|
      m << x if row.index(EMPTY)
    end
    m
  end

  def move(x)
    return self if x.nil?
    new_cells = @cells.__deep_clone__

    y = new_cells[x].index { |c| c == EMPTY }
    new_cells[x][y] = @player
    C4Board.new(new_cells, @player == BLACK ? RED : BLACK, history + [x])
  end

  def won?
    return nil if CONCERNING_MAP[last_cell].nil?
    CONCERNING_MAP[last_cell].find do |line|
      winning_line?(line)
    end
  end

  def draw?
    won?.nil? && moves.empty?
  end

  def winner
    line = won?
    if line
      @cells[line[0][0]][line[0][1]]
    else
      EMPTY
    end
  end

  def last_cell
    return nil if @history.empty?
    [@history.last, @history.count(@history.last) - 1]
  end



  def threats_for(player)
    unrolled.select do |k, v|
      v.count(player) == 3 && v.count(C4Board.opponent_of(player)) == 0
    end.keys
  end

  def opportunities_for(player)
    unrolled.select do |k, v|
      v.count(player) == 2 && v.count(C4Board.opponent_of(player)) == 0
    end.keys
  end

  def openings_for(player)
    unrolled.select do |k, v|
      v.count(player) == 1 && v.count(C4Board.opponent_of(player)) == 0
    end.keys
  end

  def threat_count_for(player)
    threats_for(player).count
  end

  def opportunity_count_for(player)
    opportunities_for(player).count
  end

  def opening_count_for(player)
    openings_for(player).count
  end



  private

  def unrolled
    return @unrolled if @unrolled
    @unrolled = {}
    WINNING_LINES.each_with_index do |line, index|
      @unrolled[index] = line_to_values(line)
    end
    @unrolled
  end

  def line_to_values(line)
    [@cells[line[0][0]][line[0][1]],
      @cells[line[1][0]][line[1][1]],
      @cells[line[2][0]][line[2][1]],
      @cells[line[3][0]][line[3][1]]]
  end

  def winning_line?(line)
    (@cells[line[0][0]][line[0][1]] != EMPTY) &&
      (@cells[line[0][0]][line[0][1]] == @cells[line[1][0]][line[1][1]]) &&
      (@cells[line[0][0]][line[0][1]] == @cells[line[2][0]][line[2][1]]) &&
      (@cells[line[0][0]][line[0][1]] == @cells[line[3][0]][line[3][1]])
  end

end