require 'version'

require 'logger'
require 'active_support/all'
#require 'goliath'

require 'forsyn/alert_state'
require 'forsyn/sample'
require 'forsyn/checker'
require 'forsyn/checkers/threshold_checker'
require 'forsyn/checkers/deviation_checker'
require 'forsyn/responder'
require 'forsyn/responders/stateful_responder'
#require 'forsyn/has_inputs'
#require 'forsyn/has_output'

module Forsyn

  mattr_reader :logger

  @@logger = Logger.new(STDOUT)

  # def initialize(logger: Logger.new(STDOUT))
  #   @logger = logger
  # end

  # class Endpoint < Goliath::API
  #   use Goliath::Rack::Params

  #   def response(env)
  #     params['data'].each do |_,msg|
  #       p msg
  #     end

  #     [200, {}, ""]
  #   end
  # end
end
