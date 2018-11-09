
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tng/gtk/utils/version"

Gem::Specification.new do |spec|
  spec.name          = "tng-gtk-utils"
  spec.version       = Tng::Gtk::Utils::VERSION
  spec.authors       = ["José Bonnet"]
  spec.email         = ["jose.bonnet@icloud.com"]

  spec.summary       = %q{A small library with utility features for 5GTANGO Gatekeeper}
  spec.description   = %q{5GTANGO Gatekeeper has been developed and started to accumulate some technical debt, namely with repeated code. This utility adresses that debt by extrating the duplicated code.}
  spec.homepage      = "https://github.com/sonata-nfv/tng-gtk-utils"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata["allowed_push_host"] = "http://rubygems.org"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", '~> 0.12.0'
  
  spec.add_dependency 'redis', '~> 4.0'
end
