#!/usr/bin/env ruby

# Get the branch name from the command-line argument
branch_name = ARGV[0]

# Check if a branch name is provided
if branch_name.nil?
  puts "Please provide a branch name."
  exit 1
end

# Set the AWS profile
profile = 'your_aws_profile_name'  # Replace with your AWS profile name
ENV['AWS_PROFILE'] = profile

# Checkout main branch and pull latest changes
system('git checkout main')
system('git pull origin main')

# Prompt for confirmation to deploy release branch to main
print "Do you want to deploy the #{branch_name} branch to main? (y/n) "
confirm = gets.chomp

if confirm == "y"
  # Prompt for confirmation to continue if QA and release branch are not even
  if system("git diff main...#{branch_name}")
    puts "The QA and release branches are not even."
    system("git diff main...#{branch_name}")
    print "Do you want to continue with deployment? (y/n) "
    confirm = gets.chomp
    unless confirm == "y"
      puts "Deployment cancelled."
      exit 1
    end
  end

  # Push release branch to main
  system("git push origin #{branch_name}:main")

  # Create new release branch with name format release/so#{number}/date-2-mondays from-today
  number = `git branch -r | awk -F/ '/release\\/so/{print $2}' | sort -rn | head -n1`.to_i + 1
  date = Time.now.strftime('%Y-%m-%d')
  branch_name = "release/so#{number}/#{date}-2-mondays"
  system("git checkout -b #{branch_name}")
  system("git push origin #{branch_name}")

  puts "Deployment to main and creation of new release branch successful."
else
  puts "Deployment cancelled."
  exit 1
end
