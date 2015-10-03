require 'nokogiri'
require 'open-uri'
require 'pry'

html = open("https://learn-co-students.github.io/deploy-on-day-1-web-0915/")
doc = Nokogiri::HTML(html)

def all_students(doc)
   #searches the scraped info from page for student names
  all_names_with_links = doc.search('.big-comment h3 a')
  all_students_names = all_names_with_links.map do |element|
      element.text
    end
end

def create_student_hash(doc)
#creates basic structure with student names as keys 
  all_students = all_students(doc)
 #create a new hash with all the students names as keys, values are empty hash
  all_students.each_with_object({}) do |student_name, hash|
      hash[student_name] = {}
  end
end  

def students_links(doc)
  #Create hash for just the students and links, plus make exceptions
  #i.e. {"student_name" => "http://...", "student_name" => "http://"}
  new_hash = {}
  links = doc.search('.big-comment h3 a')
  links.each do |element|
      link_path = element.attr('href')
      new_hash[element.text] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/#{link_path}"
  end

  new_hash.each do |name, link|
    if name == "May Lee"
     new_hash[name] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/may_lee.html"
    elsif name == "Jeff Slutzky"
      new_hash[name] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/jeff_slutzky.html"
    end
  end
  new_hash
end

def add_links_to_hash(student_hash, doc)  
  #put the link for each student into the student hash 
  students_with_links = students_links(doc)
  students_with_links.each do |name, link|
    student_hash[name][:link] = link
  end  
  student_hash
end

def scrape_and_store_each_profile(doc)
  doc_hash = {}
  students_with_links = students_links(doc)
  students_with_links.map do |name, link|
    profile_html = open(link)
    profile_doc = Nokogiri::HTML(profile_html)
    doc_hash[name] = profile_doc
  end
  doc_hash
end

def populate_hash_with_profile(student_hash, html_hash, attribute, selectors)  
  #open the link for each student and grab selected element 
  html_hash.each do |name, html|
    value = html.search(selectors).text
    student_hash[name][attribute] = value
  end  
  student_hash
end

def populate_hash_with_bio(student_hash, html_hash)
  html_hash.each do |name, html|
    value = html.search('.services p').first.text
    student_hash[name][:bio] = value
  end  
  student_hash
end

def populate_hash_with_social(student_hash, html_hash, network, index)
  html_hash.each do |name, html|
    value = html.search('.social-icons a')[index].attr('href')
    student_hash[name][network] = value
  end  
  student_hash
end

def fill_student_hash(doc)
  students = create_student_hash(doc)
  add_links_to_hash(students, doc)   
  html_hash = scrape_and_store_each_profile(doc)
  populate_hash_with_profile(students, html_hash, :tagline, '.textwidget h3') #tagline
  populate_hash_with_bio(students, html_hash)   #bio
  populate_hash_with_social(students, html_hash, :github, 2)   #github
  populate_hash_with_social(students, html_hash, :twitter, 0)   #twitter
  populate_hash_with_social(students, html_hash, :linkedin, 1)   # linkedin
end


students = fill_student_hash(doc) 
puts "Welcome to the Flatiron School Web 0915. Which
student would you like to learn more about?" 
#other options: list all students. 
name = gets.chomp

#make sure that the hash has key. 
if students.has_key?(name)
  puts "Cool. You can view their tagline and bio, visit their profile on Flatiron School or see
them on github, twitter, or linkedin."
else
  puts "Sorry, don't recognize that name"  
end

#add option to switch from student to student. 
exit = false
until exit
  puts "Enter a command. Tagline, bio, profile, github, twitter, or linkedin. Exit to exit"
  command = gets.chomp.downcase
  case command
    when "tagline"
      puts students[name][:tagline]
    when "bio"
      puts students[name][:bio]
    when "profile"
      link = students[name][:link]
      system("open #{link}")
    when "github"
      link = students[name][:github]
      system("open #{link}")
    when "twitter"
      link = students[name][:twitter]
      system ("open #{link}")
    when "linkedin"
      link = students[name][:linkedin]
      system ("open #{link}")
    when "exit"
      exit = true
  end
end
puts "See ya!"
