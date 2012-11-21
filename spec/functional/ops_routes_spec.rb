require 'rspec'
require 'rack/test'
require 'spec_helper'
require 'json'

RSpec::Matchers.define :have_content_type do |content_type|
  CONTENT_HEADER_MATCHER = /^([A-Za-z]+\/[\w\-+\.]+)(;charset=(.*))?/

  chain :with_charset do |charset|
    @charset = charset
  end

  match do |response|
    _, content, _, charset = *content_type_header.match(CONTENT_HEADER_MATCHER).to_a

    if @charset
      @charset == charset && content == content_type
    else
      content == content_type
    end
  end

  failure_message_for_should do |response|
    if @charset
      "Content type #{content_type_header.inspect} should match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should match #{content_type.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    if @charset
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect}"
    end
  end

  def content_type_header
    last_response.headers['Content-Type']
  end
end

describe 'routes', :type => :controller do
  include Rack::Test::Methods

  it 'renders a version page' do
    get "/ops/version"
    last_response.should be_ok
  end

  it 'renders a json version page' do
    get "/ops/version.json"
    last_response.should be_ok
    last_response.should have_content_type('application/json').with_charset('utf-8')
  end

  it 'renders a heartbeat page' do
    get "/ops/heartbeat"
    last_response.should be_ok
  end

end