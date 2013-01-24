require 'mongoid'

Mongoid.logger.level = Logger::WARN
Mongoid.configure do |conf|
  conf.from_hash YAML.load(open(File.expand_path '../mongoid.yml', File.dirname(__FILE__)).read)
end
