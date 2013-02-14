class Action < ActiveRecord::Base
  belongs_to :game
  def get_condition
    temp_condition = self.condition.split('-')
    condition_array = []
    temp_condition.each_with_index do |point, index|
      condition_array[index] = [point[0..1].to_i, point[2]]
    end
    return condition_array
  end

  def self.set_condition(id, condition_array)
    condition = ''
    action = self.find(id)
    condition_array.each do |point|
      condition << "#{'%02d' % point[0]}#{point[1]}-"
    end
    action.condition = condition
    action.save
  end

  def get_moves
    temp_moves = self.move.split('-')
    moves_array = []
    temp_moves.each_with_index do |move, index|
      moves_array[index] = [move[0..1].to_i, move[2..3].to_i]
    end
    return moves_array
  end

  def self.set_moves(id, moves_array)
    moves = ''
    action = self.find(id)
    moves_array.each do |move|
      moves << "#{'%02d' % move[0]}#{'%02d' % move[1]}-"
    end
    action.move = moves
    action.save
  end

  def moves_possible
    @moves_possible = []
    @moves_possible[0], @moves_possible[1] = self.dice.divmod(10)
    if @moves_possible[0] == @moves_possible[1]
    @moves_possible[2..3] = @moves_possible[0], @moves_possible[0]
    end
    @moves_possible
  end

  def moves_done
    moves_done = []
    @moves_array = self.get_moves
    @moves_array.each do |move|
      moves_done << (move[1] - move[0])
    end
    moves_done
  end

  def move_pending
    if self.moves_done[-1] <= 0
      moves_done.delete_at(-1)
    return true
    end
    return false
  end

  def moves_left
    @moves_left= self.moves_possible
    @moves_done = self.moves_done

    @moves_done.each do |item|
      index = @moves_left.index item
      @moves_left.delete_at index if index
    end
    @moves_left
  end
end
