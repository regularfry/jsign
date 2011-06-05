require 'rake/testtask'

Rake::TestTask.new do |t|
  t.verbose=true
  t.test_files = FileList["test/**/test_*.rb"]
  t.libs << "."
end

desc "Build the gem"
task :gem do
  sh "gem build jsign.gemspec"
end

namespace :test do
  desc "Make a silly-short keypair with no keyphrase for use in testing."
  task :dummy_keypair do
    sh "openssl genrsa -out test/dummykey.pem 512"
    sh "openssl rsa -in test/dummykey.pem -pubout -out test/dummypub.pem"
  end
end
