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
      condition_hash = condition_hash.merge({index + 1 => [point[0..1].to_i, point[2]] })
    end
    return condition_hash
  end
    
  def get_new_condition(colour)
    moves = get_moves
    new_condition = get_condition
    if moves.last && moves.last[1] == 0 
      moves.delete_at(-1)
    end        
    moves.each do |move|
      if move[1] > 90 && colour == "b"
        new_condition[move[0]][0] = new_condition[move[0]][0] - 1
        new_condition[25][0] = new_condition[25][0] + 1  
      elsif move[1] > 90 && colour == "w"
        new_condition[move[0]][0] = new_condition[move[0]][0] - 1
        new_condition[26][0] = new_condition[26][0] + 1
      else
        new_condition[move[0]][0] = new_condition[move[0]][0] - 1
        new_condition[move[1]][0] = new_condition[move[1]][0] + 1
        new_condition[move[1]][1] = new_condition[move[0]][1]
      end
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
      if move[1] < move[0] && move[1] != 0
        move[1] = move[1] + 24
      elsif move[1] > 90
        moves_done << move[1] - 90
        next
      end
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
    moves_done = self.moves_done   # исправить 99
    done_include = []
    
    moves_done.each do |move|
      case dice_all.count
      when 2
        if move == (dice_all[0] + dice_all[1])
          done_include << dice_all[0]
          done_include << dice_all[1]
        else 
          done_include << move
        end
      when 4        
        if move == (dice_all[0] * 4)
          done_include << dice_all[0] << dice_all[0] << dice_all[0] << dice_all[0]
        elsif move == (dice_all[0] * 3)
          done_include << dice_all[0] << dice_all[0] << dice_all[0]
        elsif move == (dice_all[0] * 2)
          done_include << dice_all[0] << dice_all[0]
        else 
          done_include << move
        end
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
      if k == 25
        break
      end
      if v[1] == colour || v[0] == 0      # правил. надо потестить
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
        if (k + dice) > 24
          moves_from_to << [k, k + dice - 24]
        else
          moves_from_to << [k, k + dice]
        end
      end
    end
    occupy_points_clean(moves_from_to.uniq, colour)
  end
  
  def occupy_points_clean(flash_array, colour)
    flash = []
    condition = get_condition
    flash_array.each_with_index do |fl, index|
      if condition[fl[1]] && ((condition[fl[1]][1] == colour) || (condition[fl[1]][0] == 0) ||    # test string -> testing..
         (dom("w") && fl[1] >= 13)) && 
            (((fl[0] < fl[1]) && colour == "b") ||             # restriction to move throw the board end
            ( (fl[0] - 12.5) < 0 && (fl[1] - 12.5) < 0    && colour == "w") ||
            ( (fl[0] - 12.5) > 0 && (fl[1] - 12.5) > 0    && colour == "w") ||
            dom(colour)) 
        flash << fl
      end
    end
    return flash
  end
  
  def flash_from(colour)
    flash = get_new_condition(colour)
    from_to_points = self.from_to_points(colour)
    # return from_to_points
    if dom(colour)
      from_to_points = dom_from_points(from_to_points, colour)      
    end  
    from_to_points.each do |point|
      flash[point[0]][2] = "f"
    end
    first_move_check(flash, colour)
  end

  def dom_from_points(from_to_points, colour)
    from_to_points = clean_empty(from_to_points, colour)
    over_points = []
    new_points = []
    from_to_points.each do |point|
      if (colour == "b" && point[1] >= 2 && point[1] <= 6) || (colour == "w" && point[1] >= 14 && point[1] <= 18)
        over_points << point
      else
        new_points << point
      end
    end
    if over_points.count > 0 && new_points.count == 0
      new_points << over_points.min {|a,b| a[0] <=> b[0] }
    end
    new_points
  end
  
  def clean_empty(from_to_points, colour)
    clean_points = []
    new_condition = self.get_new_condition(colour)
    from_to_points.each do |point|
      if new_condition[point[0]][0] > 0
        clean_points << point
      end
    end
    clean_points
  end
  
  def first_move_check(flash_from, colour)
    moves = get_moves
    
    if move_count <= 2 && dice_possible[0] == dice_possible[1]
      count = 0
      moves.each do |m|
        if m[0] == 1 && colour == "b"
          count = count + 1
        elsif m[0] == 13 && colour == "w"
          count = count + 1
        end   
      end
      
      if count >= 2 && colour == "b" 
        flash_from[1].delete("f")
      elsif count >=2 && colour == "w"
        flash_from[13].delete("f")
      end
    else
      moves.each do |move|
        if move[0] == 1 && colour == "b"
          flash_from[1].delete("f")
        elsif move[0] == 13 && colour == "w"
          flash_from[13].delete("f")
        end       
      end
    end
    flash_from
  end

  def flash_to(colour)
    wrong_points = []
    point_from = point_pending
    condition = get_new_condition(colour)
    moves = moves_left
    out_moves = []
    last_point_move = []
