class Teacher::RegistreesController < Teacher::BaseController
  include RegistreesControllable
  self.role = :teacher
end
