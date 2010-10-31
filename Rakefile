require 'vanilla'
load 'tasks/vanilla.rake'

# Add any other tasks here.

task :convert do
  old_backend = Soup::Backends::YAMLBackend.new("soup")
  old_soup = Soup.new(old_backend)
  new_soup = Soup.new(Soup::Backends::FileBackend.new("new_soup"))

  old_backend.names.each { |s| new_soup << old_soup[s].attributes }
end