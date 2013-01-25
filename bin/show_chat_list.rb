#!/usr/bin/env ruby
$:.unshift File.expand_path '../', File.dirname(__FILE__)
require 'bootstrap'
Bootstrap.init :libs

puts "Skype Chat IDs"
puts "-"*5
Skype.recent_chats.each do |id|
  puts "- #{id}"
end
