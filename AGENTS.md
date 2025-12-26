# Repository Guidelines

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

## Coding Style & Naming Conventions
- Ruby uses 2-space indentation; keep lines <= 120 chars (`.rubocop.yml`).
- Classes/modules are `CamelCase`; files and methods are `snake_case`.
- Tests live in `test/` with names like `user_test.rb` and `users_controller_test.rb`.
- Run `bin/rubocop` before shipping changes.
- Business logic lives in `app/services/` as centralized service objects.
- Service objects must always return a result object or value (no nil-only flows).
- Controllers stay thin: parameter handling and rendering only.
- Models should always validate their state (no bypassed validations).

## Testing Guidelines
- Framework: Minitest (`rails/test_help`).
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
