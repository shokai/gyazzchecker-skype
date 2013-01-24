$:.unshift File.expand_path '../', File.dirname(__FILE__)
require 'bootstrap'
Bootstrap.init :libs

p Skype.recent_chats
