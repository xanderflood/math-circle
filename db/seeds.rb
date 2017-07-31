# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Teacher.create(email: "me@emory.edu", password: "password")

parent = Parent.create(email: "me@emory.edu", password: "password")
FactoryGirl.create(:student, parent: parent, grade: :A, name: "Bobby McNamara")
FactoryGirl.create(:student, parent: parent, grade: :B, name: "Tramelgren Didion")
FactoryGirl.create(:student, parent: parent, grade: :unspecified, name: "Big Lebowski")
# TODO: create some students

FactoryGirl.create(:semester_for_lottery)
