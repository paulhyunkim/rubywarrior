class Player
 
  def play_turn(warrior)
    @warrior = warrior
    @max_health ||= @warrior.health
 
    orient_thyself
 
    feel_it_out
  end
 
  protected
 
  def feel_it_out
    if @spaces.empty?
      return move @stairward
    else
      @ticking = @spaces.find_index { |space| space.ticking? }
      @target = @ticking ? @spaces[@ticking] : @spaces.first
      @direction = @warrior.direction_of @target
      @distance = @warrior.distance_of @target
      @ahead = @warrior.look @direction
 
      return defuse if @ticking
      return clear
    end
  end
 
  ## SITUATION METHODS
 
  def defuse
    return bind             if @enemies.length > 1
    return bind @direction  if @enemies.length > 0 and @warrior.health < @max_health / 4
    return be_a_hero        if @ahead[0].captive?
    return move             if @ahead[0].empty? and (@ahead[1].captive? or @ahead[1].empty?)
    return heal             if @warrior.health < @max_health * 0.75 and @enemies.length == 0
    return move             if @ahead[0].empty?
    return bomb             if @ahead[0].enemy? and @ahead[1].enemy? and @warrior.health > 4 and (@ticking ? @distance > 2 : true)
    return attack           if @ahead[0].enemy?
  end
 
  def clear
    return bind             if @enemies.length > 1
    return heal             if @warrior.health < @max_health * 0.8 and @enemies.length == 0
    return be_a_hero        if @ahead[0].captive?
    return bomb             if @ahead[0].enemy? and @ahead[1].enemy? and @warrior.health > 4 and (@ticking ? @distance > 2 : true)
    return attack           if @ahead[0].enemy?
    return move
  end
 
  ## ACTION METHODS
 
  def bomb
    @warrior.detonate! @direction
  end
 
  def bind(enemy = nil)
    enemy ||= @enemies.map { |enemy| @warrior.direction_of enemy }.select { |enemy| enemy != @direction }.last
    @warrior.bind! enemy
  end
 
  def be_a_hero
    @warrior.rescue! @direction
  end
 
  def heal
    @warrior.rest!
  end
 
  def attack
    @warrior.attack! @direction
  end
 
  def move(direction = @direction)
    if not @spaces.empty? and @warrior.feel(direction).stairs?
      direction = @warrior.direction_of @empties.first
    end
    @warrior.walk! direction
  end
 
  ## HELPER METHODS
 
  def orient_thyself
    ## CONSTANTS
    @directions ||= [:forward, :backward, :left, :right]
 
    ## DYNAMIC
    @stairward = @warrior.direction_of_stairs
    @spaces = @warrior.listen.sort { |space| @warrior.distance_of space }
    @nearby = @directions.map { |direction| @warrior.feel direction }
    @empties = @nearby.select { |space| space.empty? and not space.stairs? }
    @enemies = @nearby.select { |space| space.enemy? }
  end
end