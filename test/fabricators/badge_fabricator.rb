Fabricator(:badge) do
  name { sequence(:badge_name) { |n| "Badge #{n}" } }
end
