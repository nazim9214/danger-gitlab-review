module Danger
  class DangerGitlabReview < Plugin
    attr_accessor :my_attribute

    def random(max_reviewers = 2, user_reviewers = [], user_blacklist = [])
      user_blacklist << gitlab.mr_author
      reviewers = user_reviewers.select { |k, _| !user_blacklist.include? k }.sample(max_reviewers)

      if reviewers.count > 0
        reviewers = reviewers.map { |r| '@' + r }
        
        result = format('We identified %s to be reviewer%s.',
                        reviewers.join(', '), reviewers.count > 1 ? 's' : '')
        
        markdown result
      end
    end
  end
end
