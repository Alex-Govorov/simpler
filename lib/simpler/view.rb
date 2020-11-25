require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template&.values&.first || [controller.name, action].join('/')

      @env['simpler.render'] = "#{path}.#{template_type}.erb"
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.#{template_type}.erb")
    end

    def template_type
      template&.keys&.first || 'html'
    end
  end
end
