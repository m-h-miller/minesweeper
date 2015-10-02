require 'byebug'
BOMB_COUNT = 10
SIDE_SIZE = 9

class Board

  attr_reader :bomb_coords, :grid


  def initialize
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
        elsif y.status == :revealed
          print "_ "
        elsif y.status == :flagged
          print "F "
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

  def update(pos)
    adjacent_positions = self[pos].neighbors
    p adjacent_positions
    adjacent_positions = adjacent_positions.
    end
    adjacent_positions
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
    result.map { |pos| Tile.new(pos, @board)}

  end

  def neighbor_bomb_count

  end

end


class Game

  def initialize(player)
    @board = Board.new
    @player = player
  end

  def play
    until @board.won?
      pos = @player.choose_tile
      if !@board[pos].is_bomb && @board[pos].status == :hidden
        @board[pos].reveal
      elsif @board[pos].status == :revealed
        @player.choose_tile
      else
        return "You lose \n\nTo play again enter...."
      end
      @board.update(pos)
    end
    @board.render
    puts "You win the GAME!!!!!"
  end
end


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


# a = Board.new
# a.render
