class Player
    
    def captives_rescued?
        if @captives_rescued.nil?
            @captives_rescued = 0
        end
        if @captives_rescued > 0
            return true
        else
            return false
        end
    end
    
    def getting_hit?(health)
        @health ||= health
        
        if @health > health
            return true
        else
            return false
        end
    end
    
    def rest_until_healthy(targethealth, health)
        @targethealth = targethealth
        if @targethealth > health
            @rest_mode = true
        else
            @rest_mode = false
        end
    end


    def play_turn(warrior)
        
        # Rescue mode
        if !captives_rescued?
            if warrior.feel(:backward).empty?
                warrior.walk!(:backward)
            else
                warrior.rescue!(:backward)
                @captives_rescued += 1
            end
        
        # Rest mode
        elsif @rest_mode
            warrior.rest!
            rest_until_healthy(16, warrior.health)

        # Attack mode
        else      
            
            # Check health
            # If not healthy, flee/rest until adequate health
            # Otherwise, move/attack
            if warrior.health < 11
                if getting_hit?(warrior.health)
                    warrior.walk!(:backward)
                else
                    warrior.rest!
                    rest_until_healthy(16, warrior.health)
                end
            else 
                if warrior.feel.empty?
                    warrior.walk!
                else
                    warrior.attack!
                end
            end
        end

        @health = warrior.health
    end
end



=begin        
        if @health > warrior.health
            if warrior.feel.empty?
                if warrior.health > 10
                    warrior.walk!
                else
                    warrior.walk!(:backward)
                end
            else
                warrior.attack!
            end
        elsif @health == warrior.health && warrior.health < 17
            warrior.rest!
            
        else
            if warrior.feel.empty?
                warrior.walk!
            else
                warrior.attack!
            end
        end
        
        @health = warrior.health
    end
=end 
