require 'sinatra/base'

module Demo
  class App < Sinatra::Base
    get '/' do
      "Hello, world. I'm a demo app."
    end

    get '/test' do
      'Still me, the demo app.'
    end
  end
end
