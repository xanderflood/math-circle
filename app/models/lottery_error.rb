class LotteryError < ApplicationRecord
  after_initialize :set_timestamp, if: :new_record?
  serialize :backtrace, Array

  # TODO: after_save :notify_someone!

  def self.save!(e=nil)
    LotteryError.new(exception: e).save!
  rescue
  end

  def exception=(e)
    self.message = e.message
    self.backtrace = e.backtrace
  end

  def trace(count=nil)
    chunk = self.backtrace
    chunk = chunk.first(count) if count
    chunk.each { |s| puts s }

    nil
  end

  protected
    def set_timestamp
      self.timestamp ||= DateTime.now
    end
end
