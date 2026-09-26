require "rake/testtask"
require "bundler/gem_tasks"

desc "Default: run unit tests."
task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << "lib" << "test"
  t.test_files = Rake::FileList["test/**/*_test.rb"].exclude("test/integration/**/*_test.rb")
end

namespace :test do
  Rake::TestTask.new(:integration) do |t|
    t.libs << "lib" << "test"
    t.pattern = "test/integration/**/*_test.rb"
  end
end
