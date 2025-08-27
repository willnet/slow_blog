# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails blog application designed as a performance testing exercise. The app intentionally contains performance-related issues with Active Record queries that need to be identified and optimized. It features users, blog posts, comments, and a session-based authentication system.

## Development Setup

### Initial Setup
```bash
bin/setup
```
This will install dependencies, prepare the database, and start the development server.

### Start Development Server
```bash
bin/dev
```
Starts the Rails server using Foreman on port 3000.

### Database Operations
```bash
bin/rails db:migrate
bin/rails db:seed
bin/rails db:prepare  # Creates and seeds database
```

### Testing
```bash
bin/rails test
bin/rails test:system
rake test:performance  # Performance tests specifically
```

## Key Architecture Components

### Models
- **User**: Has secure password, owns posts and comments, has many sessions
- **Post**: Belongs to user, has many comments 
- **Comment**: Belongs to post and user
- **Session**: Handles user authentication (custom session management)
- **Page**: Custom pagination helper class

### Controllers
- **ApplicationController**: Includes Authentication concern, modern browser restriction
- **WelcomeController**: Homepage with recent posts (limit 5)
- **PostsController**: Full CRUD for posts, allows unauthenticated access to index/show
- **CommentsController**: Nested under posts
- **SessionsController**: Authentication
- **PasswordsController**: Password reset functionality

### Authentication
- Custom session-based authentication via `Authentication` concern
- Sessions stored in database with IP and user agent
- Uses signed permanent cookies
- `Current` thread-local storage for session management

### Views & Assets
- Uses Pico CSS framework (replaced from default styling)
- Importmap for JavaScript management
- Turbo and Stimulus for SPA-like behavior
- Basic responsive design

## Performance Testing

This application includes:
- Performance test suite in `performance_test/`
- Custom assertion `assert_queries_count_lteq` for query count validation
- Test helper that expects homepage to use ≤3 queries
- Blog content generator for creating realistic test data

## Database Schema

- SQLite3 database with proper foreign key constraints
- Indexes on user_id fields for posts/comments/sessions
- Unique index on user email_address

## Data Generation

The `BlogContentGenerator` class creates realistic blog content with:
- Varied blog post titles and content templates
- Technology-focused content with realistic templates
- Comment generation with different response patterns
- Seeds realistic data for performance testing

## Performance Optimization Focus

This codebase is specifically designed to have N+1 query problems and other performance issues. When working on performance improvements:

1. Look for missing `includes` for eager loading
2. Check for repeated queries in loops
3. Analyze pagination query efficiency
4. Review index usage and query patterns
5. Use the performance test suite to validate improvements

## Common Tasks

- Add new blog post: Use PostsController#new
- View user's posts: `/users/:id/posts`
- Authentication: Session-based, no external gems like Devise
- Add comments: Nested under posts
- Performance testing: `rake test:performance`