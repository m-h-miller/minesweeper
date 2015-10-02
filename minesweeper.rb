require 'byebug'

class Board

  attr_reader :bomb_coords
  BOMB_COUNT = 10

  def initialize
    @grid = Array.new(9) { Array.new(9){Tile.new()} }

    @bomb_coords = []
    place_bombs
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  # def []=(pos, val)
  #
  # end

  private
  def place_bombs
    until @bomb_coords.length == BOMB_COUNT
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      unless @bomb_coords.include?( [x, y] )
        @bomb_coords << [x, y]
      end
    end

    @bomb_coords.each do |pos|
      self[pos].is_bomb = true
    end
  end

end


class Tile
  attr_accessor :status, :is_bomb

  def initialize
    @status = :hidden
    @is_bomb = false
  end

  def reveal
  end

  def neighbors
  end

  def neighbor_bomb_count
  end

end
