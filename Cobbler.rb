require 'watir'
require 'nokogiri'

def linkedin(user, pass, company)
  browser = Watir::Browser.new :chrome
  browser.goto "https://www.linkedin.com"
  sleep(3)
  browser.text_field(:id, 'login-email').set(user)
  browser.text_field(:id, 'login-password').set(pass)
  browser.button(:text, "Sign in").click
  sleep(rand(5..10))
  base_url = "https://www.linkedin.com/search/results/people/?keywords=" + company
  browser.goto base_url
  sleep(rand(5..10))
  document = Nokogiri::HTML(browser.html)

  counter = 1

  loop do
    document = Nokogiri::HTML(browser.html)
    document.css("[class='name actor-name']").each { |name| $names << name.text }
    break if document.css("[class='search-no-results__container']").length > 0
    counter += 1
    browser.goto base_url + "&page=" + counter.to_s
    sleep(rand(5..10))
  end
end

def data_dot_com(user, pass, company)
  browser = Watir::Browser.new :chrome
  browser.goto "https://connect.data.com/login?source=HPTopNav"
  browser.wait
  browser.text_field(:id, 'j_username').set(user)
  browser.text_field(:id, 'j_password').set(pass)
  browser.button(:text, "Login").click
  browser.text_field(:id, 'homepageSBS').set(company)
  browser.send_keys :enter
  sleep(rand(5..10))
  document = Nokogiri::HTML(browser.html)

  company_links = document.css("[class='break-word companyName']")

  company_links.each_with_index {|link, index| puts "[#{index}] #{link.text}"}
  print "Choose company by index: "
  choice = $stdin.gets.chomp

  next_page = "https://connect.data.com" + company_links[choice.to_i]['href']
  browser.goto next_page
  browser.wait
  browser.link(:text =>"see all").wait_until_present.click
  sleep(rand(5..10))

  loop do
    document = Nokogiri::HTML(browser.html)
    document.css("td[class='td-name break-word name']").each do |x| 
    	last, first = x.text.tr("',", '').split[0..1]
    	$names << "#{first} #{last}"
    end
    break if document.css("[class='table-navigation-button-next table-navigation-image table-navigation-next-image-active']").length == 0
    browser.image(:id, 'next').click
    sleep(rand(5..10))
  end
end

def name_mangler(format_choice, output_file)
  usernames = []
  $names.each do |name|
  	name.sub!(/\b[A-Z]\.\s/, '')
    first, last = name.tr("',-", '').downcase.split[0..1]
    if format_choice == '0'
      usernames << "#{first} #{last}"
    elsif format_choice == '1'
      usernames << "#{first}#{last}"
    elsif format_choice == '2'
      usernames << "#{first[0]}#{last}"
    elsif format_choice == '3'
      usernames << "#{first}.#{last}"
    elsif format_choice == '4'
      usernames << "#{first}_#{last}"
    end
  end

  usernames = usernames.uniq

  File.open(output_file, "w+") do |f|
    f.puts(usernames)
  end

end


$names = []

print "\nDo you have LinkedIn credentials? y/n: "; li = $stdin.gets.chomp
if li == 'y'
  print "\nEnter your LinkedIn username: "; li_username = $stdin.gets.chomp
  print "\nEnter your LinkedIn password: "; li_password = $stdin.gets.chomp
end

print "\nDo you have Data.com credentials? y/n: "; dc = $stdin.gets.chomp
if dc == 'y'
  print "\nEnter your Data.com username: "; dc_username = $stdin.gets.chomp
  print "\nEnter your Data.com password: "; dc_password = $stdin.gets.chomp
end

print "\nEnter the company name for search: "; company = $stdin.gets.chomp

puts "\nUsername output choices..."
puts "[0] Output names only"
puts "[1] Username format: firstlast"
puts "[2] Username format: flast"
puts "[3] Username format: first.last"
puts "[4] Username format: first_last"
print "Choose a username output format: "; format_choice = $stdin.gets.chomp
print "Enter file path and name for username output: "; output_file = $stdin.gets.chomp

if dc == 'y'
  data_dot_com(dc_username, dc_password, company)
end

if li == 'y'
  linkedin(li_username, li_password, company)
end

name_mangler(format_choice, output_file) unless li == 'n' && dc == 'n'
