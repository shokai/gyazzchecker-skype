#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.expand_path '../bootstrap', File.dirname(__FILE__)
Bootstrap.init :inits, :models, :libs

parser = ArgsParser.parse ARGV do
  arg :limit, 'page limit'
  arg :silent, 'no notify'
  arg :interval, 'crawl interval (sec)', :default => 5
  arg :nosave, 'not save gyazz contents for debug'
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
  crawler.nosave = parser[:nosave]

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
    skype_chat_id = wiki['skype'] ? Conf['skype'][wiki['skype']] : Conf['skype']['default']
    crawler.on :new do |page|
      msg = "(beer) 《新規》 #{page.url_encoded} 《#{page.wiki}》\n"
      msg += "《#{page.name}》\n" if page.url != page.url_encoded
      msg += page.data.map{|i| i.remove_gyazz_markup }.join("\n")
      Skype.send_chat_message skype_chat_id, msg
    end

    crawler.on :diff do |page, diff|
      msg = "(*) 《更新》 #{page.url_encoded} 《#{page.wiki}》\n"
      msg += "《#{page.name}》\n" if page.url != page.url_encoded
      msg += diff.map{|i| i.remove_gyazz_markup }.join("\n")
      Skype.send_chat_message skype_chat_id, msg
    end
  end

  crawler.crawl parser[:limit]
end
