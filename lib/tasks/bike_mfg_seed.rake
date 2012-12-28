# http://www.ruby-forum.com/topic/142596
# https://exceptionz.wordpress.com/2008/08/19/execute-sql-within-rails-environment-without-using-your-models/
# http://jasonseifer.com/2010/04/06/rake-tutorial

namespace :db do
  namespace :bike_mfg do
    desc "Insert bike mfg seed data into database"
    task :seed => :environment do
      #Rake::Task["db:seed"].invoke
      puts "Rake task seed bike mfg data"
      ActiveRecord::Base.establish_connection

      fpath = File.join("#{File.dirname(__FILE__)}/../bike_mfg/db/seed/sql/bike_brands_and_models.sql")
      # get rid of comments from the file string
      # http://bytes.com/topic/javascript/answers/161908-regexp-strip-comments-css
      comment_pattern = /\/\*[\s\S]*?(\*\/)/ 

      sql_raw = File.open(fpath).read
      sql = sql_raw.gsub comment_pattern, ''

      sql.split(";").each do |sql_statement|
        begin
          puts sql_statement
          puts ActiveRecord::Base.connection.execute(sql_statement)
        rescue Exception => e  
          puts "exception executing statement"
          puts e.message  
          # puts e.backtrace.inspect
        end
      end
      puts "Task complete"
    end
  end
end


