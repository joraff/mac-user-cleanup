#!/usr/bin/env ruby -wKU


# Script that cleans up user directories after they've become a certain age. We don't want to delete them immediately
#  because that would cause lots of user disgruntledness, and I don't want to move them to a temporary location that only I know
#  about because that would make more work for me if someone wanted to recover their work.
#
# I'm initially going to try 3 days. That should persist long enough in case someone walks away without saving their document elsewhere,
#  but not cause too much trash to accumulate. I really could go several months with the size of today's hard drives, but I want the
#  profiles to remain fresh copies of the template, and I don't want users to grow accustomed to expecting their personalizations and files
#  to be there all the time.

def log(s)
  puts s
  `logger -t "User Cleanup.rb" #{s}`
end

# Define an age we should allow.
age_threshold = 318

# Define a directory to check (should always be /Users)
dir = "/Users/"
skip = ["admin"]

# Interate through all the files in dir
`ls #{dir}`.each do |f| 
  f.strip!
  age = (Time.now - File.new("#{dir}/#{f}").mtime.to_i).to_i / 86400 # age in days
  if age >= age_threshold
    unless skip.include? f
      #`rm -rf "#{dir}#{f}"` 
      log "User #{f} was deleted at #{age} days old"
    else
      log "User #{f} was NOT deleted. Reason: predefined skip exception"
    end
  else
    log "User #{f} was NOT deleted at #{age} days old. Reason: not old enough to delete"
  end
end



