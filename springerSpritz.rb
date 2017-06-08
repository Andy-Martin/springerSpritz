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

if response.code.to_i == 200 
	xml_doc  = Nokogiri::XML(response.body)
	toread = xml_doc.xpath("//Abstract/*/text()")
	File.open("abstract.txt", 'w') { |file| file.write(toread.to_s) }
	puts "Got the article!"
	articleTitle = xml_doc.xpath("//ArticleInfo/ArticleTitle/text()")	
	puts articleTitle.to_s.bold.yellow_on_black
	print "Enter the words per minute you want to read at. 250 is fairly slow, 500 average etc: "
	wpm = gets.chomp
		while read == true
			system("cat abstract.txt | ./speedread -w #{wpm.to_i}")
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
else		
	puts "Cannot find DOI"
end