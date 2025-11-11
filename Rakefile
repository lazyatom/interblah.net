require 'vanilla'
require 'rake/clean'
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
  `emacsclient -n +4 #{path}`
end

task :css do
  `npx sass --silence-deprecation=import --silence-deprecation=slash-div --style=compressed --source-map public/stylesheets/scss/interblah.scss public/stylesheets/interblah.css`
end

task :purgecss do
  require 'tempfile'
  file = Tempfile.new('purgecss')

  # Fetch multiple pages to get all used classes
  pages = [
    'http://interblah.test/site-test',
    'http://interblah.test/',  # homepage with body.start
    # Add more pages here if needed
  ]

  # Download all pages
  pages.each_with_index do |url, i|
    `curl --silent #{url} >> #{file.path}`
  end

  # Run purgecss on combined HTML
  `purgecss --config ./purgecss.config.js --css public/stylesheets/interblah.css --content #{file.path} --output public/stylesheets/interblah.min.css`
ensure
  file.unlink if file
end

CLEAN.include(FileList['public/stylesheets/*.css', 'public/stylesheets/*.map'])

namespace :assets do
  task :precompile do
    puts "Running pre-compile"
  end
end
