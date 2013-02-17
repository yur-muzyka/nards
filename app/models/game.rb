class Game < ActiveRecord::Base
  has_many :users, :foreign_key => "game_id"
  has_many :actions, :foreign_key => "game_id"
  
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
      condition_hash = condition_hash.merge({index => [point[0..1].to_i, point[2]] })
    end
    return condition_hash
  end
    
  def get_new_condition
    moves = get_moves
    new_condition = get_condition
    if moves.last && moves.last[1] == 0 
      moves.delete_at(-1)
    end        
    moves.each do |move|
      new_condition[move[0]][0] = new_condition[move[0]][0] - 1
      new_condition[move[1]][0] = new_condition[move[1]][0] + 1
      new_condition[move[1]][1] = new_condition[move[0]][1]
    end
    return new_condition
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
    if move 
      temp_moves = move.split('-')
    else 
      temp_moves = []
    end      
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

  def add_move(point)
    moves = get_moves
    if moves.last && moves.last[1] == 0 
      moves.last[1] = point
    else 
      moves << [point, 0]
    end
    set_moves(moves)
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
  
  def point_pending
     get_moves.last && get_moves.last[0]
  end

  def move_pending
    if moves_done_pending[-1] && moves_done_pending[-1] <= 0
      moves_done.delete_at(-1)
      return true
    end
    return false
  end
  
  def dice_left
    dice_all= dice_possible
    moves_done = self.moves_done
    done_include = []
    
    moves_done.each do |move|
      if move == (dice_all[0] + dice_all[1])
        done_include << dice_all[0]
        done_include << dice_all[1]
      elsif move == (dice_all[0] * 3)
        done_include << dice_all[0] << dice_all[0] << dice_all[0]
      elsif move == (dice_all[0] * 4)
        done_include << dice_all[0] << dice_all[0] << dice_all[0] << dice_all[0]
      else 
        done_include << move
      end
    end
    delete_elements(dice_all, done_include)
  end
  
  def moves_left
    moves = dice_left
    case moves.count
    when 2
      moves << moves[0] + moves[1]
    when 3
      moves << moves[0] * 2
      moves << moves[0] * 3
    when 4  
      moves << moves[0] * 2
      moves << moves[0] * 3
      moves << moves[0] * 4
    end
    moves.uniq
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
      # elsif !condition[fl[1]]
        # flash << fl
      end
    end
    return flash
  end
  
  def flash_from(colour)
    flash = get_new_condition
    from_to_points(colour).each do |point|
      flash[point[0]][2] = "f"
    end
    return flash
  end

  def flash_to
    point_from = point_pending
    condition = get_new_condition
    moves = moves_left
    moves.each do |move|
      if condition[point_from + move] && ((condition[point_from][1] == condition[point_from + move][1]) || 
            (condition[point_from + move][0] == 0)) 
        condition[point_from + move][2] = "t"
      end 
    end 
    condition
  end
  
  def opponent_id(id)
    users.each do |user|
      if user.id != id
        return user.id
      end
    end
  end
  
end
