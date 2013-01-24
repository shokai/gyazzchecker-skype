#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
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

  crawler.on :new do |page|
    msg = "【新規】 #{page.url}\n"
    msg += page.data.join("\n")
    Skype.send_chat_message Conf['skype'], msg
  end

  crawler.on :diff do |page, diff|
    diff.each do |line|
      puts "diff : #{page.name} +#{line}"
    end
  end

  crawler.on :diff do |page, diff|
    msg = "【更新】 #{page.url}\n"
    msg += diff.join("\n")
    Skype.send_chat_message Conf['skype'], msg
  end

  crawler.crawl
end
