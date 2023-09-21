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

print('====== Fetch All Result ======')

-- local result = Users:fetch()
-- for i = 1, #result do
--   print('id', result[i].id)
--   print('name', result[i].name)
--   print('age', result[i].age)
-- end

print('====== Fetch One Result ======')

local result = Users:fetchOne()
if result then
  print('id', result.id)
  print('name', result.name)
  print('age', result.age)
end

print('====== Fetch All Result ======')

print('====== Find All Result By Condition ======')

-- local result = Users:find({id = {'<', 6}})
-- for i = 1, #result do
--   print('id', result[i].id)
--   print('name', result[i].name)
--   print('age', result[i].age)
-- end

print('====== Find only 3 results and reverse the result order ======')

local result = Users:find({id = {'<', 6}}, 3, true)
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== Find only 3 results and sort the result by age ======')

local result = Users:find({id = {'<', 6}}, 3, 'age')
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== Find 2 results from index 1 ======')

local result = Users:find({id = {'<', 6}}, {1, 2})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== Find only One result ======')

local result = Users:findOne({id = {'<', 6}})
if result then
  print('id', result.id)
  print('name', result.name)
  print('age', result.age)
end

print('====== Find id in set (2, 3) ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== Find id in set (2, 3) ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== Then update their "age" to 50 ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age, ' => 50')
  result[i].age = 50
  result[i]:update() -- Update this data!
end

print('====== You can see the change now! ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print()
print('============================')
print('====== [Senior Usage] ======')
print('============================')
print()

print('====== Find One ======')

local row = Users:findBy({id = 3}):fetchOne()
if row then
  print('id', row.id)
  print('name', row.name)
  print('age', row.age)
end

print('====== Find the user [id > 8] or [name = demo1] or [id = 2] ======')

local rows = Users:findBy({id = {'>', 8}}):orWhere({name = 'demo1', id = '2'}):fetchAll()
for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print()
print('=========================================')
print('====== Boss task: Data Transaction ======')
print('=========================================')
print()

print('====== Find out data [id in (2, 3)] and modify them ======')

local rows = Users:find({id = {'in', {2, 3}}})

Users:begin()

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
  rows[i].age = 12345
  rows[i]:update()
end

print('====== Rolling back!!!!! (Undo changes) ======')

Users:rollback()

local rows = Users:find({id = {'in', {2, 3}}})

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print('====== Find out data [id in (2, 3)] and modify them ======')

local rows = Users:find({id = {'in', {2, 3}}})

Users:begin()

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
  rows[i].age = 12345
  rows[i]:update()
end

print('====== Commit it!!!!! (Commit changes) ======')

Users:commit()

local rows = Users:find({id = {'in', {2, 3}}})

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print('====== Promise style Transaction ======')

Users:transaction(function (onFail)
  local rows = Users:find({id = {'in', {2, 3}}})
  for i = 1, #rows do
    print('id', rows[i].id)
    print('name', rows[i].name)
    print('age', rows[i].age)
    rows[i].age = 999
    rows[i]:update()
  end
  if true then
    return onFail() -- Undo changes and return
  end
  -- The code below will not do
  rows = Users:find({id = {'in', {2, 3}}})
  for i = 1, #rows do
    print('id', rows[i].id)
    print('name', rows[i].name)
    print('age', rows[i].age)
  end
end)

-- You can see data is successfuly rollback
rows = Users:find({id = {'in', {2, 3}}})
for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end
