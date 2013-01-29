
class Crawler
  include EventEmitter
  attr_reader :gyazz, :wiki_name
  attr_accessor :interval, :nosave

  def initialize(wiki_name, user=nil, pass=nil)
    @wiki_name = wiki_name
    @gyazz = Gyazz.new wiki_name, user, pass
    @interval = 5
    @nosave = false
  end

  def get_page(name)
    @gyazz.get(URI.encode name).
      split(/[\r\n]+/).
      reject{|i| i =~ /^\s+$/}
  end

  def crawl(limit=nil)
    list = @gyazz.list
    list = list[0...limit] if limit
    list.each do |name|
      name = name.toutf8
      emit :crawl, name
      if page = Page.find_by_wiki_and_name(@wiki_name, name)
        data = get_page name
        diff = page.diff data
        page.data = data
        page.save! unless @nosave
        emit :diff, page, diff unless diff.empty?
      else
        data = get_page name
        page = Page.new(:wiki => wiki_name, :name => name, :data => data)
        page.save! unless @nosave
        emit :new, page
      end
      sleep @interval
    end
  end
end
