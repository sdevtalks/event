require "octokit"
require "dotenv"

usage_description = 'USAGE: $ bundle exec ruby issue_creator.rb #{number} #{title}'
raise "An ordinal number of the event is not given.\n#{usage_description}" unless ARGV[0]
raise "A title of the event is not given.\n#{usage_description}"           unless ARGV[1]

number = ARGV[0].to_i
title  = ARGV[1]
repo = "sdevtalks/event"
issue_titles = [
  "##{number - 1} の振り返り",
  "##{number + 1} の会場決定",
  "##{number + 1} のイベントページ作成",
  "登壇者集め",
  "懇親会準備",
  "備品の確認と補充",
]
Dotenv.load
access_token = ENV["PERSONAL_ACCESS_TOKEN"]

client = Octokit::Client.new(access_token: access_token)

milestone_title = "##{number} 「#{title}」"
milestone_number = client.create_milestone(repo, milestone_title)[:number]

issue_titles.each do |issue_title|
  client.create_issue(repo, issue_title, nil, { milestone: milestone_number })
end
