require 'active_support/core_ext'
require 'json'
require 'webrick'
require 'rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class UserController < ControllerBase
  def index
    users = ["u1", "u2", "u3"]

    render_content(users.to_json, "text/json")
  end

  def show
    flash[:errors] = ["hey a flash should appear"]
  end

end

class PostsController < ControllerBase
  def index
    users = ["u1", "u2", "u3"]

    render_content(users.to_json, "text/json")
  end

  def show
    flash[:errors] = ["hey a flash should appear"]
  end

end

class StatusController < ControllerBase
  def create
    render_content(params.to_s, "text/json")
  end

  def new
    page = <<-END
<form action="/" method="post">
<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>"
  <input type="text" name="cat[name]">
  <input type="text" name="cat[owner]">

  <input type="submit">
</form>
END

    render_content(page, "text/html")
  end

  def index

    render_content(params.to_s, "text/html")
  end
end

server.mount_proc '/' do |req, res|
  router = Router.new
  router.draw do
    get(Regexp.new("^/statuses$"), StatusController, :index) do
      get(Regexp.new("^/users$"), UserController, :new) do
        get(Regexp.new("^/posts$"), PostsController, :new)
      end
    end

    get Regexp.new("^/users$"), UserController, :index
    get Regexp.new("^/user/(?<id>\\d+)$"), UserController, :show

    # uncomment this when you get to route params
    get Regexp.new("^/statuses/(?<id>\\d+)$"), StatusController, :show
  end

  router.routes

  route = router.run(req, res)
end


server.start
