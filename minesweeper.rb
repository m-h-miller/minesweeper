require 'byebug'

class Board

  attr_reader :bomb_coords, :grid
  BOMB_COUNT = 10

  def initialize
    @grid = Array.new(9) { Array.new(9) }
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
        self[[xindex, yindex]] = Tile.new([xindex, yindex])
      end
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


class Tile
  attr_accessor :status, :is_bomb, :neighbors, :pos

  def initialize(pos)
    @status = :hidden
    @is_bomb = false
    @pos = pos
    # @neighbors = @grid.each do |row|
    #   row.each do |column|
    #   end
    # end
  end

  def reveal
    @status = :revealed
  end

  def neighbors

  end

  def neighbor_bomb_count

  end

end
