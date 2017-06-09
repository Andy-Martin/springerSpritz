require 'net/http'
require 'Nokogiri'
require 'colored'

puts "Welcome to the SpringerSpritz Speed Reader!".bold
sleep 1
puts "This only works in the Springer network as it uses the content-api :-("
sleep 1
puts "... but you can speedread any abstract found on SpringerLink, BMC or Nature!"
puts "All you need is the DOI."
sleep 1
puts ""
print "Enter the doi: "
doi = gets.chomp

uri = URI.parse("http://content-api.live.springer.com/document/#{doi}")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)


def rereadCheck(reread)
	if reread == "n"
		read = false
		File.delete("abstract.txt")
			exit!
	elsif reread == "no"
		read = false
		File.delete("abstract.txt")
			exit!
	elsif reread == "N"
		read = false
		File.delete("abstract.txt")
			exit!
	elsif reread == "NO"
		read = false
		File.delete("abstract.txt")
			exit!
	elsif reread == "No"
		read = false
		File.delete("abstract.txt")
			exit!
	elsif reread == "y"
		read = true
	elsif reread == "Y"
		read = true
	elsif reread == "yes"
		read = true
	elsif reread == "YES"
		read = true
	elsif reread == "Yes"
		read = true
	else
		puts "Sorry I didn't understand that."
		print "Read again? y/n: "
		reread = gets.chomp
		rereadCheck(reread)
	end
end

def reading(wpm = 0)
	read = true
	while read == true
				system("cat abstract.txt | ./speedread -w #{wpm.to_i}")
				puts ""
				print "Read again? y/n: "
				reread = gets.chomp
				rereadCheck(reread)
	end
end



# Check the existance of the document
if response.code.to_i == 200 
	xml_doc  = Nokogiri::XML(response.body)
	toread = xml_doc.xpath("//Abstract/*/text()")
	File.open("abstract.txt", 'w') { |file| file.write(toread.to_s) }
	# even though the document might exist, it might not have an Abstract
		if File.zero?("abstract.txt")
			puts "No abstract available for #{doi}. If your doi is for a book, try a specific chapter instead."
			File.delete("abstract.txt")
			exit!
		else
			puts ""
			puts "Got the abstract!".blue
		end

	articleTitle = xml_doc.xpath("//ArticleInfo/ArticleTitle/text()")
		# what if it's a Chapter? Path to the title will be incorrect
		if articleTitle.to_s == ""
		then articleTitle = xml_doc.xpath("//ChapterInfo/ChapterTitle/text()")
		end
	puts ""
	puts articleTitle.to_s.bold.yellow_on_black
	puts ""
	puts "Enter the words per minute you want to read at. 250 is fairly slow, 500 average etc: "
	wpm = gets.chomp
	puts "You can adjust the speed with '[' and ']' and pause with space. Here we go...".blue
	sleep 2
		while wpm.to_i == 0
			puts "Please enter an integer greater than zero: "
			wpm = gets.chomp
			if wpm.to_i > 0
			then reading(wpm)
			end
		end
	reading(wpm)
	File.delete("abstract.txt")
else		
	puts "Cannot find doi"
end
