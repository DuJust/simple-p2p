require 'rspec/core/rake_task'

namespace :covered do
  desc 'Run tests with coverage check'
  task :on do
    ENV['COV'] = 'true'
  end

  desc 'Run tests without coverage check'
  task :off do
    ENV['COV'] = 'false'
  end
end

task spec: 'covered:on' do |t|
  t.enhance do
    Rake::Task['covered:off'].invoke
  end
end
