require 'spec_helper'
require 'zombie_scout/flog_scorer'

describe ZombieScout::FlogScorer do
  let(:full_name) { 'ClassName#method_name' }
  let(:method_score) { :whatever }
  let(:class_scores) {
    {full_name => method_score}
  }

  let(:zombie_path) { 'lib/foo.rb' }

  let(:flog) {
    flog = double(:flog)
    flog.stub(:flog).with(zombie_path).and_return(class_scores)
    flog.stub(:score_method).with(method_score).and_return(38.293)
    flog
  }
  let(:zombie) {
    double(:zombie, location: "#{zombie_path}:42", full_name: full_name)
  }

  it 'should call some methods on Flog, and round the result' do
    scorer = ZombieScout::FlogScorer.new(zombie, flog)
    expect(scorer.score).to eq(38.3)
  end
end
