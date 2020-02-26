require 'json'
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
        json = File.read(File.dirname(__FILE__) + '/support/fixtures/gitlab_mr.json')
        allow(@my_plugin.gitlab).to receive(:mr_json).and_return(JSON.parse(json))
        allow(@my_plugin.gitlab).to receive(:mr_author).and_return('user3')
      end

      it "select random reviewer" do
        @my_plugin.random(3, [ 'user1', 'user2', 'user3' ], [ 'user1', 'user2', 'user3', 'user4' ], [], 'testlabel')
        output = @my_plugin.status_report[:markdowns].first.message
        expect(output).to_not be_empty
        expect(output).to include('testlabel')
        expect(output).to include('@user1')
        expect(output).to include('@user2')
        expect(output).to include('@user4')
        expect(output).not_to include('@user3')
      end

    end
  end
end
