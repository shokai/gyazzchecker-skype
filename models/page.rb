require 'kconv'

class Page
  include Mongoid::Document
  field :created_at, :type => Time , :default => lambda{Time.now}
  field :updated_at, :type => Time , :default => lambda{Time.now}
  field :name, :type => String
  field :wiki, :type => String
  field :data, :type => Array, :default => []
  validates_presence_of :name
  validates_presence_of :wiki
  before_update :on_save

  private
  def on_save
    self.updated_at = Time.now
  end

  public
  def self.find_by_wiki_and_name(wiki, name)
    self.where(:wiki => wiki, :name => name).first
  end

  def self.find_by_wiki(pattern)
    self.where(:wiki => pattern)
  end

  def self.find_by_name(pattern)
    self.where(:name => pattern)
  end

  def self.latests(num=10)
    self.all.desc(:updated_at).limit(num)
  end

  def diff(data)
    Diff::LCS.sdiff(self.data, data).select{|i|
      i.new_element != i.old_element
    }.map{|i|
      i.new_element
    }.select{|i|
      i and i.size > 0
    }
  end

  def url
    "http://gyazz.com/#{wiki.toutf8}/#{name.toutf8}"
  end

  def url_encoded
    url.gsub(/ /, '%20')
  end
end
