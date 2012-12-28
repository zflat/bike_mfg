# http://www.ruby-forum.com/topic/142596
# https://exceptionz.wordpress.com/2008/08/19/execute-sql-within-rails-environment-without-using-your-models/
# http://jasonseifer.com/2010/04/06/rake-tutorial

namespace :db do
  namespace :bike_mfg do
    desc "Insert bike mfg seed data into database"
    task :seed => :environment do
        #Rake::Task["db:seed"].invoke
        puts "Rake task seed bike mfg data"
    end
  end
end


