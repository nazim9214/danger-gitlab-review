module Danger
  class DangerGitlabReview < Plugin
    attr_accessor :my_attribute

    def new_random(seed)
      Random.new(Digest::MD5.hexdigest(seed).to_i(16))
    end

    def random_select(branch_name, reviewers, max_reviewers)
      randgen = roulette.new_random(branch_name)
      result = []
      max_reviewers.times do 
        result << reviewers[randgen(reviewers.length)]
      end
      result
    end

    def random(max_reviewers = 2, user_reviewers = [], user_blacklist = [])
      user_blacklist << gitlab.mr_author
      possible_reviewers = user_reviewers.select { |k, _| !user_blacklist.include? k }
      reviewers = random_select(gitlab.mr_json['source_branch'], possible_reviewers, max_reviewers)

      if reviewers.count > 0
        reviewers = reviewers.map { |r| '@' + r }
        result = format('Suggested reviewer%s: %s', reviewers.count > 1 ? 's' : '', reviewers.join(', '))
        markdown result
      end
    end
  end
end
