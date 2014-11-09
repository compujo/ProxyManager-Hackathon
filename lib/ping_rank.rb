#!/usr/bin/env ruby

pingDatFile = "data\\outfile.txt"
proxylist = "data\\proxylist.txt"
selectedproxy = "data\\selectedproxy.txt"

File.open(pingDatFile, 'a') {} #Make file if not exist

numlines = 0

lines = []

class Host
	def initialize(host)
		@host = host
		@total = 0
		@times = []
		@numtimes = 0
	end
	
	def addtime(t)
		@total += t.to_i
		@numtimes += 1
		@times.insert(t.to_i)
	end
	
	def gettimes
		@times
	end
	
	def getavg() 
		(@total / @numtimes)
	end
end

File.open(pingDatFile, 'r') { |f|
	while line = f.gets
		lines[numlines] = line
		numlines += 1
	end
}

hosts = {}
numhosts = 0

iptohost = {}

lines.each_with_index { |l,i|
	#puts i
	if (l =~ /^Reply from ([0-9\.]{5,16}):.*time=([0-9]{0,5})ms.*$/) then
		hostn = $1.to_s
		time = $2.to_s
		
		if (hosts[hostn] == hosts.default) then
			hosts[hostn] = Host.new(hostn)
		end
		
		unless (time.nil?)
			hosts[hostn].addtime(time)
		else 
			puts "nil time: " + l
		end
	elsif (l =~ /Pinging ([a-zA-Z0-9\.]{3,70}) \[([0-9\.]{5,16})\] with/)
		iptohost[$2] = $1
	elsif (l =~ /[0-9]{1,4} bytes from ([0-9\.]{5,16}): icmp_seq=.{0,3} ttl=.{0,3} time=([0-9]{1,5})\.[0-9]{0,7} ms/)
		hostn = $1.to_s
		time = $2.to_s
		
		if (hosts[hostn] == hosts.default) then
			hosts[hostn] = Host.new(hostn)
		end
		
		unless (time.nil?)
			hosts[hostn].addtime(time)
		else 
			puts "nil time: " + l
		end
	elsif (l =~ /PING ([a-zA-Z0-9\.]{3,70}) \(([0-9\.]{5,16})\):/)
		iptohost[$2] = $1
	else
		#puts l
	end
	#puts i.to_s + " " + l
}

#Rank hosts
rankedhosts = {}

hosts.keys.each_with_index { |ip,i|
	rankedhosts[ip] = hosts[ip].getavg.to_i
}

rankedhosts = rankedhosts.sort_by{|ip,time| time}

#Output

puts "Fastest servers:"

File.open(proxylist, 'a') {}
	
File.delete(proxylist)

rankedhosts.take(10).each_with_index { |entry,i|
	ip = entry[0]
	unless (iptohost[ip] == iptohost.default)
		hostn = iptohost[ip]
	else
		hostn = ip
	end
	
	toPrint = ""
	
	toPrint += (i+1).to_s + ". " + hostn 
	
	if (hostn != ip)
		toPrint += " [" + ip + "]: "
	else 
		toPrint += ": "
	end
	toPrint += hosts[ip].getavg.to_s + "ms"
	
	puts toPrint
	
	if (i == 0) 
		File.open(selectedproxy, 'a') {}
	
		File.delete(selectedproxy)
		
		File.open(selectedproxy, 'a') { |f| f.write(hostn)}
	end
	
	File.open(proxylist, 'a') { |f| f.puts toPrint }
}

#system("pause")