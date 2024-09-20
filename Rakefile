require 'yard'

YARD::Rake::YardocTask.new do |t|
end

desc 'execute irb for sf_cli'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r sf_cli/console --noscript #{args.target_org}"
end
