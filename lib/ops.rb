require 'ops/config'
require 'ops/version'

require 'ops/server'

module Ops
  class << self
    def new
      Server.new
    end
  end
end

