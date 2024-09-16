task :default => [:irb]

desc 'execute irb for sf_cli'
task :irb do
  system 'irb -r sf_cli/sf/console'
end
