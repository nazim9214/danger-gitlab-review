module Danger
  class DangerGitlabReview < Plugin
    attr_accessor :my_attribute

    def new_random(seed)
      Random.new(Digest::MD5.hexdigest(seed).to_i(16))
    end

    def random_select(rng, review_id, reviewers, blacklist, max_reviewers)
      possible_reviewers = reviewers.select { |k, _| !blacklist.include? k }
      possible_reviewers.sample(max_reviewers, random: rng)
    end

    def random(max_reviewers = 2, maintainers = [], user_reviewers = [], user_blacklist = [], label = nil, maintainers_reviewers_count = 1)

      if gitlab.mr_title.include? "#no_roulette"
        return
      end

      review_id = gitlab.mr_json['project_id'].to_s + gitlab.mr_json['iid'].to_s
      review_seed = gitlab.mr_title.scan(/#roulette\d{1,9}/).last
      if review_seed
        review_id += review_seed
      end

      rng = new_random(review_id)
      user_blacklist << gitlab.mr_author
      maintainer_reviewers = random_select(rng, review_id, maintainers, user_blacklist, maintainers_reviewers_count)
      user_blacklist.concat maintainer_reviewers
      reviewers = (maintainer_reviewers.concat random_select(rng, review_id, user_reviewers, user_blacklist, max_reviewers)).take(max_reviewers)

      if reviewers.count > 0
        reviewers = reviewers.map { |r| '@' + r }
        result = format('Suggested reviewer%s: %s', reviewers.count > 1 ? 's' : '', reviewers.join(', '))

        if label
          result = format('[ %s ] %s', label, result)
        end

        markdown result
      end

    end
  end
end
