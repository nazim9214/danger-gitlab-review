require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerGitlabReview do
    it "should be a plugin" do
      expect(Danger::DangerGitlabReview.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.gitlab_review
        allow(@my_plugin.gitlab.mr_author).return('testuser')
      end
    end
  end
end
