class Player

  	def play_turn(warrior)
    
	    all_direction = [:forward, :left, :right, :backward]
	    @captives_rescued ||= false
	    @enemies_bound ||= 0
	    @rest_mode ||= false
	    @health ||= warrior.health
	    @first_step ||= true


	    @enemy_direction ||= :forward
	    @enemy_direction = all_direction.find { |direction| warrior.feel(direction).enemy?}

	    
	    

	    # if getting hit, attack enemy (don't rest)

	    # walk towards space

	    # feel for enemy or captive
	    	# if captive, rescue!
	    	# if enemy, attack

	    # walk towards stairs

	    if !warrior.listen.select { |space| space.ticking? && space.captive? }.empty?
	    	if all_direction.any? {|direction| warrior.feel(direction).captive? }
	    		warrior.rescue!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    	elsif all_direction.any? { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? }
	    		warrior.walk!(all_direction.find { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? })
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    	end

		elsif @health > warrior.health
	    	warrior.attack!(all_direction.find { |direction| warrior.feel(direction).enemy?})

	    elsif @rest_mode
	    	warrior.rest!
	    	if warrior.health > 15
	    		@rest_mode = false
	    	end

	    elsif warrior.health < 8
	    	warrior.rest!
	    	@rest_mode = true

	    elsif !warrior.listen.empty?
	    	if all_direction.any? {|direction| warrior.feel(direction).enemy? }
	    		warrior.attack!(all_direction.find {|direction| warrior.feel(direction).enemy? })
	    	else
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.enemy? }))
	    	end

		else 
	    	warrior.walk!(warrior.direction_of_stairs)
	    	
	    end

	    @health = warrior.health

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

	    @enemies_bound ||= 0
	    @first_step = @enemies_bound == 3 ? false : true
	  
	  	@second_step ||= true

	    
	    @captive_direction ||= :forward
	    @rest ||= false
	    @health ||= warrior.health
	    

	    @is_enemy_near = all_direction.any? {|direction| warrior.feel(direction).enemy?} ? true : false
	    @enemy_direction = all_direction.find { |direction| warrior.feel(direction).enemy?}
	    @is_captive_near = all_direction.any? {|direction| warrior.feel(direction).captive?} ? true : false
	    @captive_direction = all_direction.find { |direction| warrior.feel(direction).captive?}
	    @are_captives_rescued ||= false
	    @number_of_enemies = all_direction.select { |direction| warrior.feel(direction).enemy?}.count
	    @are_all_enemies_bound = @number_of_enemies <= 1 ? true : false

	
=end