require 'net/http'
require 'uri'

filename = "data\output.txt"

url = "http://proxy-ip-list.com/download/free-usa-proxy-ip.txt"

uri = URI.parse(url)
result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }

File.open(filename,'wb'){ |f| f.write(result.body) }