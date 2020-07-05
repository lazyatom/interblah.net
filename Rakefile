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

SASS_ROOT = 'public/stylesheets/sass'
SASS_LOAD_PATHS = [
  SASS_ROOT
]
SASS_FILES = FileList["#{SASS_ROOT}/**/*.scss", "#{SASS_ROOT}/**/.sass"].exclude(/tachyons*/)
CSS_FILES = SASS_FILES.pathmap("%{sass/,}X.css")

rule '.css' => ->(f){source_for_css(f)} do |t|
  File.write(t.name, SassC::Engine.new(File.read(t.source), style: :compressed, load_paths: SASS_LOAD_PATHS).render)
end

def source_for_css(css_file)
  SASS_FILES.detect { |f| f.pathmap("%{sass/,}X") == css_file.ext('') }
end

task css: CSS_FILES

CLEAN.include(CSS_FILES)
