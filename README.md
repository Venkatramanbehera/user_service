# 🛠️ User Service with Docker, PostgreSQL, and pgAdmin

This project demonstrates setting up a **Ruby on Rails** application ("User Service") with **Docker**, using **PostgreSQL** as the database and **pgAdmin** for database management.

## 📋 Prerequisites

Ensure you have the following installed:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## 📁 Project Structure

```bash
user_service/
│
├── Dockerfile
├── docker-compose.yml
├── Gemfile
├── Gemfile.lock
├── .env
└── README.md
```

## ⚙️ 1. Setup Environment Variables
Create a .env file in the root directory of the project with the following content:

```bash
  POSTGRES_USER=user
  POSTGRES_PASSWORD=password
  POSTGRES_DB=user_service_development
```

## 🐳 2. Docker Configuration
### Dockerfile   
The Dockerfile sets up the Rails application environment:

```bash
  # Dockerfile

  # Base image
  FROM ruby:3.1.2
  
  # Install dependencies
  RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
  
  # Install the correct Bundler version
  RUN gem install bundler:2.4.13
  
  # Set working directory
  WORKDIR /app
  
  # Copy the Gemfile and Gemfile.lock files
  COPY Gemfile* ./
  
  # Install gems
  RUN bundle install
  
  # Copy the rest of the application code
  COPY . .
  
  # Expose port 3000 for the Rails server
  EXPOSE 3000
  
  # Run database setup, migrations, and start the Rails server
  CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:create db:migrate && bundle exec rails s -b '0.0.0.0'"]
  
```

### docker-compose.yml   
The docker-compose.yml file configures the services: user-service, db (PostgreSQL), and pgadmin.

```bash
  version: '3'

  services:
    db:
      image: postgres:13
      environment:
        POSTGRES_USER: ${POSTGRES_USER}
        POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      ports:
        - "5433:5432"  # Map port 5433 on host to port 5432 in the container
      volumes:
        - pgdata:/var/lib/postgresql/data
  
    user-service:
      build: .
      ports:
        - "3000:3000"
      depends_on:
        - db
      env_file:
        - .env  # Load environment variables from .env file
  
    pgadmin:
      image: dpage/pgadmin4
      environment:
        PGADMIN_DEFAULT_EMAIL: admin@admin.com
        PGADMIN_DEFAULT_PASSWORD: admin
      ports:
        - "8080:80"  # Expose pgAdmin on port 8080
      depends_on:
        - db
  
  volumes:
    pgdata:
```

## 🚀 3. Building and Running the Application To build and start the containers, run the following commands:

```bash
  docker-compose down  # Stop and remove any running containers
  docker-compose up --build  # Rebuild and start the containers
```

## 🌐 4. Accessing the Application 
### Rails Application:   
Open http://localhost:3000 in your browser.   
### PGAdmin: 
Open http://localhost:8080 in your browser.

## 🖥️ 5. Connecting pgAdmin to PostgreSQL
Log in to pgAdmin:

Email: admin@admin.com  
Password: admin  
### Add a New Server: 
General Tab:  
Name: User Service DB  
Connection Tab:  
Host name/address: db (the service name in docker-compose.yml)  
Port: 5432  
Username: user (as per .env)  
Password: password (as per .env)  

## 🗄️ 6. Database Management with Rails
To manage the database using Rails, use the following commands:

Create Database:
```bash
  docker-compose run user-service rails db:create
```
Run Migrations:
```bash
  docker-compose run user-service rails db:migrate
```