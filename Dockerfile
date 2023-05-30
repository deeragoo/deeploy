# Use the latest Ruby base image
FROM ruby:latest

# Set the working directory inside the Docker image
WORKDIR /app


# Copy the app code from your local machine to the Docker image
COPY . /app

# Install dependencies specified in the Gemfile
RUN bundle install

# Specify the port on which your app listens
EXPOSE 6161

# Define the command to run your app
CMD ["rerun", "--pattern", "app.rb", "--", "puma"]