# Rails SQL Chatbot

A Rails application with MySQL database and Redis for caching, featuring a SQL chatbot powered by Gemini API.

## Docker Deployment

This application is fully containerized with Docker and includes MySQL and Redis services.

### Prerequisites

- Docker and Docker Compose installed on your system
- Gemini API key

### Quick Start

1. Clone the repository
2. Create a `.env` file from the example:
   ```
   cp .env.example .env
   ```
3. Edit the `.env` file and add your Gemini API key and other credentials
4. Build and start the containers:
   ```
   docker-compose up -d
   ```
5. Access the application at http://localhost:3000

### Environment Variables

- `RAILS_MASTER_KEY`: Your Rails master key
- `MYSQL_USER`: MySQL username (default: root)
- `MYSQL_PASSWORD`: MySQL password
- `MYSQL_HOST`: MySQL host (default: db)
- `MYSQL_PORT`: MySQL port (default: 3306)
- `REDIS_URL`: Redis connection URL (default: redis://redis:6379/1)
- `GEMINI_API_KEY`: Your Google Gemini API key

## Features

* Ruby version: 3.2.2
* Rails version: 7.2.2
* Database: MySQL
* Caching: Redis
* Python integration with Gemini API

## Development

For local development without Docker:

1. Install dependencies:
   ```
   bundle install
   ```
2. Set up the database:
   ```
   rails db:create db:migrate
   ```
3. Start the server:
   ```
   rails server
   ```

## Testing

```
rails test
```
