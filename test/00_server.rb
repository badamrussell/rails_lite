require 'active_support/core_ext'
require 'webrick'
require 'rails_lite'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
   session["count"] ||= 0
   session["count"] += 1
   render :counting_show
  end

  def rego
    redirect_to("http://www.google.com")
  end
end
server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
