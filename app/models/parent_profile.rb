class ParentProfile < ApplicationRecord
  belongs_to :parent

  after_initialize :default_email

  validates :first_name, presence: true, length: { minimum: 3 }
  validates :last_name,  presence: true, length: { minimum: 3 }

  validates :phone, phone: true
  validates :email, format: { with: EmailHelper::OPTIONAL_EMAIL }

  validates :street1, presence: true
  validates :city, presence: true
  enum state: StatesHelper::US_STATES.map(&:last)
  validates :zip, format: { with: StatesHelper::ZIPCODE_REGEXP }

  [1, 2].each do |i|
    validates :"ec#{i}_first_name", presence: true, length: { minimum: 3 }
    validates :"ec#{i}_last_name", presence: true, length: { minimum: 3 }
    validates :"ec#{i}_relation", presence: true, length: { minimum: 3 }
    validates :"ec#{i}_phone", presence: true, phone: true
  end

  def name; [self.first_name, self.last_name].join(" "); end

  def default_email; self.email ||= self.parent.email; end

  def address
    return @address if @address

    @address  = [self.street1]
    @address << self.street2 if self.street2
    @address << "#{self.city}, #{self.state} #{self.zip}"

    @address = @address.join "\n"
  end
end
