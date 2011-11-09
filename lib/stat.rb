require 'uri'

class Stat < ActiveRecord::Base
  URL = "http://www.minecraft.net/stats"

  def self.fetch!
    body = RestClient.get(URL)
    doc = Nokogiri::HTML(body)

    text = doc.css('p').find do |p|
      p.content =~ /registered users/ and
      p.content =~ /bought the game/
    end.text

    registered_users = text.match(/([\d,]+) registered users/)[1]
    paid_users = text.match(/of which ([\d,]+) \(\d\d\.\d\d%\) have bought/)[1]

    stats = [registered_users, paid_users].map do |amount|
      amount.gsub(',', '').to_i
    end

    new_with_user_numbers(*stats)
  end

  def self.new_with_user_numbers(registered, paid)
    new(registered: registered, paid: paid)
  end

  def to_gchart_data
    [registered, paid].to_json
  end

end
