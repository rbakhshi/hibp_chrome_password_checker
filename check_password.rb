#!/usr/bin/env ruby
require "net/http"
require "digest"

@checked = {}

def check_pass(site, passplain)
  sha1 = Digest::SHA1.new
  password_hash = sha1.update(passplain).to_s

  leaked_count = @checked[password_hash]
  unless leaked_count
    uri = uri = URI("https://api.pwnedpasswords.com/range/#{password_hash[0..4]}")
    res = Net::HTTP.get(uri)
    result = Hash[* res.downcase.tr("\r", "").split(/\:|\n/)]
    suffix = password_hash[5..-1]
    leaked_count = @checked[password_hash] = result[suffix]
  end
  if leaked_count
    puts "\npassword for #{site} ****(#{passplain.split(//).last(5).join}) found #{leaked_count} times"
  else
    printf "."
  end
 result 
end

password_file = if ARGV.empty?
  "Chrome Passwords.csv"
else 
  ARGV[0]
end

unless File.exists?(password_file)
  puts "ruby check_password.rb [/path/to/password/csv/file, Default = './Chrome Passwords.csv']"
  exit
end

File.new(password_file)
  .drop(1) # ignore the headers
  .sort
  .uniq
  .compact
  .each do |line|
    items = line.split(/\s*,\s*/)
    site = items[0]
    site = "N/A" if site.strip.empty?
    plain_password = items[3]
    next if plain_password.nil? || plain_password.empty?
    check_pass site, plain_password.strip
  end
