require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @params = Params.new(req, route_params)

    @req = req
    @res = res
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    #sets response status and header, 302 redirect
    return if @already_built_response
    @already_built_response = true
    @res["location"] = url
    @res.status = 302
    session.store_session(@res)
  end

  def render_content(content, type)
    return if @already_built_response
    @res.content_type = type
    @res.body = content
    @already_built_response = true

    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    contents = File.read "views/#{controller_name}/#{template_name}.html.erb"

    html_erb = ERB.new(contents).result(binding)

    render_content(html_erb, "text/html")
  end

  def invoke_action(name)
    self.send(name.to_sym)

    render name.to_sym unless @already_built_response
  end
end
