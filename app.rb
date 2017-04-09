require 'faye/websocket'
require 'rack'
require_relative 'arduino'
require 'json'

static  = Rack::File.new(File.dirname(__FILE__) + "/accelerometer")

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    p [:open, ws.url, ws.version, ws.protocol]

    ws.onmessage = lambda do |event|
      begin
        json = JSON.parse(event.data)
        ArduinoLights.render_accelerometer_data(json)
      rescue => e
        p "Unable to parse json: #{e}"
      end
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
    if env["PATH_INFO"] == "/"
      static.call(env.update("PATH_INFO" => "/index.html"))
    else
      static.call(env)
    end
  end
end

def App.log(message) 
  puts "Message: #{message}"
end
