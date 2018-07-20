require 'logger'

module Paraspec
  class << self
    attr_accessor :logger
  end

  self.logger = Logger.new(STDERR)
  self.logger.level = Logger::WARN
end