class Parent::RegistreesController < Parent::BaseController
  include RegistreesControllable
  self.role = :parent
end
