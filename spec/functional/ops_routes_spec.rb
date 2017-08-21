require 'spec_helper'

RSpec.describe 'routes', type: :controller do
  it 'renders a env page' do
    get '/ops/env'
    expect(last_response).to be_ok
  end

  it 'renders a version page' do
    get '/ops/version'
    expect(last_response).to be_ok
  end

  it 'renders a json version page' do
    get '/ops/version.json'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eql('application/json')
  end

  it 'renders a heartbeat page' do
    get '/ops/heartbeat'
    expect(last_response).to be_ok
  end
end
