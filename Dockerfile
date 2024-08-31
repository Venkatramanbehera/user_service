# Dockerfile

#Base Image
FROM ruby:3.1.2

# Install dependecies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client 

# Set working directory
WORKDIR /app

# copy the gemfile and gemfile.loc files
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 for the Rails Server
EXPOSE 3000

# Run database migrations and start the Rails server
CMD [ "bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:migrate && bundle exec rails s -b '0.0.0.0'" ]