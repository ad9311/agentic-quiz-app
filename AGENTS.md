# Repository Guidelines

## App Overview
The AI Development Quiz App helps learners test and reinforce AI software development concepts (agent design, prompt engineering, workflow automation) through rich text quiz content. It exposes a RESTful API to manage quizzes, track user attempts, and calculate scores while keeping business logic clear and extensible.

## General Requirements
- Build a RESTful API that serves rich text quiz content (not plain text).
- Demonstrate clean REST design and implementation conventions.
- Implement proper data modeling and persistence.
- Support easy expansion with new quizzes or question sets.
- Handle business logic for quiz scoring and progress tracking.
- Implement asynchronous communication with external services.
- Write clean, maintainable code with appropriate error handling.

## Project Structure & Module Organization
- `app/` holds Rails application code (controllers, models, views, jobs, mailers).
- `config/` contains environment, routes, and service configuration (`database.yml`, `cable.yml`, `queue.yml`).
- `db/` stores schema and seed data (`db/schema.rb`, `db/seeds.rb`).
- `test/` contains Minitest suites and fixtures.
- `public/`, `storage/`, `tmp/`, `log/` are runtime assets and generated output.
- `bin/` provides app scripts for setup, server, lint, and CI.

## Build, Test, and Development Commands
- `bin/setup` installs gems and prepares the database; add `--reset` to rebuild DB.
- `bin/dev` runs the Rails server for local development.
- `bin/rails db:prepare` ensures the database is created and migrated.
- `bin/ci` runs the full CI recipe (lint, security, tests, seed validation).
- `bin/rubocop`, `bin/brakeman`, `bin/bundler-audit` run style and security checks.
- Always try to run `rubocop -A` to keep formatting consistent, but ask for approval first.

## Coding Style & Naming Conventions
- Ruby uses 2-space indentation; keep lines <= 120 chars (`.rubocop.yml`).
- Classes/modules are `CamelCase`; files and methods are `snake_case`.
- Tests live in `test/` with names like `user_test.rb` and `users_controller_test.rb`.
- Run `bin/rubocop` before shipping changes.
- Always create models by running `bin/rails generate model [model_name]`.
- Business logic lives in `app/services/` as centralized service objects.
- Service objects must always be called with a `.call` method and return a Result struct (no nil-only flows).
- Controllers stay thin: parameter handling and rendering only.
- Models should always validate their state (no bypassed validations).

## Testing Guidelines
- Framework: Minitest (`rails/test_help`).
- After creating a test file, run it to confirm it passes.
- Run all tests with `bin/rails test`.
- Run a single test file: `bin/rails test test/models/user_test.rb`.
- Seed verification is part of CI: `env RAILS_ENV=test bin/rails db:seed:replant`.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative, and capitalized (e.g., "Add sidekiq gem").
- PRs should describe the change, list tests run, and link relevant issues.
- Include screenshots or screen recordings for UI changes.

## Security & Configuration Tips
- Keep secrets in credentials (`config/credentials.yml.enc`); avoid committing plaintext.
- Review DB and queue config in `config/` before deploying or running jobs.
