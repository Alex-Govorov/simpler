require_relative 'router/route'

module Simpler
  class Router
    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      @env = env
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']

      find_route_with_params(method, path) || find_route(method, path)
    end

    private

    def find_route_with_params(method, path)
      path_param = path.match(%r{(\/.*\/)(.*)})
      return if !path_param || path_param&.captures&.any?(&:empty?)

      route_path = Regexp.new path_param.captures.first
      param_value = path_param.captures.last
      route = find_route(method, route_path)
      param_key = route.path.match(/:(.*)/).captures.first.to_sym

      set_params(param_key, param_value)
      route

      # binding.irb
    end

    def find_route(method, path)
      @routes.find { |route| route.match?(method, path) }
    end

    def set_params(key, value)
      @env['simpler.params'] = { key => value }
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end
  end
end
