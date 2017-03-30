require 'faye/websocket'
require 'rack'

static  = Rack::File.new(File.dirname(__FILE__))
#options = {:extensions => [PermessageDeflate], :ping => 5}

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    p [:open, ws.url, ws.version, ws.protocol]

    ws.onopen = lambda do |event|
      p "Opening!"
      ws.send("hello")
    end

    ws.onmessage = lambda do |event|
      p "I got a message"
      p event.data
      ws.send(event.data)
    end

    ws.onerror = lambda do |event|
      p [:error, event]
    end

    ws.onclose = lambda do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    ws.rack_response
  else
    static.call(env)
  end
end

def App.log(message) 
  puts "Message: #{message}"
end
