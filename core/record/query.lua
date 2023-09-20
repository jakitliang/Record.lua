--- Record.lua
--- Simplefy Your CRUD Life!
--- @module 'Query'
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Type = require('core.type')

--- @class Query
--- @field table string
--- @field condition table
--- @field order string|nil
--- @field sql string
local Query = Type()

function Query:new(record)
  self.record = record
  self.condition = {}
  self.order = nil
  self.sql = ''
end

function Query:where(condition)
  if #self.condition > 0 then
    table.insert(self.condition, 'and')
  end

  if type(condition[2]) == 'table' then
    table.insert(self.condition, '`'..condition[1] .. '` '..condition[2][1] .. " '"..condition[2][2] .. "'")

  else
    table.insert(self.condition, '`'..condition[1] .. "` = '"..condition[2] .. "'")
  end

  return self
end

function Query:orWhere(condition)
  if #self.condition > 0 then
    table.insert(self.condition, 'or')
  end

  if type(condition[2]) == 'table' then
    table.insert(self.condition, condition[1] .. ' ' .. condition[2][1] .. " '" .. condition[2][2] .. "'")

  else
    table.insert(self.condition, condition[1] .. " = '"..condition[2] .. "'")
  end

  return self
end

function Query:orderBy(field, reversed)
  if reversed then
    self.order = field .. ' desc'
    return self
  end

  self.order = field .. ' asc'
  return self
end

function Query:fetchOne()
  local sql = 'select * from ' .. self.record.schema.table
  if #self.condition > 0 then
    sql = sql .. ' where ' .. table.concat(self.condition, ' ')
  end
  if self.order then
    sql = sql .. ' order by ' .. self.order
  end
  self.sql = sql .. ' limit 1'
  -- print(self.sql)
  return self.record.device:fetch(self.sql)
end

function Query:count()
  local sql = 'select count(*) from ' .. self.record.schema.table
  if #self.condition > 0 then
    sql = sql .. ' where ' .. table.concat(self.condition, ' ')
  end
  self.sql = sql
  -- print(self.sql)
  return self.record.device:fetch(self.sql)
end

function Query:fetchAll()
  local sql = 'select * from ' .. self.record.schema.table
  if #self.condition > 0 then
    sql = sql .. ' where ' .. table.concat(self.condition, ' ')
  end
  if self.order then
    sql = sql .. ' order by ' .. self.order
  end
  self.sql = sql
  -- print(self.sql)
  return self.record.device:fetch(self.sql)
end

function Query:fetch(from, to)
  local sql = 'select * from ' .. self.record.schema.table
  if #self.condition > 0 then
    sql = sql .. ' where ' .. table.concat(self.condition, ' ')
  end
  if self.order then
    sql = sql .. ' order by ' .. self.order
  end
  sql = sql .. ' limit ' .. from
  if to then
    sql = sql .. ', ' .. to
  end
  self.sql = sql
  -- print(self.sql)
  return self.record.device:fetch(self.sql)
end

local function parseValue(record)
  local names, values = {}, {}
  local field

  for i = 1, #record.schema.fields do
    field = record.schema.fields[i]

    if record[field.name] then
      table.insert(names, field.name)
      table.insert(values, "'" .. record[field.name] .. "'")
    end
  end

  return names, values
end

function Query:insert()
  local sql = 'insert into `' .. self.record.schema.table .. "` "
  local names, values = parseValue(self.record)
  sql = sql .. '(`' .. table.concat(names, "`, `") .. '`)'
  sql = sql .. ' values '
  self.sql = sql .. '(' .. table.concat(values, ', ') .. ')'
end

function Query:update()
  local sql = 'update `' .. self.record.schema.table .. '` set '
  local values = {}
  local field

  for i = 1, #self.record.schema.fields do
    field = self.record.schema.fields[i]

    if self.record[field.name] then
      table.insert(values, '`'..field.name.."` = '"..self.record[field.name] .. "'")
    end
  end

  sql = sql .. table.concat(values, ", ")

  if self.condition == 0 then
    return
  end

  self.sql = sql .. ' where ' .. table.concat(self.condition, ' ')
end

function Query:delete()
  local sql = 'delete from `' .. self.record.schema.table .. '` '
  if self.condition == 0 then
    return
  end
  self.sql = sql .. 'where ' .. table.concat(self.condition, ' ')
end

function Query:exec()
  return self.record.device:exec(self.sql)
end

return Query
