class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'tests/index'
  end

  def show
    @params = params
  end

  def create; end

  private

  def params
    @request.env['simpler.params']
  end
end
