require 'vanilla'
require 'rake/clean'
require 'sassc'

# Add any other tasks here.

task :convert do
  old_backend = Soup::Backends::YAMLBackend.new("soup")
  old_soup = Soup.new(old_backend)
  new_soup = Soup.new(Soup::Backends::FileBackend.new("new_soup"))

  old_backend.names.each { |s| new_soup << old_soup[s].attributes }
end

task :blog do
  print "Title: "
  title = $stdin.gets.chomp
  path = "soups/blog/#{title.downcase.gsub(/[^\w]+/, "-")}.snip.markdown"
  time = Time.now.strftime("%Y-%m-%d %H:%M:%S %z")
  File.open(path, "w") do |f|
    f.puts title
    f.puts "=" * title.length
    f.puts
    f.puts
    f.puts
    f.puts ":kind: blog"
    f.puts ":created_at: #{time}"
    f.puts ":updated_at: #{time}"
  end
  `subl #{path}:4`
end

task :css do
  `sassc --style compressed --sourcemap public/stylesheets/scss/interblah.scss public/stylesheets/interblah.css`
end

CLEAN.include(FileList['public/stylesheets/*.css', 'public/stylesheets/*.map'])
