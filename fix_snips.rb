require "time"

snips = Dir["soups/**/*"].reject { |p| File.directory?(p) }.reject { |p| p =~ /\.rb$/ }.reject { |p| File.read(p) =~ /:updated_at/ }

def latest_git_commit(path)
  details = `git log -- #{path}`
  date_line = details.split("\n").find { |l| l =~ /^Date:/ }
  if date_line
    Time.parse(date_line.gsub("Date:", "").strip)
  end
end

snips.each do |s|
  updated_at = latest_git_commit(s)
  if updated_at
    puts "Processing: #{s}"

    str = ":updated_at: #{updated_at.to_s}\n"
    content = File.read(s)
    prefix = if content =~ /\n\n:/
      puts "Found metadata"
      "\n"
    else
      puts "No metadata"
      "\n\n"
    end
    File.open(s, 'a') do |f|
      f.puts("#{prefix}#{str}")
    end
    puts
  end
end
