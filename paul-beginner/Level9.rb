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
        
        if @rest
            warrior.rest!
            rest_until_healthy(16, warrior.health)
        elsif warrior.health < 8
            if getting_hit?(warrior.health)
                warrior.walk!(:backward)
            else
                warrior.rest!
                rest_until_healthy(16, warrior.health)
            end
        elsif warrior.feel.enemy?
            warrior.attack!
        elsif @shoot
            warrior.shoot!
        elsif warrior.feel.empty? 
            warrior.walk!
        elsif warrior.feel.wall?
            warrior.pivot!
        elsif warrior.feel.captive?
            warrior.rescue!
        end

        if warrior.look[1..2].any? {|x| x.enemy?}
            @shoot = true
        else 
            @shoot = false
        end

        @health = warrior.health

    end
end
