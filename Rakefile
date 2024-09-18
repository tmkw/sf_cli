require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'doc'
  rd.generator = 'hanna'
  rd.main = "README.rdoc"
  rd.title = "sf_cli"
  rd.rdoc_files.include("rdoc/README.rdoc", "CHANGELOG.md", "rdoc/*.rdoc", "lib/**/*.rb")
end

desc 'execute irb for sf_cli'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r sf_cli/sf/console --noscript #{args.target_org}"
end
