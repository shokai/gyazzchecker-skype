class Skype
  private
  def self.exec(command)
    SkypeMac::Skype.send_(:command => command)
  end
  
  public
  def self.recent_chats
    exec("SEARCH RECENTCHATS").split(/,* /).reject{|i|
      i !~ /^#.+\/.+/
    }
  end

  def self.send_message(to,body)
    exec "MESSAGE #{to} #{body}"
  end

  def self.send_chat_message(to,body)
    exec "chatmessage #{to} #{body}"
  end

  def self.message_ids(chat_id)
    exec("GET CHAT #{chat_id} RECENTCHATMESSAGES").
      split(/,* /).
      reject{|i|
      i !~ /^\d+$/
    }.map{|i|
      i.to_i
    }.sort.reverse
  end

  class Message
    attr_reader :id, :user, :body, :time

    def initialize(id)
      @id = id
      @user = Skype.exec("GET CHATMESSAGE #{id} from_handle").split(/ /).last
      @body = Skype.exec("GET CHATMESSAGE #{id} body").gsub(/^MESSAGE \d+ BODY /i,'')
      @time = Time.at Skype.exec("GET CHATMESSAGE #{id} timestamp").split(/ /).last.to_i
    end

    def to_hash
      {
        :id => id,
        :user => user,
        :body => body,
        :time => time
      }
    end

    def to_s
      "<#{user}> #{body} - #{time}"
    end

    def to_json(*a)
      to_hash.to_json(*a)
    end
  end

end
