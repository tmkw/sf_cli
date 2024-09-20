require 'yard'
require 'fileutils'

desc 'generate documents'
YARD::Rake::YardocTask.new do |t|
  t.options = ['--no-private'] if ENV['SFCLI_DOC'].nil?
  t.after = Proc.new do
    FileUtils.mv('doc', 'docs')
  end
end

desc 'execute irb for sf_cli'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r sf_cli/console --noscript #{args.target_org}"
end
