#!/usr/bin/env ruby
#
# Write a Python or Ruby script that will open this log file (http://c.hlp.sc/ZKtU),
# then parse/print the message IDs and Subjects.
#

require_relative "parser"

#Get a log file for argument
LOGFILE = ARGV[0]

#test if arg file exist or print help
if LOGFILE.nil? or !File.file? LOGFILE
	print "[Error] no valid logfile found.\nCommand usage: mail-log-parser.rb logfile\n"
	exit 1
end

parser = Parser.new

begin
	parser.parse LOGFILE
rescue Exception => e
	puts e.message
end
