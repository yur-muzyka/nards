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

  def set_condition(condition_array)
    condition = ''
    condition_array.each do |point|
      condition << "#{'%02d' % point[0]}#{point[1]}-"
    end
    self.condition = condition
    self.save
  end

  def get_moves
    temp_moves = self.move.split('-')
    moves_array = []
    temp_moves.each_with_index do |move, index|
      moves_array[index] = [move[0..1].to_i, move[2..3].to_i]
    end
    return moves_array
  end

  def set_moves(moves_array)
    moves = ''
    moves_array.each do |move|
      moves << "#{'%02d' % move[0]}#{'%02d' % move[1]}-"
    end
    self.move = moves
    self.save
  end

  def moves_possible
    moves_possible = []
    moves_possible[0], moves_possible[1] = self.dice.divmod(10)
    if moves_possible[0] == moves_possible[1]
      moves_possible[2..3] = moves_possible[0], moves_possible[0]
    end
    moves_possible
  end

  def moves_done_pending
    moves_done = []
    moves_array = self.get_moves
    moves_array.each do |move|
      moves_done << (move[1] - move[0])
    end
    moves_done
  end

  def moves_done
    moves_done = self.moves_done_pending
    if moves_done[-1] <= 0
    moves_done.delete_at(-1)
    end
    moves_done
  end

  def move_pending
    if self.moves_done_pending[-1] <= 0
      moves_done.delete_at(-1)
    return true
    end
    return false
  end

  def delete_elements(array1, array2)
    array2.each do |item|
      index = array1.index item
      array1.delete_at index if index
    end
    array1
  end
  
  def dice_left
    moves_left= self.moves_possible
    moves_done = self.moves_done

    delete_elements(moves_left, moves_done)
  end

  def all_move_points(color)
    temp_condition = self.condition.split('-')
    condition_array = []
    temp_condition.each do |point|
      if point[2] == color
        condition_array << [point[0..1].to_i, point[2]]
      end
    end
    return condition_array
  end

  def flash_from_array(color)
    moves_from_to = []
    all_moves = all_move_points(color)
    dice_arr = dice_left   #
    all_moves.each do |move|
      dice_arr.each do |dice|
        moves_from_to << [move[0], move[0] + dice]
      end
    end
    occupy_points_clean(moves_from_to.uniq)
  end
  
  def occupy_points_clean(flash_array)
    flash_array.each_with_index do |flash, index| 
      get_condition.each do |cond|
        if flash[1] == cond[0]
          flash_array.delete_at(index)
        end
      end
    end
    flash_array
  end
  
end
