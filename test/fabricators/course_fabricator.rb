Fabricator(:course) do
  name 'Defense Against the Dark Arts'
  courseno 101
  year Date.today.year
  semester %w{Fall Winter Spring Summer}.sample
  team_setting true
  group_setting true
  total_assignment_weight 6
  max_assignment_weight 5
end
