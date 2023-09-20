--- Record.lua
--- Easy Record Your CRUD Life!
--- @module 'Record'
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Type = require('core.type')

local Field = require('core.record.field')
local Schema = require('core.record.schema')
local Query = require('core.record.query')

--- Provide Record
--- @class Record
--- @field device Device
--- @field schema Schema
--- @overload fun():self
local Record = Type()

function Record:new() end

--- Create table schema if not exists
--- @return boolean status
function Record:create()
  local sql = 'create table if not exists `'..self.schema.table.. "` (\n"
  local lines = {}

  for i = 1, #self.schema.fields do
    local field = self.schema.fields[i]
    local part = '`'..field.name..'` '..field.type
    if field.primaryKey then
      part = part .. ' primary key'

      if field.autoincrement then
        part = part .. ' autoincrement'
      end
    end
    table.insert(lines, part)
  end

  sql = sql .. table.concat(lines, ",\n") .. "\n)"
  return self:query(sql)
end

--- Save a record
--- @return boolean status
function Record:save()
  local query = self:newQuery()
  query:insert()

  if self:query(query) then
    self.id = self.device:lastId()
    return true
  end

  return false
end

--- Find records by condition
--- @return Query query
function Record:findBy(condition)
  local query = self:newQuery()
  for k, v in pairs(condition) do
    query:where({k, v})
  end
  return query
end

--- Update a record
--- @return boolean status
function Record:update()
  local query = self:newQuery()
  query:where({'id', self.id})
  query:update()
  return self:query(query)
end

--- Destroy a record or delete records by condition
--- @return boolean status
function Record:destroy(condition)
  local query = self:newQuery()

  if condition then
    for k, v in pairs(condition) do
      query:where({k, v})
    end

  elseif self.id then
    query:where({'id', self.id})
  end

  query:delete()
  return self:query(query)
end

--- Execute a query
--- @return boolean status
function Record:query(query)
  if type(query) == 'string' then
    local sql = query
    query = self:newQuery()
    query.sql = sql
  end

  -- print(query.sql)
  Record.lastQuery = query
  return query:exec()
end

--- Create a new query
--- @return Query
function Record:newQuery()
  return Query(self)
end

--- Transaction begin
--- @return boolean status
function Record:begin()
  return self.device:begin()
end

--- Transaction rollback and finished
--- @return boolean status
function Record:rollback()
  return self.device:rollback()
end

--- Transaction commit and finished
--- @return boolean status
function Record:commit()
  return self.device:commit()
end

return Record
