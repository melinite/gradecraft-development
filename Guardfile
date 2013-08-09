guard :minitest, :all_on_start => false do
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^app/models/(.*)\.rb|) { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r|^lib/(.*)([^/]+)\.rb|) { |m| "test/#{m[1]}test_#{m[2]}.rb" }
end
