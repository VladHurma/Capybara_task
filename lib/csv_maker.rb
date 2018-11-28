# frozen_string_literal: true

require 'csv'

module CSV_maker
  def self.write_to_csv(content)
    CSV.open('./news.csv', 'wb') do |csv|
      csv << %w[Link Header Image Body]
      csv << content.shift(4) until content.empty?
    end
    puts 'CSV created successfull!'
  end
end
