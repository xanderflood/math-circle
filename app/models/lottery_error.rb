class LotteryError < ApplicationRecord
  after_initialize :set_timestamp
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

  protected
    def set_timestamp
      self.timestamp = DateTime.now
    end
end
