
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pinocchio/version"

Gem::Specification.new do |spec|
  spec.name          = "pinocchio"
  spec.version       = Pinocchio::VERSION
  spec.authors       = ["Antonio Carlos da Gra\xC3\xA7a Mota Dur\xC3\xA3o de Souza"]
  spec.email         = ["ac.desouza@gmail.com"]

  spec.summary       = %q{Pinocchio will answer your request as your current of future API. Even if he needs to lie.}
  spec.description   = %q{Pinocchio is a library to stubs an API when you can't, or want, to replace the network api you are using. It's first appearence was on a SPA that works as ATM for school canteens.}
  spec.homepage      = "https://github.com/acdesouza/pinocchio"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
