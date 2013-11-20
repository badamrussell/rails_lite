# require "webrick"
#
# root = File.expand_path '~/public_html'
#
# server = WEBrick::HTTPServer.new {
#   Port: 8080,
#   DocumentRoot: root
# }
#
# server.mount_proc "/" do |req, res|
#   #req is a WEBrick::HTTPRequest
#   #res is a WEBrick::HTTPResponse
#   res.content_type = "text/text"
#   res.body = req.path
# end
#
#
#
# trap('INT') { server.shutdown }
#
# server.start