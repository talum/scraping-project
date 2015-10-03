require 'nokogiri'
require 'open-uri'
require 'pry'

puts "What song would you like to play?"
​
song_name = gets.chomp
​
document = open("https://www.youtube.com/results?search_query=#{song_name}")
​
noko_document = Nokogiri::HTML(document)
​
first_hit = noko_document.search('h3.yt-lockup-title a.yt-uix-sessionlink').first
hits_link = first_hit.attr('href')
​
system("open http://www.youtube.com#{hits_link}")


# require 'nokogiri'
# require 'open-uri'
# require 'pry'


# puts "What song would you like to play?"
# song_name = gets.chomp
# document = open("https://www.youtube.com/results?search_query=#{song_name}").read

# noko_document = Nokogiri::HTML(document)
# #breaking string into a nokogiri object

# first_hit = noko_document.search('h3.yt-lockup-title a.yt-uix-session')
# #selecting, get as close to link as possible 

# hits_link = first_hit.attr('href')

# system("open https://www.youtube.com#{hits_link}")


#.attr('href')
#first_hit.methods 

#access bash from ruby using system('commnad')
