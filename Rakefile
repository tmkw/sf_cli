require 'yard'

desc 'generate documents'
YARD::Rake::YardocTask.new do |t|
  t.options = ['--no-private']
end

desc 'start developer console'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r sf_cli/console --noscript #{args.target_org}"
end
