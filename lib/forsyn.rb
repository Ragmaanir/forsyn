require 'logger'
require 'active_support'
require 'active_support/core_ext'
require 'rack'

require 'forsyn/version'
require 'forsyn/example_setup'
require 'forsyn/alert_state'
require 'forsyn/sample'
require 'forsyn/trigger'
require 'forsyn/triggers/threshold_based'
require 'forsyn/triggers/threshold_trigger'
require 'forsyn/triggers/deviation_trigger'
require 'forsyn/responder'
require 'forsyn/responders/immediate_responder'
require 'forsyn/responders/stateful_responder'
require 'forsyn/notifier'
require 'forsyn/notifiers/terminal_notifier'
#require 'forsyn/has_inputs'
#require 'forsyn/has_output'

require 'forsyn/streams/stream'
require 'forsyn/streams/filter'
require 'forsyn/streams/splitter'
require 'forsyn/streams/rate_limiter'
require 'forsyn/streams/change_detector'
require 'forsyn/streams/printer'
require 'forsyn/streams/sink'

module Forsyn

  mattr_reader :logger

  @@logger = Logger.new(STDOUT)

  def initialize(logger: Logger.new(STDOUT))
    @logger = logger
  end

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

# e = Forsyn::ExampleSetup.new

# e.analyze(OpenStruct.new(
#   "time"=>"2015-05-07 22:42:05 UTC",
#   "type"=>"machine.memory",
#   "total"=>8_176_716_000,
#   "used"=>7_284_544_000,
#   "free"=>892_172_000
# ))

# e.analyze(OpenStruct.new(
#   "time"=>"2015-05-07 22:42:05 UTC",
#   "type"=>"machine.memory",
#   "total"=>8_176_716_000,
#   "used"=>7_284_544_000,
#   "free"=>1_892_172_000
# ))

if !ENV['FORSYN_ENV'] == 'test'
  app = Proc.new do |env|
    req = Rack::Request.new(env)
    req.params['data'].each do |_,msg|
      p msg
    end

    ['200', {}, []]
  end

  Rack::Handler::WEBrick.run app, Port: 10001
end
