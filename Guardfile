group :specs do
  guard :rspec do
    watch(%r{^spec/.+_spec\.rb$})
  end
end

group :acceptance do
  guard :rspec, :cli => "--tag acceptance" do
    watch(%r{^spec/acceptance/.+_spec\.rb$})
  end
end