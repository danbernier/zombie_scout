require 'flog'

module ZombieScout
  class FlogScorer
    def initialize(zombie_location)
      @zombie_location = zombie_location
    end

    def score
      raw_score.round(1)
    end

    private

    def raw_score
      flog = Flog.new(methods: true, quiet: true, score:false)
      all_scores = flog.flog(zombie_path)
      method_locations = flog.instance_variable_get(:@method_locations)
      scores = all_scores.fetch(method_locations.invert.fetch(@zombie_location, {}), {})  # default to {} in case there is no score. (it's a 0)
      flog.score_method(scores)
    end

    def zombie_path
      @zombie_location.sub(/\:\d+$/, '')
    end
  end
end
