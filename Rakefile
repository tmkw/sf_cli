require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'doc'
  rd.generator = 'hanna'
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "CHANGELOG.md", "lib/**/*.rb")
end
