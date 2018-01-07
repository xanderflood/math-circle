class Teacher::BallotsController < Teacher::BaseController
  include BallotsControllable
  self.role = :teacher
end
