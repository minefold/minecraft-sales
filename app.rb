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

class User < ActiveRecord::Base
  URL = "http://www.minecraft.net/stats"

  def self.fetch
    body = RestClient.get(URL)
    doc = Nokogiri::HTML(body)

    text = doc.css('p').find do |p|
      p.content =~ /registered users/ and
      p.content =~ /bought the game/
    end.text

    total_users = text.match(/([\d,]+) registered users/)[1]
    paid_users = text.match(/of which ([\d,]+) \(\d\d\.\d\d%\) have bought/)[1]

    stats = [total_users, paid_users].map do |amount|
      amount.gsub(',', '').to_i
    end

    new_with_stats(*stats)
  end

  def self.new_with_stats(total, paid)
    new(total: total, paid: paid)
  end

end


get '/' do
  @users = User.all.map {|user| [user.total, user.paid]}

  haml :index
end
