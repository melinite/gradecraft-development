Fabricator(:badge_set) do
  name { sequence(:badge_set_name) { |i| "Badge Set #{i}" } }
end
