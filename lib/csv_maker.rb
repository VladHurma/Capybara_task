require 'csv'

module CSV_maker
	def self.write_to_csv(content)
		CSV.open("./news.csv", "wb") do |csv|
			csv << ['Link', 'Header', 'Image', 'Body']
			while !content.empty?
				csv << content.shift(4)
			end
		end
	puts "CSV created successfull!"
	end
end