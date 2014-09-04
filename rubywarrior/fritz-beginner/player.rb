class Player
  attr_accessor :warrior

  def play_turn(warrior)
    @warrior = warrior
    # find out if he is safe
#    if  is_safe(warrior.health, @health)
      # if he's hurt, rest.  If not, walk forward.
#      is_hurt(warrior.health, 20) ? warrior.rest! : take_action
      take_action
      # why can't use warrior.max_health instead of 20, see warrior.rb and base.rb
#    else # not safe
      # if he's really hurt, run.  if not, walk forward.
#      is_hurt(warrior.health, 10) ? warrior.walk!(:backward) : take_action
#    end # not safe
    @health = warrior.health

  end #def play_turn

    def see_area(t)
      @z = Array.new
      tg = "nothing"
      r = 3
      dir = :forward
      t.each do |y| #check each direction
          @z = warrior.look(y)
          @z.reverse_each do |z|
            x = @z.index(z)
            #puts z.to_s
            #puts z.to_s == "Wizard"
            if ( z.to_s == "Wizard" || z.to_s == "Archer" || z.to_s == "Captive" )
              tg = z.to_s
              r = x
              dir = y
              puts tg, r, dir
            elsif (z.to_s == "Thick Sludge" ) && !(tg == "Wizard" || tg == "Archer")
              tg = z.to_s
              r = x
              dir = y
              puts tg, r, dir
            end #if
          end #@z.reverse_each
      end # t.each
      return [tg, r, dir]
 #     return t
    end #see_area


  def take_action
    target = see_area( [:backward, :forward] )
    if target[2] != :forward
      warrior.pivot!(target[2])
    elsif warrior.feel.wall?
      warrior.pivot!(set_dir)
    elsif is_safe(warrior.health, @health) && is_hurt(warrior.health, 20) && target[0] != "Wizard"
      warrior.rest!
    elsif warrior.feel.captive?
        warrior.rescue!
    elsif !warrior.feel.empty?
      warrior.attack!
    elsif target[0] == "Wizard" || target[0] == "Archer"
        if target[1] < 1 && !warrior.feel(:backward).wall?
          warrior.walk!( :backward )
        else
          warrior.shoot!
        end
    else warrior.feel.empty?
          warrior.walk!
    end #feel.captive?
  end #take_action

  def set_dir
    if warrior.feel(:left).empty?
      return :left
    elsif warrior.feel(:backward).empty?
      return :backward
    elsif warrior.feel(:right).empty?
      return :right
    else
      return :forward
    end #if
  end # set_dir

# detect if Fritz is hurt
  def is_hurt(nowHealth, maxHealth)
    return nowHealth < maxHealth
  end #is_hurt

# detect if Fritz is taking damage
  def is_safe(nowHealth, lastHealth)
# factor down with ternary operator
    if (lastHealth.nil?)
      lastHealth = 20
    end
    return nowHealth >= lastHealth
  end #is_healthy

end #class Player
