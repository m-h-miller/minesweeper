require 'byebug'

class Board

  attr_reader :bomb_coords

  BOMB_COUNT = 10

  def initialize
    @grid = Array.new(9) { Array.new(9){Tile.new()} }

    @bomb_coords = []
    place_bombs
  end


  private

  def place_bombs
    until @bomb_coords.length == BOMB_COUNT
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      @bomb_coords << [x, y] unless @bomb_coords.include?( [x, y] )
    end
  end

end


class Tile
  def initialize(board)
    
  end

  def reveal
  end

  def neighbors
  end

  def neighbor_bomb_count
  end

end
