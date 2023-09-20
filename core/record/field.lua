--- Record.lua
--- Simplefy Your CRUD Life!
--- @module 'Field'
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Type = require('core.type')

--- @class Field
--- @field integer string
--- @field real string
--- @field text string
--- @field blob string
--- @field datetime string
local Field = Type({
  integer = 'integer',
  real = 'real',
  text = 'text',
  blob = 'blob',
  datetime = 'datetime'
})

function Field:new(name, type)
  self.name = name
  self.type = type
  self.primaryKey = false
  self.autoincrement = false
end

return Field
