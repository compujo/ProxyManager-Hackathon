#!/usr/bin/env ruby

require 'net/http'
require 'uri'

filename = "output.txt"

url = "http://proxy-ip-list.com/download/free-usa-proxy-ip.txt"

uri = URI.parse(url)
result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }

r = result.body.split("\r");

r.shift(3);

File.open(filename, 'a'){}
File.delete(filename)

r.each { |l|
File.open(filename, 'a'){ |f| f.write(l + "\n") }
}