require 'kconv'

class Crawler
  include EventEmitter
  attr_reader :gyazz, :wiki_name
  attr_accessor :interval, :nosave

  def initialize(wiki_name, user=nil, pass=nil)
    @wiki_name = wiki_name
    @gyazz = Gyazz.wiki(wiki_name)
    if user and pass
      @gyazz.auth = {:username => user, :password => pass}
    end
    @interval = 5
    @nosave = false
  end

  def crawl(limit=nil)
    list = @gyazz.pages
    list = list[0...limit] if limit
    list.each do |page|
      next if Conf["ignore"].include? page.name
      emit :crawl, page.name
      if _page = Page.find_by_wiki_and_name(@wiki_name, page.name)
        data = page.text.toutf8.split(/[\r\n]+/).reject{|i| i =~ /^\s+$/ } rescue next
        diff = _page.diff data
        _page.data = data
        _page.save! unless @nosave
        emit :diff, _page, diff unless diff.empty?
      else
        data = page.text.toutf8.split(/[\r\n]+/).reject{|i| i =~ /^\s+$/ } rescue next
        next if data.to_s.strip == '(empty)'
        _page = Page.new(:wiki => wiki_name, :name => page.name, :data => data)
        _page.save! unless @nosave
        emit :new, _page
      end
      sleep @interval
    end
  end
end
