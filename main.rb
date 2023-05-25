require 'open3'

def update_branch(branch)
  # Fetch the latest changes from the remote branch
  system("git fetch origin #{branch}")

  # Reset the branch to the latest remote commit
  system("git reset --hard origin/#{branch}")

  if $?.success?
    puts "Updated #{branch} branch with the latest changes."
  else
    puts "Failed to update #{branch} branch."
  end
end

def make_branch_even_with_main(branch)
  # Checkout the branch
  system("git checkout #{branch}")

  # Update the branch with the latest changes
  update_branch(branch)

  # Prompt for confirmation
  print "Do you want to make the #{branch} branch even with main? (y/n) "
  confirm = gets.chomp.downcase

  if confirm == 'y'
    # Pull the latest changes from the main branch
    system('git pull origin main')
    system("git checkout main")
    system("git branch -D #{branch}")
    system("git push origin --delete #{branch}")
    system("git checkout -b #{branch}")
    system("git push --set-upstream origin #{branch}")

    if $?.success?
      puts "Merged changes from main into the #{branch} branch."
    else
      puts "Failed to merge changes from main into the #{branch} branch."
    end
  else
    puts "Skipped making the #{branch} branch even with main."
  end
end

def make_branches_even_with_main
  branches = ['qa', 'stage', 'dev']

  branches.each do |branch|
    make_branch_even_with_main(branch)
  end

  # Switch back to the main branch
  system('git checkout main')

  puts "Switched back to the main branch." if $?.success?
end

# Make branches even with main
make_branches_even_with_main

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
