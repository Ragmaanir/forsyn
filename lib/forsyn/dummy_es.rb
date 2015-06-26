require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  p req.body.read
  ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
end

Rack::Handler::WEBrick.run app, :Port => 9200
