class Player

  	def play_turn(warrior)
    
	    all_direction = [:forward, :left, :right, :backward]
	    @enemydirection ||= :forward
	    @rest ||= false
	    @health ||= warrior.health
	    @enemydirection = all_direction.any? {|direction| warrior.feel(direction).enemy?} ? all_direction.find {|direction| warrior.feel(direction).enemy?} : nil

	    if @enemydirection
	    	warrior.attack!(@enemydirection)
	    else
	    	if warrior.health > 15
	    		warrior.walk!(warrior.direction_of_stairs)
	    	else
	    		warrior.rest!
	    	end
	    end
	end
end


=begin
	
how is health?
	if good
		where is enemy?
			if enemy is near, attack!
			if no enemy, walk!
	if bad
		where is enemy?
			if enemy is near, attack!
			if no enemy, rest!

	
=end