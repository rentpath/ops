require 'ops/config'
require 'ops/version'
require 'ops/revision'
require 'ops/server'

module Ops
  class << self
    def new
      Server.new
    end
  end
end

