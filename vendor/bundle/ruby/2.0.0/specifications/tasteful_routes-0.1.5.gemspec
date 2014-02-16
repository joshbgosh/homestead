# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tasteful_routes"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Icelab", "Hugh Evans"]
  s.date = "2011-09-24"
  s.description = "An opinionated variation of the standard Rails\n                        RESTful routes that has singular member action URLs."
  s.email = "hugh@artpop.com.au"
  s.homepage = "http://github.com/icelab/tasteful-routes"
  s.require_paths = ["lib"]
  s.rubyforge_project = "tasteful_routes"
  s.rubygems_version = "2.0.3"
  s.summary = "An opinionated variation of the standard Rails RESTful routes that has singular member action URLs."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
  end
end
