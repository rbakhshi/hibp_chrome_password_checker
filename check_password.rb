#!/usr/bin/env ruby
require "net/http"
require "shell"
require "digest"

@checked = {}

def check_pass(site, passplain)
  sha1 = Digest::SHA1.new
  pass = sha1.update(passplain).to_s

  leaked_count = @checked[pass]
  unless leaked_count
    uri = uri = URI("https://api.pwnedpasswords.com/range/#{pass[0..4]}")
    res = Net::HTTP.get(uri)
    result = Hash[* res.downcase.tr("\r", "").split(/\:|\n/)]
    suffix = pass[5..-1]
    leaked_count = @checked[pass] = result[suffix]
  end
  if leaked_count
    puts "\npassword for #{site} (#{passplain}) found #{leaked_count} times"
  else
    printf "."
  end
 result 
end


sh = Shell.new
File.new("Chrome Passwords.csv")
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