require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    # @logger.info(env)
    @logger.formatter = proc do |_severity, datetime, _progname, msg|
      "#{datetime}
       #{msg}"
    end
    @logger.info(message(status, headers, env))
    [status, headers, body]
  end

  private

  def message(status, headers, env)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
     Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
     Parameters: #{env['simpler.params']}
     Response: #{status} #{txt(status)} [#{headers['Content-Type']}] #{env['simpler.render']}\n"
  end

  def txt(status)
    Rack::Utils::HTTP_STATUS_CODES[status]
  end
end
