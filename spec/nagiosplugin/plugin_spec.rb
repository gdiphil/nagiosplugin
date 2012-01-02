require "spec_helper"

describe NagiosPlugin::Plugin, '#status' do
  it "should be unknown by default"
  it "should be critical when checked as critical"
  it "should be warning when checked as warning"
  it "should be ok when checked as ok"
  it "should be unknown when an error was raised"
  it "should be unknwon when all checks return false"
end
