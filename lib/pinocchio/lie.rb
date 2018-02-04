class Pinocchio::Lie
  attr_accessor :url, :method, :params, :env, :response, :params_without_ignored

  def initialize(attrs = {})
    @method = attrs[:method]&.upcase
    @url    = attrs[:url]
    @params = attrs[:params]
    @ignorable_params = attrs[:ignorable_params] || []
    @envs   = attrs[:envs]
    @params_without_ignored = if @ignorable_params.nil? || @params.nil?
                                @params
                              else
                                @params.reject do |param_name, param_value|
                                  @ignorable_params.include? param_name
                                end
                              end

    @response = {
      code: attrs[:response][:code],
      content_type: attrs[:response][:content_type],
      body: attrs[:response][:body]
    } unless attrs[:response].nil?
  end

  def ==(other_lie)
    other_lie_params_without_ignored = other_lie.params.reject do |param_name, param_value|
      @ignorable_params.include? param_name
    end

    result = self.method == other_lie.method &&
      self.url == other_lie.url &&
      self.params_without_ignored == other_lie_params_without_ignored

    # p "=" * 20
    # p self
    # p self.params_without_ignored
    # p "== #{result}"
    # p other_lie
    # p other_lie_params_without_ignored
    # p "=" * 20
    result
  end
end
