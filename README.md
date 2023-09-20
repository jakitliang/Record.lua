# Record.lua

> Easy Record Your CRUD Life!

## Intro

`Record.lua` is the extreamly funky way to play with your data.

### Suitable situations

#### Web server db module

`Record.lua` can work as a ORM to doing data CRUD and transactions.

Transactions provide by `Record.lua` can help you easily rollback the failure process only 1 line code.

#### Game development

Sometimes you are writing a large MMORPG game you may processing many tables.

* Love2d
* cocos2dx-lua

## Use case

Here's an example you can find at `test_record.lua` and `model/users.lua`.

### Models

You can simply generate or write a model like `model/users.lua` did.

Don't you think it looks like `ActiveRecord`'s schema? Or `SQLAlchemy`'s schema?

### Pracice

The basic usage is under `test_record.lua`, such like:

* create - Create table
* save - Store new row
* destroy - Delete one row or rows by filtering conditions
* update - Update an entry to the row
* findBy - Search and filter, then fetching one or more as you want.

## Roadmap

* Preview <- Current state
* Beta
* Release

## Copyright

This module is MIT-Licensed.
