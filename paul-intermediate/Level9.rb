class Player

  	def play_turn(warrior)
    
	    all_direction = [:forward, :left, :right, :backward]
	    @captives_rescued ||= false
	    @enemies_bound ||= 0
	    @rest_mode ||= false
	    @health ||= warrior.health
	    @first_step ||= true
	    @captives ||= 1

	    @enemy_direction ||= :forward
	    @enemy_direction = all_direction.find { |direction| warrior.feel(direction).enemy?}

	    # if there is a ticking captive
	 	if !warrior.listen.select { |space| space.ticking? && space.captive? }.empty?
	    	
	    	# rescues ticking captive if within feel
	    	if all_direction.any? {|direction| warrior.feel(direction).captive? && warrior.feel(direction).ticking? }
	    		warrior.rescue!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    	
	    	# binds enemies if not in direction of ticking captive
	    	elsif all_direction.select { |direction| warrior.feel(direction).enemy? }.count > 1
				warrior.bind!(all_direction.find { |direction| warrior.feel(direction).enemy? && direction !=warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? })})
	    	
			# attacks enemy if in direction of captive
	    	elsif warrior.feel(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? })).enemy?
	    		
	    		# attacks
	    		if warrior.distance_of(warrior.listen.find { |space| space.ticking? && space.captive? }) < 3
	    			warrior.attack!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    		
	    		# detonates
	    		else 
	    			warrior.detonate!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    		end

	    	# rests until 'healthy'
	    	elsif @rest_mode
		    	warrior.rest!
		    	if warrior.health > 12
		    		@rest_mode = false
		    	end

		    # if 'unhealthy', enters rest mode
		    elsif warrior.health < 8
		    	warrior.rest!
		    	@rest_mode = true

	    	# walks in direction that doesn't have enemy, wall, or stairs
=begin	    	elsif all_direction.any? { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? }
	    		warrior.walk!(all_direction.find { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? })
=end	    

	    	# walks to ticking captive
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    	end

	    # if there are any captives
	    elsif !warrior.listen.select { |space| space.captive? }.empty?
	    	
	    	# rescues captive if within feel
	    	if all_direction.any? { |direction| warrior.feel(direction).captive? }
	    		warrior.rescue!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    	
	    	# attack if enemy
	    	elsif all_direction.any? { |direction| warrior.feel(direction).enemy? }
	    		warrior.attack!(all_direction.find { |direction| warrior.feel(direction).captive? })

	    	# rests until 'healthy'
	    	elsif @rest_mode
		    	warrior.rest!
		    	if warrior.health > 9
		    		@rest_mode = false
		    	end

		    # if 'unhealthy', enters rest mode
		    elsif warrior.health < 6
		    	warrior.rest!
		    	@rest_mode = true

	    	# walks to captives
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.captive? }))
	    	
	    	end
	    
	    else 
	    	warrior.walk!(warrior.direction_of_stairs)

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

 if !warrior.listen.select { |space| space.ticking? && space.captive? }.empty?
	    	if all_direction.any? {|direction| warrior.feel(direction).captive? && warrior.feel(direction).ticking? }
	    		warrior.rescue!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    	elsif all_direction.select { |direction| warrior.feel(direction).enemy? }.count > 1
				warrior.bind!(all_direction.find { |direction| warrior.feel(direction).enemy? && direction !=warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? })})
	    	elsif warrior.feel(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? })).enemy?
	    		warrior.attack!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    	elsif all_direction.any? { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? }
	    		warrior.walk!(all_direction.find { |direction| !warrior.feel(direction).enemy? && !warrior.feel(direction).stairs? && !warrior.feel(direction).wall? })
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.ticking? && space.captive? }))
	    	end

	    elsif !warrior.listen.select { |space| space.captive? }.empty? && @captives == 1
	    	if all_direction.any? {|direction| warrior.feel(direction).captive? }
	    		warrior.rescue!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    		@captives -= 1
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.captive? }))
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

	    elsif !warrior.listen.select { |space| space.enemy? }.empty?
	    	if all_direction.any? {|direction| warrior.feel(direction).enemy? }
	    		warrior.attack!(all_direction.find {|direction| warrior.feel(direction).enemy? })
	    	else
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.enemy? }))
	    	end

	    elsif !warrior.listen.select { |space| space.captive? }.empty?
	    	if all_direction.any? {|direction| warrior.feel(direction).captive? }
	    		warrior.attack!(all_direction.find {|direction| warrior.feel(direction).captive? })
	    	else 
	    		warrior.walk!(warrior.direction_of(warrior.listen.find { |space| space.captive? }))
	    	end

		else 
	    	warrior.walk!(warrior.direction_of_stairs)
	    	
	    end

	    @health = warrior.health
	
=end