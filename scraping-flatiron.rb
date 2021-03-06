require 'nokogiri'
require 'open-uri'
require 'pry'

html = open("https://learn-co-students.github.io/deploy-on-day-1-web-0915/")
DOC = Nokogiri::HTML(html)

def all_students
   #searches the scraped info from page for student names
  all_names_with_links = DOC.search('.big-comment h3 a')
  all_students_names = all_names_with_links.map do |element|
      element.text
    end
end

def create_student_hash
 #creates basic structure with student names as keys 
 #create a new hash with all the students names as keys, values are empty hash
  all_students.each_with_object({}) do |student_name, hash|
      hash[student_name] = {}
  end
end  

def students_links
  #Create hash for just the students and links, plus make exceptions
  #i.e. {"student_name" => "http://...", "student_name" => "http://"}
  new_hash = {}
  links = DOC.search('.big-comment h3 a')
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

def add_links_to_hash(student_hash)  
  #put the link for each student into the student hash 
  students_with_links = students_links
  students_with_links.each do |name, link|
    student_hash[name][:link] = link
  end  
  student_hash
end

def populate_hash(student_hash)
  students_with_links = students_links
  students_with_links.map do |name, link|
    profile_html = open(link)
    profile_doc = Nokogiri::HTML(profile_html)
    student_hash[name][:tagline] = profile_doc.search('.textwidget h3').text 
    student_hash[name][:bio] = profile_doc.search('.services p').first.text
    student_hash[name][:github] = profile_doc.search('.social-icons a')[2].attr('href')
    student_hash[name][:twitter] = profile_doc.search('.social-icons a')[0].attr('href')
    student_hash[name][:linkedin] = profile_doc.search('.social-icons a')[1].attr('href')  
  end
  student_hash
end

# def populate_hash_with_profile(student_hash, html_hash, attribute, selectors)  
#   #open the link for each student and grab selected element 
#   html_hash.each do |name, html|
#     value = html.search(selectors).text
#     student_hash[name][attribute] = value
#   end  
#   student_hash
# end

# def populate_hash_with_bio(student_hash, html_hash)
#   html_hash.each do |name, html|
#     value = html.search('.services p').first.text
#     student_hash[name][:bio] = value
#   end  
#   student_hash
# end

# def populate_hash_with_social(student_hash, html_hash, network, index)
#   html_hash.each do |name, html|
#     value = html.search('.social-icons a')[index].attr('href')
#     student_hash[name][network] = value
#   end  
#   student_hash
# end

def fill_student_hash
  students = create_student_hash
  add_links_to_hash(students)   
  populate_hash(students)
  #html_hash = scrape_and_store_each_profile(doc)
  #populate_hash_with_profile(students, html_hash, :tagline, '.textwidget h3') #tagline
  #populate_hash_with_bio(students, html_hash)   #bio
  #populate_hash_with_social(students, html_hash, :github, 2)   #github
  #populate_hash_with_social(students, html_hash, :twitter, 0)   #twitter
  #populate_hash_with_social(students, html_hash, :linkedin, 1)   # linkedin
end

def display_student_info(students)
#make sure that the hash has key. 
  quit = false
  until quit
    puts "Enter a student's name to learn more about him or her. Back to return to main menu."
    name = gets.chomp
    if students.has_key?(name)
      puts "Great. #{name} is awesome.
      Use these commmands: bio, tagline.
      Or visit them online by typing: profile, github, twitter, or linkedin.
      Type back to enter another student's name.
      Type exit to exit."
      call_student_attributes(students, name)
    elsif name == "back"
      ##escape the loop? 
      quit = true
    # elsif name == "exit"
    #   exit = true
    #   quit = true
    else
      puts "Sorry, don't recognize that name. Please check your spelling and try again."  
    end  
  end
end

def call_student_attributes(students, name)
  back = false
  until back
    puts "You are currently viewing #{name}'s information.' Type tagline, bio, profile, github, twitter, or linkedin. Back to return."
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
      when "back"
        ##escape the loop, ideally to prompt for another student's name.
        back = true
      # when "exit"
      #   exit = true
      #   quit = true
      #   back = true
      else
        puts "Sorry, don't recognize that command. Try again."
      end
    end
end

students = fill_student_hash
puts "Welcome to the Flatiron School Web 0915."

exit = false
puts "Learn more about our students."
until exit
  puts "Please enter a command. Type help to see a list of commands."
  navigate = gets.chomp.downcase
  case navigate
    when "help"
      puts "Here are your options. Type students to see a list of students. Or type info to learn more about each student. Exit to exit."
    when "students"
      puts students.keys
    when "info"
      display_student_info(students)
    when "exit"
      exit = true
    else
      puts "Sorry, don't recognize that command. Type help to see a full list."
  end
end

puts "See ya!"
