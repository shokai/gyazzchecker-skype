#!/usr/bin/env ruby
$:.unshift File.expand_path '../', File.dirname(__FILE__)
require 'bootstrap'
Bootstrap.init :libs

puts "Skype Chat IDs"
Skype.recent_chats.each do |chat_id|
  puts "-"*5
  puts "#{chat_id}"
  Skype.message_ids(chat_id)[0...3].each do |mid|
    msg = Skype::Message.new mid
    puts "  #{msg}"
  end
end
