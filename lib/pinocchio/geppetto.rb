lib = File.join( File.dirname(__FILE__), 'README')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'logger'

class Pinocchio::Geppetto

  attr_accessor :wood_carve, :server_host, :server_port, :logger


  def self.wake_up
    @@me ||= Pinocchio::Geppetto.new

    yield @@me

    @@blue_fairy = Pinocchio::BlueFairy.new({
      host: @@me.server_host,
      port: @@me.server_port,
      logger: @@me.logger
    })
  end

  def self.carve
    @@me.wood_carve = Pinocchio::WoodenBoy.new
    @@blue_fairy.animate(wooden_boy: @@me.wood_carve)

    @@me.wood_carve
  end
end

# Geppetto.wake_up do |config|
#   config.logger = test_logger
#   config.server_host = 'localhost'
#   config.server_port = 3001
#   config.app = Pinocchio::Lie.new
#   config.server {|app, port| Pinocchio.run_default_server(app, port) }
# end
