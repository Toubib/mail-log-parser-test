#!/usr/bin/env ruby
#
# Write a Python or Ruby script that will open this log file (http://c.hlp.sc/ZKtU),
# then parse/print the message IDs and Subjects.
#
# The log file is composed by the process of each received mails on multiple lines grouped by an identifier.
# Message subjects are on lines identified with a '<=' sign on the 5th position.
# The line use this format:
#   DATE TIME PROCESS_ID MAIL_ID OPERATION EMAIL [[DATA] ...]
# with DATA KEY=VALUE based. Subject is the 'T' key.

class LogParser
	
	#output separator
	OUTPUT_SEPARATOR="\t"
	
	#enable/disable operations.
	# could be set with command line argument
	PARSE_INCOMING = true
	PARSE_OUTGOING = false
	
	#Regex
	INCOMING_REGEX = /^(?<date>\d{4}-\d{2}-\d{2}) (?<time>\d{2}:\d{2}:\d{2}) (?<pid>\[\d+\]) (?<mail_id>[\w-]+) (?<operation><=) .* (?<subject>T="(?<subject>.*)")/
	OUTGOING_REGEX = /^(?<date>\d{4}-\d{2}-\d{2}) (?<time>\d{2}:\d{2}:\d{2}) (?<pid>\[\d+\]) (?<mail_id>[\w-]+) (?<operation>=>) .* (?<subject>T=(?<subject>\w+))/
	
	def initialize(logfile)
		@logfile = logfile
	end	

	#open read-only (default) and read the logfile line by line
	def run
		begin
			IO.foreach @logfile do |line|
			
				result = nil
			
				#Parse incoming message
				if PARSE_INCOMING
					result = INCOMING_REGEX.match(line)
				end
			
				#Parse outgoing message
				if PARSE_OUTGOING and result.nil?
					result = OUTGOING_REGEX.match(line)
				end
			
				#didn't find a subject
				next if result.nil?
			
				#print line id and subject
				print result[:mail_id] + OUTPUT_SEPARATOR + result[:subject] + "\n"
			end
		rescue Exception => e
			puts e.message
		end
	end
end

#Get a log file for argument
LOGFILE = ARGV[0]

#test if arg file exist or print help
if LOGFILE.nil? or !File.file? LOGFILE
	print "[Error] no valid logfile found.\nCommand usage: mail-log-parser.rb logfile\n"
	exit 1
end

parser = LogParser.new LOGFILE
parser.run
