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
        
        # feel for wall
            # if wall, pivot
            # if no wall, feel for enemy

        # Rest mode
        if @rest_mode
            warrior.rest!
            rest_until_healthy(16, warrior.health)
        
        # Attack mode
        else      
            if warrior.feel.wall?
                warrior.pivot!
            else 
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
        end

        @health = warrior.health

    end
end
