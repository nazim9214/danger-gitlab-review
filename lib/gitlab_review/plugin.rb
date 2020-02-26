module Danger
  class DangerGitlabReview < Plugin
    attr_accessor :my_attribute

    def new_random(seed)
      Random.new(Digest::MD5.hexdigest(seed).to_i(16))
    end

    def random_select(branch_name, reviewers, blacklist, max_reviewers)
      possible_reviewers = reviewers.select { |k, _| !blacklist.include? k }
      possible_reviewers.shuffle(random: new_random(branch_name)).take(max_reviewers)
    end

    def random(max_reviewers = 2, maintainers = [], user_reviewers = [], user_blacklist = [], label = nil, maintainers_reviewers_count = 1)
      user_blacklist << gitlab.mr_author
      maintainer_reviewers = random_select(gitlab.mr_json['source_branch'], maintainers, user_blacklist, maintainers_reviewers_count)
      user_blacklist.concat maintainer_reviewers
      reviewers = (maintainer_reviewers.concat random_select(gitlab.mr_json['source_branch'], user_reviewers, user_blacklist, max_reviewers)).take(max_reviewers)

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
