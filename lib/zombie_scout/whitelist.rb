module ZombieScout
  class Whitelist
    def initialize
      @whitelist = if File.exist?('.zombie_scout_whitelist')
                     File.read('.zombie_scout_whitelist')
                   else
                     []
                   end
    end

    def include?(zombie_full_name)
      @whitelist.include?(zombie_full_name)
    end
  end
end
