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
            @rest = true
        else
            @rest = false
        end
    end


    def play_turn(warrior)
        
        @wizardcount ||= 0

        # Rescue mode
        if !captives_rescued?
            if warrior.feel.empty?
                warrior.walk!
            else
                warrior.rescue!
                @captives_rescued += 1
            end

        elsif @shoot && @wizardcount < 2
            warrior.shoot!
            @wizardcount += 1

        # Attack mode
        else      
            warrior.walk!
        end

        if warrior.look[1..2].any? {|x| !x.empty?}
            @shoot = true
        else 
            @shoot = false
        end

        @health = warrior.health

    end
end
