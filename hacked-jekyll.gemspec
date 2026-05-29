# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hacked-jekyll"
  spec.version       = "3.1.1"
  spec.authors       = ["piazzai"]
  spec.email         = ["hello@piazzai.addy.io"]

  spec.summary       = "Jekyll microtheme that looks like JSON"
  spec.homepage      = "https://github.com/piazzai/hacked-jekyll"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_data|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "github-pages", "~> 232"
end
