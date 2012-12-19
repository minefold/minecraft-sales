DB = Sequel.connect(ENV['DATABASE_URL'])
require 'json'
get '/' do
  erb :index
end

get '/sales.csv' do
  header = "day,sales\n"

  data = DB[:users].order(:at).reverse.limit(365 * 3).to_a
      .group_by {|row| row[:at].strftime("%d-%m-%y") }
      .map {|day, rows| [day, rows.map {|r| r[:total]}.max] }
      .sort_by {|a,b| a[0] <=> b[0] }
      .map {|row| row.join(',') }

  header + data.join("\n")
end
