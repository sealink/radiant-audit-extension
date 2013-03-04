# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-audit-extension"

Gem::Specification.new do |s|
  s.name = "radiant-audit-extension"
  s.version = RadiantAuditExtension::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = RadiantAuditExtension::AUTHORS
  s.email = RadiantAuditExtension::EMAIL
  s.homepage = RadiantAuditExtension::URL
  s.summary = RadiantAuditExtension::SUMMARY
  s.description = RadiantAuditExtension::DESCRIPTION

  ignores = if File.exist?('.gitignore')
              File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
            else
              []
            end
  s.files = Dir['**/*'] - ignores
  s.test_files = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]

  s.post_install_message = %{
Add this to your radiant project with:
config.gem 'radiant-audit-extension', :version => '~>#{RadiantAuditExtension::VERSION}'
}
end