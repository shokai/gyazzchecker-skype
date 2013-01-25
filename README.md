GyazzChecker-Skype
==================
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

    % ruby bin/check.rb --help
    % ruby bin/check.rb --silent
    % ruby bin/check.rb --limit 30


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request