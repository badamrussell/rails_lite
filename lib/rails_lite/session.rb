require 'json'
require 'webrick'

class Session
  @@form_authenticity_token = SecureRandom::urlsafe_base64(16)

  def initialize(req)
    @session = {}

    req.cookies.each do |name, value|
      if name == "_rails_lite_app"
        @session = JSON.parse(value)
        break
      end
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new("_rails_lite_app", @session.to_json)

    res.cookies << cookie
  end

  def form_authenticity_token
    @@form_authenticity_token
  end

  def set_authenticity_token
    @@form_authenticity_token = SecureRandom::urlsafe_base64(16)
  end
end
