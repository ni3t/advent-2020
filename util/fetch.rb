require 'httparty'
require 'nokogiri'

@year = 2020

@day = ARGV.first
raise 'put in a number dumbass' unless @day

@cookie = File.read('cookie')
TEMPLATE = <<~RUBY.freeze
  input = DATA.each_line.map do |line|
  
  end
  
  __END__
RUBY

def fetch_input
  base_url = "https://adventofcode.com/#{@year}/day/#{@day}"
  HTTParty.get(base_url + '/input', {
                 headers: {
                   'cookie' => "session=#{@cookie}"
                 }
               })
end

def fetch_title
  base_url = "https://adventofcode.com/#{@year}/day/#{@day}"
  content = HTTParty.get(base_url)
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
  base_url = "https://adventofcode.com/#{@year}/day/#{@day}"
  if File.exist?(fetch_title)
    puts 'exists'
    exit
  end
  write_file
  puts 'OK GO!'
  exec("open #{base_url}")
end

create_file
