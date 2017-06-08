require 'net/http'
require 'Nokogiri'
require 'colored'

print "Enter the DOI here: "
doi = gets.chomp

uri = URI.parse("http://content-api.live.springer.com/document/#{doi}")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
read = true
# Check the existance of the document
if response.code.to_i == 200 
	xml_doc  = Nokogiri::XML(response.body)
	toread = xml_doc.xpath("//Abstract/*/text()")
	File.open("abstract.txt", 'w') { |file| file.write(toread.to_s) }
	# even though the document might exist, it might not have an Abstract
		if File.zero?("abstract.txt")
			puts "No abstract available for #{doi}. If your DOI is for a book, try a specific chapter instead."
			File.delete("abstract.txt")
			exit!
		else
			puts "Got the abstract!"
		end
	articleTitle = xml_doc.xpath("//ArticleInfo/ArticleTitle/text()")
		# what if it's a Chapter? Path to the title will be incorrect
		if articleTitle.to_s == ""
		then articleTitle = xml_doc.xpath("//ChapterInfo/ChapterTitle/text()")
	end
	puts articleTitle.to_s.bold.yellow_on_black
	puts "Enter the words per minute you want to read at. 250 is fairly slow, 500 average etc: "
	wpm = gets.chomp
		while read == true
			system("cat abstract.txt | ./speedread -w #{wpm.to_i}")
			puts ""
			puts "Read again? y/n: "
			reread = gets.chomp
				if reread == "n"
					read = false
					break
				elsif reread == "no"
					read = false
					break
				elsif reread == "N"
					read = false
					break
				elsif reread == "NO"
					read = false
					break
				elsif reread == "No"
					read = false
					break
				elsif reread == "y"
					read = true
				elsif reread == "yes"
					read = true
				elsif reread == "YES"
					read = true
				elsif reread == "Yes"
					read = true
				else
					puts "Sorry I didn't understand that."
					puts "Read again? y/n: "
					reread = gets.chomp
				end
		end
	File.delete("abstract.txt")
else		
	puts "Cannot find DOI"
end
