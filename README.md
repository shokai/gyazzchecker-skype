GyazzChecker-Skype
==================
https://github.com/shokai/gyazzchecker-skype

* check Gyazz.com
* notify Skype

Requirements
------------

* Mac OSX
* Skype
* Ruby 1.8.7 (to use rb-skypemac gem)
* MongoDB 2.0+


Install Dependencies
--------------------

    % gem install bundler
    % bundle install


Setup
-----

chat list

    % ruby bin/show_chat_list.rb

edit config.yml

    % cp sample.config.yml config.yml


Run
---

    % ruby bin/gyazzchecker.rb --help
    % ruby bin/gyazzchecker.rb --silent
    % ruby bin/gyazzchecker.rb --limit 30 --interval 5


Install LaunchAgent
-------------------

    % cp org.shokai.gyazzchecker-skype.plist ~/Library/LaunchAgents/

edit plist file, then

    % launchctl load -w ~/Library/LaunchAgents/org.shokai.gyazzchecker-skype.plist


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request