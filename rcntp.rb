require 'open3'
require 'time'

def recent_push_to_main?(time_threshold)
  cmd = "git log --since='#{time_threshold.iso8601}' origin/main..main"
  stdout, stderr, status = Open3.capture3(cmd)

  if status.success? && !stdout.empty?
    # The main branch has had a recent push
    return true
  else
    # The main branch has not had a recent push
    return false
  end
end

# Calculate the time threshold
current_time = Time.now
time_threshold_hour = current_time - 3600   # 1 hour
time_threshold_day = current_time - 86400   # 1 day

# Check if main branch has had a recent push in the last hour
if recent_push_to_main?(time_threshold_hour)
  puts "The main branch has had a recent push in the last hour."
else
  puts "The main branch has not had a recent push in the last hour."
end

# Check if main branch has had a recent push in the last day
if recent_push_to_main?(time_threshold_day)
  puts "The main branch has had a recent push in the last day."
else
  puts "The main branch has not had a recent push in the last day."
end
