#!/usr/bin/env ruby

require 'open3'

# Check if branches are even with main
def branches_even_with_main?
  branches = ['qa', 'stage', 'dev']
  result = {}

  branches.each do |branch|
    cmd = "git diff main...#{branch}"
    stdout, _, status = Open3.capture3(cmd)
    result[branch] = stdout.empty? && status.success?
  end

  result
end

branch_statuses = branches_even_with_main?

branch_statuses.each do |branch, status|
  if status
    puts "The #{branch} branch is even with the main branch."
  else
    puts "The #{branch} branch is not even with the main branch."
  end
end