require 'yard'
require 'fileutils'

desc 'generate documents'
YARD::Rake::YardocTask.new do |t|
  t.before = Proc.new do
    FileUtils.rm_rf('docs')
  end

  t.after = Proc.new do
    FileUtils.mv('doc', 'docs')
  end

  t.options = ['--no-private']
end

desc 'execute irb for sf_cli'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r sf_cli/console --noscript #{args.target_org}"
end
