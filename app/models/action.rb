class Action < ActiveRecord::Base
  belongs_to :game
  
  def delete_elements(array1, array2)
    array2.each do |item|
      index = array1.index item
      array1.delete_at index if index
    end
    array1
  end
  
  def get_condition
    temp_condition = condition.split('-')
    condition_hash = {}
    temp_condition.each_with_index do |point, index|
      condition_hash = condition_hash.merge({index => [point[0..1].to_i, point[2]]})
    end
    return condition_hash
  end

  def set_condition(condition_hash)
    condition = ''
    condition_hash.each do |key, val|
      condition << "#{'%02d' % val[0]}#{val[1]}-"
    end
    self.condition = condition
    self.save
  end

  def get_moves
    temp_moves = move.split('-')
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

  def dice_possible
    dice_possible = []
    dice_possible[0], dice_possible[1] = dice.divmod(10)
    if dice_possible[0] == dice_possible[1]
      dice_possible[2..3] = dice_possible[0], dice_possible[0]
    end
    dice_possible
  end

  def moves_done_pending
    moves_done = []
    moves_array = get_moves
    moves_array.each do |move|
      moves_done << (move[1] - move[0])
    end
    moves_done
  end

  def moves_done
    moves_done = moves_done_pending
    if moves_done.count > 0 && moves_done[-1] < 0
      moves_done.delete_at(-1)
    end
    moves_done
  end

  def move_pending
    if moves_done_pending[-1] <= 0
      moves_done.delete_at(-1)
    return true
    end
    return false
  end
  
  def dice_left
    moves_left= dice_possible
    moves_done = self.moves_done

    delete_elements(moves_left, moves_done)
  end

  def colour_points(colour)
    temp_condition = get_condition
    points = {}
    temp_condition.each do |k, v|
      if v[1] == colour
        points = points.merge(k => [v[0], v[1]])
      end
    end
    return points
  end

  def from_to_points(colour)
    moves_from_to = []
    all_moves = colour_points(colour)
    dice_arr = dice_left 
    all_moves.each do |k, v|
      dice_arr.each do |dice|
        moves_from_to << [k, k + dice]
      end
    end
    occupy_points_clean(moves_from_to.uniq, colour)
  end
  
  def occupy_points_clean(flash_array, colour)
    flash = []
    condition = get_condition
    flash_array.each_with_index do |fl, index| 
      if condition[fl[1]] && ((condition[fl[1]][1] == colour) || (condition[fl[1]][0] == 0)) 
        flash << fl
      elsif !condition[fl[1]]
        flash << fl
      end
    end
    return flash
  end
  
  def flash_from(colour)
    flash = get_condition
    from_to_points(colour).each do |point|
      flash[point[0]][2] = "f"
    end
    return flash
  end
  
end
