#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class String
  def remove_gyazz_markup(left='【', right='】')
    self.split(/(\[{2,3}[^\[\]]+\]{2,3})/).map{|i|
      res = i
      if i =~ /(\[{2,3}(.+)\]{2,3})/
        if i =~ /\[{2,3}(https?:\/\/.+)\]{2,3}/
          res = i.gsub(/\[{2,3}([^\[\]]+)\]{2,3}/){ " #{$1} " }
        else
          res = i.gsub(/\[{2,3}([^\[\]]+)\]{2,3}/){ "#{left}#{$1}#{right}" }
        end
      end
      res
    }.join('')
  end
end

if __FILE__ == $0
  [
   "参考サイト [[http://shokai.org]]",
   "参考サイト [[http://shokai.org/blog/ 橋本商会]]",
   "[[Apple]]を作った[[人物]]",
   "[[[http://gyazo.com/asdf.png]]]",
   "[[webページをキャプチャする]]時にも使える"
  ].each do |i|
    puts i
    puts " -> #{i.remove_gyazz_markup}"
  end
end
