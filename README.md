Simple P2P
==========

## Prerequisites

- bundler
- Ruby 2.3+
- mysql 5.6+
- phantomjs

## Installation

1. Install sqlite
   `brew install mysql`
2. `bundle install`
3. Run db rake tasks
   `rake db:drop db:create db:migrate db:seed`
4. Run rails application
   `rails server`

## Test Suite

    $ rake

### Test Coverage

If you would like a report of the test coverage, open "coverage/index.html" after running following task:

    $ rake
