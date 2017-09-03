# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# attendance example (executed lottery)
puts "+++ Buidling a run-lottery example +++"
lottery = FactoryGirl.create(:lottery)
puts "  Running the lottery"
lottery.semester.target_lottery = lottery
lottery.semester.run

# lottery example
puts "+++ Buidling an un-run-lottery example +++"
FactoryGirl.create(:semester_for_lottery, name: "Semester with ballots")

puts "+++ Setting up preview accounts +++"

# logins
Teacher.create(email: "test@emory.edu", password: "password")
parent = Parent.create(email: "test@emory.edu", password: "password")

# students
FactoryGirl.create(:student, parent: parent, level: :A, name: "Bobby McNamara")
FactoryGirl.create(:student, parent: parent, level: :B, name: "Tramelgren Didion")
FactoryGirl.create(:student, parent: parent, level: :unspecified, name: "Big Lebowski")
