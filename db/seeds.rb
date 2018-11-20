puts "+++ Establishing level structure +++"
["A", "B", "C", "D"].each do |l|
  begin
    FactoryBot.create(:level, name: l, active: false, restricted: (l == "D"))
  rescue
    warn "Not overwriting level #{l}."
  end
end

["Middle School A", "Middle School B", "Middle School C"].each do |l|
  begin
    FactoryBot.create(:level, name: l, active: true, min_level: 6, max_level: 8)
  rescue
    warn "Not overwriting level #{l}."
  end
end

["High School A", "High School B"].each do |l|
  begin
    FactoryBot.create(:level, name: l, active: true, min_level: 9, max_level: 12)
  rescue
    warn "Not overwriting level #{l}."
  end
end

# attendance example (executed lottery)
puts "+++ Building a finished-lottery example +++"
FactoryBot.create(:finished_lottery)

# lottery example
puts "+++ Building an un-run-lottery example +++"
FactoryBot.create(:semester_for_lottery, name: "Semester with ballots")

puts "+++ Setting up preview accounts +++"

# logins
Teacher.create(email: "test@emory.edu", password: "password")
begin
  parent = FactoryBot.create(:parent, email: "test@emory.edu", password: "password")
rescue => e
  parent = Parent.find_by(email: "test@emory.edu")
  raise e unless parent
end

# students
FactoryBot.create(:student, parent: parent, name: "Bobby McNamara")
FactoryBot.create(:student, parent: parent, name: "Tramelgren Didion")
FactoryBot.create(:student, parent: parent, name: "Big Lebowski")
