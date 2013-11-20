require 'active_support/core_ext'

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name




    names = make_route_names
    base_url = "http://0.0.0.0.3000"
    controller_class::add_route(names, base_url)
  end

  def make_route_names
    name = controller_class.to_s.downcase
    name = name[0...(name.index("controller"))]
    #name = name.singularize
    path_prefixes = [ name, name.pluralize ]
    path_prefixes << "new_#{name}" if @action_name == :new
    path_prefixes << "edit_#{name}" if @action_name == :edit

    path_prefixes
  end

  def prefix_route(pre_pattern)
    pre_fix = pre_pattern.source[0..-2]
    post_fix = @pattern.source[1..-1]
    @pattern = Regexp.new(pre_fix + post_fix)
  end

  def matches?(req)
    return false unless pattern.match(req.path.to_s)
    req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
    m_obj = pattern.match(req.path.to_s)

    #http://localhost:8080/statuses/1
    route_options = {}
    m_obj.names.each do |n|
      route_options[n] = m_obj[n]
    end

    tempController = controller_class.new(req, res, route_options)
    tempController.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |pattern, controller_class, action_name, &block|
      #prefix = pattern.source

      add_route(pattern, http_method, controller_class, action_name)
      unless block.nil?
        block.call
        @routes.last.prefix_route(pattern)
      end
    end

  end

  def match(req)
    @routes.each do |r|
      return r if r.matches?(req)
    end
    nil
  end

  def run(req, res)
    route = match(req)

    if route
      puts "GOOD --- found route: #{route.action_name} #{route.pattern}"
      route.run(req, res)
      route
    else
      puts "BAD ---- no matches for #{req.request_uri.to_s}"
      res.status = 404
    end
  end

  def routes
    @routes.each do |route|
      puts "#{route.pattern.source.ljust(30)}    #{route.http_method.upcase}    #{route.controller_class.to_s.ljust(20)}    #{route.action_name}"
    end
  end
end
