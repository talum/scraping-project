require 'nokogiri'
require 'open-uri'

html = open("http://flatironschool.com")
doc = Nokogiri::HTML(html)

puts doc.css('.grey-text').text