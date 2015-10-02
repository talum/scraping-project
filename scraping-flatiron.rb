require 'nokogiri'
require 'open-uri'
require 'pry'

html = open("https://learn-co-students.github.io/deploy-on-day-1-web-0915/")
doc = Nokogiri::HTML(html)


def student_hash(doc)

  all_names_with_links = doc.search('.big-comment h3 a')
  all_students_names = all_names_with_links.map do |element|
      element.text
    end

 #create a new hash with all the students names as keys, values are empty hash
  all_students_names.each_with_object({}) do |student_name, hash|
      hash[student_name] = {}
  end
end  

def add_links_to_hash(student_hash, doc)  
  #put the link for each student into the student hash 
  links = doc.search('.big-comment h3 a')
  links.each do |element|
      link_path = element.attr('href')
      student_hash[element.text][:link] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/#{link_path}"
  end
  student_hash.map do |student_name, student_attributes|
    if student_name == "May Lee"
      student_hash[student_name][:link] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/may_lee.html"
    elsif student_name == "Jeff Slutzky"
      student_hash[student_name][:link] = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/jeff_slutzky.html"
    end
  end
  student_hash
end


def populate_hash_with_profile(student_hash, doc, attribute, selectors)  
  #open the link for each student and grab the social links
  new_link = nil
  links = doc.search('.big-comment h3 a')
  links.each do |element|
    link_path = element.attr('href')
    #puts "https://learn-co-students.github.io/deploy-on-day-1-web-0915/#{link_path}"
    if element.text == "May Lee"
      new_link = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/may_lee.html" 
    elsif element.text == "Jeff Slutzky"
      new_link = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/jeff_slutzky.html"
    else
      new_link = "https://learn-co-students.github.io/deploy-on-day-1-web-0915/#{link_path}"
    end
    profile_html = open(new_link)
    profile_doc = Nokogiri::HTML(profile_html)
    value = profile_doc.search(selectors).text
    student_hash[element.text][attribute] = value
   end  
  student_hash
end

#social github 
# def populate_hash_with_github(student_hash, attribute)
#    student_hash.each do |student_name, student_attributes|
#     binding.pry
#     profile_html = open(student_attributes[:link])
#     profile_doc = Nokogiri::HTML(profile_html)
#     binding.pry
#     value = profile_doc.search('.social-icons a').attr('href')[2]
#     student_hash[student_name][attribute] = value
#     binding.pry
#   end
#   student_hash
# end

def run(doc)
  students = student_hash(doc)
  students_with_links = add_links_to_hash(students, doc)
  result = populate_hash_with_profile(students_with_links, doc, :tagline, '.textwidget h3' )
  binding.pry
  #populate_hash_with_github(students_with_links, :github)
end

run(doc)

# student_hash = {"Dan Berenholtz" => {:link => "https://learn-co-students.github.io/deploy-on-day-1-web-0915/students/dan-berenholtz.html", 
#   :twitter => "http://www.twitter.com/", 
#   :github => "http://"}}






#ask user for input about student
# puts "Who would you like to learn more about?"
# name = gets.chomp



# system("open https://learn-co-students.github.io/deploy-on-day-1-web-0915/#{full_path}")




#div.big-comment h3 a
#use that information to grab the student's link on the page 


#then we open the student's profile on flatironschool.com
