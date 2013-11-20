require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'
require_relative 'flash'
require_relative 'htmlHelper'
require 'ostruct'

class ControllerBase
  attr_reader :params
  include HTMLHelper

  def initialize(req, res, route_params = {})
    @params = Params.new(req, route_params)

    @req = req
    @res = res
  end

  def self.add_route(path_prefixes, base_url)
    path_prefixes.each do |name|
      define_method("#{name}_url") do |*ids|
        "#{base_url}/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
      end
      define_method("#{name}_path") do |*ids|
        "/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
      end
   end
 end

  def form_authenticity_token
    session.form_authenticity_token
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new
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
    if template_name.is_a?(Hash)

      contents = File.read "views/#{template_name[:partial]}.html.erb"
      temp_binder = OpenStruct.new(template_name[:locals])
      def temp_binder.render
        binding
      end

      html_erb = ERB.new(contents).result(temp_binder.render)
    else
      controller_name = self.class.to_s.underscore
      contents = File.read "views/#{controller_name}/#{template_name}.html.erb"

      html_erb = ERB.new(contents).result(binding)

      render_content(html_erb, "text/html")
    end
  end

  def invoke_action(name)
    self.send(name.to_sym)

    render name.to_sym unless @already_built_response
  end
end
