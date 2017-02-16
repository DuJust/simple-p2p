---
title: API Reference

language_tabs:
  - http

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Simple P2P API reference.

# Accounts

## Create an account

```http
POST /api/v1/accounts HTTP/1.1
Accept: application/json

{
  "account": {
    "balance":"100"
  }
}
```
```http
HTTP/1.1 200 OK
{
    "id": 1,
    "balance": "100.00",
    "lend": "0.00",
    "borrow": "0.00"
}
```

You can create a new account sending a POST to `/api/v1/accounts` with the necessary attributes. balance is required.

## Show an account

```http
GET /api/v1/accounts/1 HTTP/1.1
Accept: application/json
```
```http
HTTP/1.1 200 OK
{
    "id": 1,
    "balance": "100.00",
    "lend": "0.00",
    "borrow": "0.00"
}
```

You can retrieve an account’s info by sending a GET request to /api/v1/accounts/{id}.

## Show debt between two accounts

```http
GET /api/v1/accounts/debt HTTP/1.1
Accept: application/json
{
  "account_a": 1,
  "account_b": 2
}
```
```http
HTTP/1.1 200 OK
{
    "amount": "0.00"
}
```

You can GET debt in /api/v1/accounts/debt. account_a and account_b are required. When the amount is larger than 0, it
 means that account_a lend more money to account_b than account_a borrow money from account_b.

# Transactions

## Loan

```http
POST /api/v1/transactions/loan HTTP/1.1
Accept: application/json
{
    "transaction": {
        "debit_id":1,
        "credit_id":2,
        "amount":"3"
    }
}
```
```http
HTTP/1.1 200 OK
{
    "id": 1,
    "debit_id": 1,
    "credit_id": 2,
    "amount": "3.00",
    "event": "loan"
}
```

You can create a loan transaction by POST /api/v1/transactions/loan. debit_id, credit_id and amount are required. 
debit_id and credit_id could not be the same. amount could not be less than zero. It means that debit borrow money 
from credit.

## Repay

```http
POST /api/v1/transactions/repay HTTP/1.1
Accept: application/json
{
    "transaction": {
        "debit_id":1,
        "credit_id":2,
        "amount":"3"
    }
}
```
```http
HTTP/1.1 200 OK
{
    "id": 1,
    "debit_id": 1,
    "credit_id": 2,
    "amount": "3.00",
    "event": "repay"
}
```

You can create a repay transaction by POST /api/v1/transactions/repay. debit_id, credit_id and amount are required. 
debit_id and credit_id could not be the same. amount could not be less than zero. amount could not be larger than the
 debt between debit and credit. It means that debit repay the money to credit.
