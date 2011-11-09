require './lib/stat'
require 'uri'
require 'logger'

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

get '/' do
  @stats = Stat.all

  haml :index
end
