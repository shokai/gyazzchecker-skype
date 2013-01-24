#!/usr/bin/env ruby
$:.unshift File.expand_path '../', File.dirname(__FILE__)
require 'bootstrap'
Bootstrap.init :inits, :models, :libs

Conf['gyazz'].each do |wiki|
  crawler = Crawler.new wiki['wiki'], wiki['user'], wiki['pass']

  crawler.on :crawl do |name|
    puts "crawl : #{wiki['wiki']}/#{name}"
  end

  crawler.on :new do |page|
    puts "newpage : #{page.name}"
  end

  crawler.on :diff do |page, diff|
    diff.each do |line|
      puts "diff : #{page.name} +#{line}"
    end
  end

  crawler.crawl
end
