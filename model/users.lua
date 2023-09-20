--- Record.lua
--- Easy Record Your CRUD Life!
--- @module 'Users'
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Type = require('core.type')
local SQLiteRecordDevice = require('core.record.device.sqlite_device')
local Schema = require('core.record.schema')
local Record = require('core.record')

--- @class Users : Record
local Users = Type({
  device = SQLiteRecordDevice(),
  schema = Schema('users', function (schema)
    schema:text('name')
    schema:integer('age')
  end),
}, Record)

return Users
