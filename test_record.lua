--- Record.lua
--- Easy Record Your CRUD Life!
--- Here's the demo using Users model
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Users = require('model.users')

print('====== Print schema info ======')

print(Users.schema.table)
for _, v in ipairs(Users.schema.fields) do
  print(v.name, v.type)
end

print('Users:create()', Users:create())

print('====== Insert ======')

for i = 1, 10 do
  local u = Users()
  u.name = 'demo'..i
  u.age = i
  print('User.save', u, u:save(), u.id)
end

local u = Users()
u.name = 'demo3'
u.age = 30
print('User.save', u, u:save(), u.id)

print('====== Destroy ======')

-- Users:destroy({id = 3})
-- u:destroy()

print('====== Update ======')

-- u.age = 50
-- print(u:update())

print('====== Find One ======')

local q = Users:findBy({id = 3})
for row in q:fetchOne() do
  for k, v in pairs(row) do
    print(k, v)
  end
end

print('====== Find All ======')

local q = Users:findBy({id = {'>', 3}}):orderBy('id', true)
for row in q:fetchAll() do
  for k, v in pairs(row) do
    print(k, v)
  end
end

print('====== Find All With Limit ======')

local q = Users:findBy({id = {'>', 3}}):orderBy('id', true)
for row in q:fetch(1, 3) do
  for k, v in pairs(row) do
    print(k, v)
  end
end

print('====== Find Total Count ======')

local q = Users:findBy({id = {'>', 3}}):orderBy('id', true)
for row in q:count() do
  for k, v in pairs(row) do
    print(k, v)
  end
end
