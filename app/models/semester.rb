class Semester < ApplicationRecord
  enum state: [ :prereg, :reg, :late_reg, :archived ]
end
