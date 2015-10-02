require 'byebug'

BOMB_COUNT = 10
SIDE_SIZE = 9

class Board
  attr_reader :bomb_coords, :grid

  def initialize
    #debugger
    @grid = Array.new(SIDE_SIZE) { Array.new(SIDE_SIZE) }
    populate
    @bomb_coords = []
    place_bombs
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end

  def populate
    @grid.each_with_index do |row, xindex|
      row.each_with_index do |tile, yindex|
        self[[xindex, yindex]] = Tile.new([xindex, yindex], self)
      end
    end
  end

  def render
    @grid.each do |x|
      puts "\n"
      x.each do |y|
        if y.status == :hidden
          print "* "
        elsif y.status == :flagged
          print "F "
        elsif y.status == :revealed

          if y.is_bomb
            print "X "
          elsif y.neighbor_bomb_count == 0
            print "_ "
          else
            print "#{y.neighbor_bomb_count} "
          end

        end
      end
    end
  end

  def won?
    @grid.each do |row|
      row.each do |tile|
        return false if (!tile.is_bomb && tile.status == :hidden)
      end
    end
    true
  end

  def game_over?
    @grid.each do |row|
      row.each do |tile|
        return true if (tile.is_bomb && tile.status == :revealed)
      end
    end
    false
  end

  def update(pos, flag = false)

    if flag
      if self[pos].status == :flagged
        self[pos].status == :hidden
      else
        self[pos].status = :flagged
      end
      return
    end

    neighbors = self[pos].neighbors

    # p self[pos].status
    self[pos].status = :revealed
    # p self[pos].status
    return if self[pos].neighbor_bomb_count > 0
    return if neighbors.all? do |n|
      # n.neighbor_bomb_count > 0 ||
      n.status == :revealed ||
      n.is_bomb
    end

    neighbors.each do |tile|
      next if tile.status == :revealed || tile.is_bomb
      update(tile.pos)
    end

  end

  private
  def place_bombs
    until @bomb_coords.length == BOMB_COUNT
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      @bomb_coords << [x, y] unless @bomb_coords.include?( [x, y] )
    end

    @bomb_coords.each do |pos|
      self[pos].is_bomb = true
    end
  end
end

###

class Tile
  attr_accessor :status, :is_bomb, :neighbors, :pos, :board

  def initialize(pos, board)
    @status = :hidden
    @is_bomb = false
    @pos = pos
    @board = board
  end

  def reveal
    @status = :revealed
  end

  def neighbors
    x, y = pos[0], pos[1]
    result = [
      [x+1, y+1],
      [x+1, y-1],
      [x+1, y],
      [x-1, y+1],
      [x-1, y-1],
      [x-1, y],
      [x, y+1],
      [x, y-1]
    ].reject do |pos|
      (pos[0] < 0 || pos[0] >= SIDE_SIZE) ||
      (pos[1] < 0 || pos[1] >= SIDE_SIZE)
    end
    result.map { |pos| @board[pos]}

  end

  def neighbor_bomb_count
    count = 0
    self.neighbors.each do |tile|
      count += 1 if tile.is_bomb
    end

    count
  end

end

###

class Game
  attr_accessor :board

  def initialize(player)
    @board = Board.new
    @player = player
  end

  def play
    puts "Welcome to Minesweeper"


    until @board.won? || @board.game_over?
      @board.render
      pos = @player.choose_tile
      # until board.valid_move?(pos)
      #   puts "That position is invalid, enter a new one"
      #   pos = @player.choose_tile
      # end
      @board.update(pos)
    end
    @board.render
    @board.won? ? (puts "You win the GAME!!!!!") : (puts "YOU LOST!!!!")
  end
end

###

class Player

  def initialize(name = "Player")
    @name = name
  end

  def choose_tile
    puts "Enter an x coordinate:"
    x = gets.chomp.to_i
    until x >= 0 || x <= 8
      puts "Invalid coordinate, try again:"
      x = gets.chomp.to_i
    end

    puts "Same with y:"
    y = gets.chomp.to_i
    until y >= 0 || y <= 8
      puts "Invalid coordinate, try again:"
      y = gets.chomp.to_i
    end

    [x, y]
  end

end


a = Board.new
# p a[[0,0]].neighbors.each {|n| print n.class}
# a.render
a.update([0,0])
a.render
# a.render
# b = Game.new(Player.new)
# b.play
