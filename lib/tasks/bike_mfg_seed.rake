# http://www.ruby-forum.com/topic/142596
# https://exceptionz.wordpress.com/2008/08/19/execute-sql-within-rails-environment-without-using-your-models/
# http://jasonseifer.com/2010/04/06/rake-tutorial

namespace :db do
  namespace :bike_mfg do
    desc "Insert bike mfg seed data into database"
    task :seed => :environment do
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
        end
      end

      puts "Task complete"
    end #     task :seed => :environment

    desc "Reset primary key indicies that may be out of sync to do data import"
    task :index_repair => :environment do
      ActiveRecord::Base.establish_connection
      %w[bike_brands bike_models].each do |table|
        begin
          puts ActiveRecord::Base.connection.execute("select max(id) from #{table}")
          puts ActiveRecord::Base.connection.execute("select setval('#{table}_id_seq', (select max(id) from #{table}))")
        rescue Exception => e  
          puts "exception executing statement"
          puts e.message  
        end
      end # each |table|
    end # task :index_repair
    
  end # namespace :bike_mfg
end # namespace :db





