#!/usr/bin/env ruby
$:.unshift File.expand_path '../', File.dirname(__FILE__)
require 'bootstrap'
require 'irb'
Bootstrap.init :inits, :models

IRB.start
