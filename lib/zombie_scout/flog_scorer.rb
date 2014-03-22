require 'flog'

module ZombieScout
  class FlogScorer
    def initialize(zombie, flog=nil)
      @zombie = zombie
      @flog = flog || Flog.new(methode: true, quiet: true, score: false)
    end

    def score
      raw_score.round(1)
    end

    private

    attr_reader :flog

    def raw_score
      all_scores = flog.flog(zombie_path)

      # default to {} in case there is no score. (it's a 0)
      scores = all_scores.fetch(@zombie.full_name, {})

      flog.score_method(scores)
    end

    def zombie_path
      @zombie.location.sub(/\:\d+$/, '')
    end
  end
end
