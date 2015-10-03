require 'nokogiri'
require 'open-uri'
require 'pry'

html = open("https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/dan-berenholtz.html")
doc = Nokogiri::HTML(html)

binding.pry

