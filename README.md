
Simple P2P
==========

### Prerequisites

- bundler
- Ruby 2.3+
- mysql 5.6+

### Installation

1. Install sqlite
   `brew install mysql`
2. `bundle install`
3. Run db rake tasks
   `rake db:drop db:create db:migrate db:seed`
4. Run rails application
   `rails server`

### Test Suite

    $ rake

### Test Coverage

If you would like a report of the test coverage, open "coverage/index.html" after running following task:

    $ rake
### API

I use `slate` for the API reference. 

```
$ ./docs_build.sh
$ rails server
$ open http://localhost:3000/docs/index
```

### Basic Design

Simple P2P is using Rails API, active_model_serializers and mysql. 

There're two tables:                                                       

##### Accounts

| column  |                 meaning                  |
| :-----: | :--------------------------------------: |
| balance | remain money(assume cannot larger than 999999999999.99) |
| borrow  |     total borrow amount from others      |
|  lend   |       total lend amount to others        |

##### Transactions

|  column   |          meaning           |
| :-------: | :------------------------: |
| debit_id  |      who borrow money      |
| credit_id |       who lend money       |
|  amount   | amount in this transaction |
|   event   |   loan/repay transaction   |

For every p2p transaction, the app will firstly validate account existence and the difference between the accounts, check the remaining balance of account with the given amount and also the debt between these accounts. Then it will lock two account with mysql database pessimistic lock, update by amount and create a transaction. All the update operations are under by database transaction.

Instead of Fat Model stratery, I use plan old ruby object, `loan`, `repay`and `debt` as Service Object, to handle all business logic. All codes are TDD and test covered.