# return moves[0]
    moves.each do |move|
      point_id = point_from + move              
      if point_id > 24
        point_id = point_id - 24
      end   
      if !(condition[point_id] && ((condition[point_from][1] == condition[point_id][1]) || 
            (condition[point_id][0] == 0))) && !dom(colour)     # dom added. need testing
        wrong_points << move
      end
      
      if dom(colour) && ((point_id == 1 && colour == "b") || (point_id == 13 && colour == "w"))
        last_point_move << move
      elsif dom(colour) && ((point_id >= 1 && point_id <= 6 && colour == "b") || (point_id >= 13 && point_id <= 18 && colour == "w"))
        out_moves << move
      end  
    end
    # return out_moves
    new_moves = correct_moves(moves, wrong_points)  # forbidden jump throw occupant points
    out_board_moves = false 
    if last_point_move.count > 0
      out_board_moves = true
    elsif out_moves.count > 0 && no_inner_moves(out_moves, new_moves) 
      









      
      # new_moves.count == out_moves.count
      out_board_moves = true
    end
    
    # if out_moves.count > 0 && out_moves.count < new_moves.count
      # clean_moves = delete_elements(new_moves, out_moves)
      # out_board_moves = false
    # end
    
    new_moves.each do |m|
      point_id = point_from + m              
      if point_id > 24
        point_id = point_id - 24
      end   
      if condition[point_id] && ((condition[point_from][1] == condition[point_id][1]) || 
            (condition[point_id][0] == 0)) &&
            ((point_from + m <= 24 && colour == "b") ||             # restriction to move throw the board end
            ( (point_from - 12.5) < 0 && (point_from + m - 12.5) < 0    && colour == "w") ||
            ( (point_from - 12.5) > 0 && (point_from + m - 12.5) > 0    && colour == "w")) 
            ## dom or no dom
        condition[point_id][2] = 't' 
      # elsif dom(colour) && ((point_id >= 1 && point_id <= 6 && colour == "b") || (point_id >= 13 && point_id <= 18 && colour == "w"))
        # out_moves << m
      end  
      # elsif dom(colour) && ((point_id >= 1 && point_id <= 6 && colour == "b") || (point_id >= 13 && point_id <= 18 && colour == "w"))
        # out_board_moves = true
      # end     
      
    end
    return condition, out_board_moves
  end
  
  def opponent_id(id)
    users.each do |user|
      if user.id != id
        return user.id
      end
    end
  end
  
  def first_move_generate
    id = rand(2)
    case id
    when 0
      self.first_move_id = users.first.id
      self.turn_user_id = users.first.id
    when 1
      self.first_move_id = users.last.id
      self.turn_user_id = users.last.id
    end
    self.save
  end
  
  def correct_moves(moves, wrong_points)
    moves = moves.sort
    wrong_points = wrong_points.sort
    if (moves.count == 3 && moves[0] != moves[1]) && wrong_points[0] == moves[0] && wrong_points[1] == moves[1]
      moves.delete_at(-1)
    elsif wrong_points.count > 0 && dice_possible[0] == dice_possible[1]
      moves.delete_if {|m| m >= wrong_points.min }
    end
    moves
  end
  
  def dom(colour)
    condition = get_new_condition(colour)
    colour_cond = {}
    condition.each do |k, v|
      if v[1] == colour && v[0] > 0
        case colour
        when "b"
          if !(k >= 19 && k <= 24) && k != 25 && k!= 26
            return false
          end
        when "w"
          if !(k >=7 && k <= 12) && k != 25 && k != 26
            return false
          end
        end    
      end
    end
    true
  end
  
  def move_ident(colour)
    if colour == "b"
      point_id = 25 - point_pending
    elsif colour == "w"
      point_id = 13 - point_pending
    end
    moves_left = self.moves_left
    moves_left.delete_if{|move| move < point_id}
    moves_left.min
  end
  
  def change_turn_check(colour, id)
    if dice_left.count == 0 && get_moves.count > 0 
      self.turn_user_id = opponent_id(id)
      set_condition(flash_from(colour))
      self.dice = (rand(6) + 1) *10 + rand(6) + 1
      self.move = ''
      self.move_count = self.move_count + 1 
      self.save
    end
  end
  
  def change_turn(colour, id)
      self.turn_user_id = opponent_id(id)
      set_condition(flash_from(colour))
      self.dice = (rand(6) + 1) *10 + rand(6) + 1
      self.move = ''
      self.move_count = self.move_count + 1 
      self.save
  end
  
  def no_moves(colour)
    flash_from = self.flash_from(colour)
    no_moves = true
    # get_moves.count
    1.upto(24) do |k|
      if flash_from[k][2] == "f" && flash_from[k][0] > 0
        no_moves = false
        break
      end
    end
    if no_moves == false
      return false
    elsif move_pending == true
      return false
    else 
      return true
    end 
  end
  
  def no_inner_moves(out_moves, new_moves)
    if dice_possible[0] == dice_possible[1]
      new_moves = [new_moves[0]]
    elsif new_moves.count == 3
      new_moves.delete_at(-1)
    end
    
    # case new_moves.length
    # when 3
      # new_moves.delete_at(-1)
    # when 4
      # new_moves = [new_moves[0]]
    # end
    if delete_elements(new_moves, out_moves).count > 0
      return false
    else
      return true
    end
  end
  
end
