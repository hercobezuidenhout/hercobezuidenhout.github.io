# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-hercobezuidenhout"
  spec.version       = "0.1.6"
  spec.authors       = ["hercobezuidenhout"]
  spec.email         = ["herco.bezuidenhout@gmail.com"]

  spec.summary       = "A theme used for hercobezuidenhout.com"
  spec.homepage      = "https://github.com/hercobezuidenhout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "webrick", "~> 1.7.0"
  spec.add_runtime_dependency "jekyll-redirect-from", "~> 0.16.0"
end
