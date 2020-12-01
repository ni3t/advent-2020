require 'httparty'
require 'nokogiri'

@year = 2020

@day = ARGV.first
raise 'put in a number dumbass' unless @day

@cookie = File.read('cookie')
TEMPLATE = <<~RUBY.freeze
  @answer1 = nil
  @answer2 = nil
  
  pp @answer1
  pp @answer2
  
  __END__
RUBY

def fetch_input
  HTTParty.get("https://adventofcode.com/#{@year}/day/#{@day}/input", {
                 headers: {
                   'cookie' => "session=#{@cookie}"
                 }
               })
end

def fetch_title
  content = HTTParty.get("https://adventofcode.com/#{@year}/day/#{@day}")
  if content.body =~ /Please don't repeatedly/
    puts 'NOT YET SIR'
    exit
  end
  title = Nokogiri::HTML(content).css('article h2').text
  puts title
  filename = title.split(':').last[0..-4]
  filename.strip.split(' ').map(&:downcase).unshift(@day).join('_') + '.rb'
end

def write_file
  File.open(fetch_title, 'w+') do |file|
    file.write(TEMPLATE + fetch_input)
  rescue StandardError
    'something went wrong'
  ensure
    file.close
  end
end

def create_file
  if File.exist?(fetch_title)
    puts 'exists'
    exit
  end
  write_file
  puts 'OK GO!'
end

create_file
