class Parent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :students, dependent: :destroy
  has_one :parent_profile, dependent: :destroy
  has_many :special_registrees

  alias :profile :parent_profile

  def name
    if self.profile
      self.profile.name
    else
      "N/A"
    end
  end

  def profile_or_new
    self.profile || ParentProfile.new(parent_id: self.id)
  end

  def class_event_info
    self.students.map do |student|
      if student.registree.nil?
        []
      elsif student.registree.section.nil?
        []
      else
        student.registree.section.events.map do |event|
          {
            reason: student.name,
            date: event.when,
            time: event.time
          }
        end
      end
    end.inject([], :+)
  end

  def special_event_info
    self.special_registrees.map do |registree|
      event = registree.special_event
      {
        reason: event.name,
        reservation: registree.value,
        date: event.date,
        time: event.start
      }
    end
  end

  def schedule
    (self.special_event_info + self.class_event_info).sort_by do |event_hash|
      event_hash[:time]
    end.sort_by do |event_hash|
      event_hash[:date]
    end
  end
end
