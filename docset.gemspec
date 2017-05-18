# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docset/version'

Gem::Specification.new do |spec|
  spec.name          = "docset"
  spec.version       = Docset::VERSION
  spec.authors       = ["siman-man", "Seiei Miyagi"]
  spec.email         = ["k128585@ie.u-ryukyu.ac.jp", "hanachin@gmail.com"]

  spec.summary       = %q{a library for docset generation}
  spec.homepage      = "https://github.com/yasslab/docset"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "nokogiri", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
