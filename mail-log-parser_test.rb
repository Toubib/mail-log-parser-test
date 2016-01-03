#!/bin/env ruby

require_relative "parser"
require "test/unit"
require "stringio"

LOGFILE="sample/test-sample.log"
SAMPLE_OUTPUT="1YC0iF-0002cM-1G\tReally short!\n1YC0iI-0002ci-ML\tWelcome to The Jungle\n1YC0iO-0002dz-8x\tHere's a new test topic!\n".force_encoding 'UTF-8'

#we have to mock stdout in order to capture the printed output
# see https://blog.8thlight.com/josh-cheek/2011/10/01/testing-code-thats-hard-to-test.html
# or http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/
def mock_stdout
	stdout = $stdout
	$stdout = mock = StringIO.new
	yield
	mock.rewind
	mock.read
ensure
	$stdout = stdout
end


class TestSample < Test::Unit::TestCase

	#test output is right
	def test_output_ok
		out = mock_stdout do
			parser = Parser.new
			parser.parse(LOGFILE)
		end

		assert_equal(SAMPLE_OUTPUT, out)
	end
end
