class Pinocchio::BlueFairy
  def initialize(args)
    @host = args[:host]
    @port = args[:port]
    @logger = args[:logger]
  end

  def animate(wooden_boy:)
    @logger.info "Little puppet made of pine(#{wooden_boy}), wake. The gift of life is thine."
    @wooden_boy = wooden_boy

    unless responsive?
      @server_thread = Thread.new do
        require 'webrick'
        Rack::Handler::WEBrick.run(
          self,
          :Host => @host,
          :Port => @port,
          :AccessLog => [],
          :Logger => @logger
        )

        sleep 1
      end
      Timeout.timeout(60) { @server_thread.join(0.1) until responsive? }
    end

    @wooden_boy
  end

  # To avoid restart WEBrick every test method, but
  # make sure the Wooden Boy do not remember old lies
  def call(env)
    if env["PATH_INFO"] == "/__identify__"
      [200, {}, [self.object_id.to_s]]
    else
      @wooden_boy.call(env)
    end
  end

  private
  def responsive?
    return false if @server_thread && @server_thread.join(0)

    res = Net::HTTP.start(@host, @port) { |http| http.get('/__identify__') }

    if res.is_a?(Net::HTTPSuccess) or res.is_a?(Net::HTTPRedirection)
      return res.body == self.object_id.to_s
    end
  rescue SystemCallError
    return false
  end
end
