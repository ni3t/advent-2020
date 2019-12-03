require 'httparty'
require 'nokogiri'

@day = ARGV.first
@cookie = File.read("cookie")
TEMPLATE = <<~RUBY
@answer1 = nil
@answer2 = nil

pp @answer1
pp @answer2

__END__
RUBY

def get_input
  HTTParty.get("https://adventofcode.com/2019/day/#{@day}/input", {
    headers: { 
      "cookie" => "session=#{@cookie}"
    }
  })
end

def get_title
  content = HTTParty.get("https://adventofcode.com/2019/day/#{@day}")
  if content.body =~ /Please don't repeatedly/
    puts "NOT YET SIR"
    exit
  end
  title = Nokogiri::HTML(content).css("article h2").text
  filename = title.split(":").last[0..-4]
  filename.strip.split(" ").map(&:downcase).unshift(@day).join("_") + ".rb"
end

def create_file
  if File.exists?(get_title)
    puts "exists"
    exit
  end
  File.open(get_title, "w+") do |file|
    file.write(TEMPLATE + get_input)      
  rescue StandardError
    "something went wrong"
  ensure
    file.close
  end
  puts "OK GO!"
end

create_file
