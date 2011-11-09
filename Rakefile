require 'rubygems'
require 'bundler'

Bundler.require

require 'uri'
require 'logger'
require './app'

task :environment do
  db = URI.parse(ENV['DATABASE_URL'] || 'sqlite3://./db/development.sqlite')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )

  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

task :migrate => :environment do
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Migrator.migrate("db/migrations")
end

task :cron => :environment do
  users = User.fetch
  users.save
end
