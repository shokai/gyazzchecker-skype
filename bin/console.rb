#!/usr/bin/env ruby
require File.expand_path '../bootstrap', File.dirname(__FILE__)
require 'irb'
Bootstrap.init :inits, :models, :libs

IRB.start
