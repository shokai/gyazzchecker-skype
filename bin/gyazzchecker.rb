#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path '../bootstrap', File.dirname(__FILE__)
Bootstrap.init :inits, :models, :libs

parser = ArgsParser.parse ARGV do
  arg :limit, 'page limit'
  arg :silent, 'no notify'
  arg :interval, 'crawl interval (sec)', :default => 5
  arg :help, 'show help', :alias => :h

  validate :interval, 'interval must be Time' do |a|
    a.kind_of? Fixnum and a > 0
  end
end

if parser.has_option? :help
  STDERR.puts parser.help
  STDERR.puts "e.g."
  STDERR.puts "  ruby #{$0}"
  STDERR.puts "  ruby #{$0}  --limit 20"
  exit 1
end

Conf['gyazz'].each do |wiki|
  crawler = Crawler.new wiki['wiki'], wiki['user'], wiki['pass']
  crawler.interval = parser[:interval]

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

  unless parser[:silent]
    crawler.on :new do |page|
      msg = "【新規】 #{page.url}\n"
      msg += page.data.join("\n")
      Skype.send_chat_message Conf['skype'], msg
    end

    crawler.on :diff do |page, diff|
      msg = "【更新】 #{page.url}\n"
      msg += diff.join("\n")
      Skype.send_chat_message Conf['skype'], msg
    end
  end

  crawler.crawl parser[:limit]
end
