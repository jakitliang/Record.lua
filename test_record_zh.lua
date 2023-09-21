--- Record.lua
--- Easy Record Your CRUD Life!
--- Here's the demo using Users model
--- @author Jakit Liang 泊凛
--- @date 2023-09-16
--- @license MIT

local Users = require('model.users')

print('====== 打印表信息 ======')

print(Users.schema.table)
for _, v in ipairs(Users.schema.fields) do
  print(v.name, v.type)
end

print('Users:create()', Users:create())

print('====== 写进 10 条用户 ======')

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

print('====== 删除 ======')

-- 用法 1：筛选删除，根据条件删除
-- Users:destroy({id = 3}) -- 删除 id 为 3 记录

-- 用法 2：在对象上调用销毁方法删除自己记录
-- u:destroy() -- 上面保存了个 user，变量为 u，把它删掉

print('====== 更新 ======')

-- u.age = 50 -- 年龄 改成 50
-- print(u:update()) -- 调用对象的 update 方法更新这个对象的记录

print('====== 获取数据，请使用 fetch 和 fetchOne 方法 ======')

print('====== 获取：所有记录 ======')

-- local result = Users:fetch()
-- for i = 1, #result do
--   print('id', result[i].id)
--   print('name', result[i].name)
--   print('age', result[i].age)
-- end

print('====== 获取：只拉 1 条记录 ======')

-- 只有 1 条记录了，所以不需要 for，但要判断 是否为空
-- Tips: 这个 result 就是 Users 对象
local result = Users:fetchOne()
if result then
  print('id', result.id)
  print('name', result.name)
  print('age', result.age)
end

print('====== 查找数据，请使用 find 和 findOne 方法 ======')

print('====== 查找： ======')

-- local result = Users:find({id = {'<', 6}})
-- for i = 1, #result do
--   print('id', result[i].id)
--   print('name', result[i].name)
--   print('age', result[i].age)
-- end

print('====== 查找：找 id 小于 6 的记录，拿到的结果 我只要 3 条，并 反过来排序 ======')

local result = Users:find({id = {'<', 6}}, 3, true) -- true 参数就是 逆向排序，不加就正排
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== 查找：查找条件 同上，但根据 年龄 进行排序，结果我也只要 3 条 ======')

local result = Users:find({id = {'<', 6}}, 3, 'age')
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== 查找：查找条件 同上，但 从结果中拿 索引为第 1 开始，拿 2 条 ======')

local result = Users:find({id = {'<', 6}}, {1, 2})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

-- 第 1 开始，拿 2 条 什么意思呢？ 比如：
--
-- 偏移 | 数据
-- 0   | id = 1
-- 1   | id = 2 -- 从这里开始
-- 2   | id = 3 -- 到这里结束
-- 3   | id = 4
-- 4   | id = 5
--
-- 从偏移 1 开始，拿 2 条，恰好到 偏移为 2 结束
--
-- 这个功能主要 用来做 【分页】 的
-- 假设分页大小为 10，第一页展示 0 - 9，第二页展示 10 - 19

print('====== 查找：查找条件 同上，但只要 1 条记录 ======')

local result = Users:findOne({id = {'<', 6}})
if result then
  print('id', result.id)
  print('name', result.name)
  print('age', result.age)
end

print('====== 查找：查找 id 在 (2, 3) 这个集合中的数据 ======')
print('====== P.S. 不懂 “集合” 什么意思的请学习 数据结构 ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print('====== 查找：按上面条件找出来，然后把它们年龄改成 50 并更新数据 ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age, ' => 50')
  result[i].age = 50
  result[i]:update() -- 调用 更新方法
end

print('====== 查找：你现在能看到改变了吧？ ======')

local result = Users:find({id = {'in', {2, 3}}})
for i = 1, #result do
  print('id', result[i].id)
  print('name', result[i].name)
  print('age', result[i].age)
end

print()
print('============================')
print('====== [高级进阶] ======')
print('============================')
print()

print('====== 找 1 条数据 ======')

local row = Users:findBy({id = 3}):fetchOne()
if row then
  print('id', row.id)
  print('name', row.name)
  print('age', row.age)
end

print('====== 找 1 条数据，条件为 [id > 8] 或 [name = demo1] 或 [id = 2] ======')

local rows = Users:findBy({id = {'>', 8}}):orWhere({name = 'demo1', id = '2'}):fetchAll()
for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print()
print('=========================================')
print('========   Boss 级进阶：数据事务  ========')
print('=========================================')
print()

print('====== 找出 [id 属集合 (2, 3)] 的数据 ======')

local rows = Users:find({id = {'in', {2, 3}}})

print('====== 事务：开始 ======')

Users:begin()

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
  rows[i].age = 12345
  rows[i]:update()
end

print('====== 事务：回滚!!!!! (回滚上面的 修改操作) ======')

Users:rollback()

print('====== 好啦，你看看数据是不是原封不动 ======')

local rows = Users:find({id = {'in', {2, 3}}})

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print('====== 再来一遍，找出数据 ======')

local rows = Users:find({id = {'in', {2, 3}}})

print('====== 事务：开启 ======')

Users:begin()

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
  rows[i].age = 12345
  rows[i]:update()
end

print('====== 提交!!!!! (提交改动) ======')

Users:commit()

print('====== 好啦，你看看数据是不是成功修改了 ======')

local rows = Users:find({id = {'in', {2, 3}}})

for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end

print('====== 可尝试用 屌炸天的 JavaScript Promise 范式风格来写 ======')

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
    return onFail() -- 调用 失败回滚 并返回
  end
  -- 下面这段代码根本没执行
  rows = Users:find({id = {'in', {2, 3}}})
  for i = 1, #rows do
    print('id', rows[i].id)
    print('name', rows[i].name)
    print('age', rows[i].age)
  end
end)

-- 好啦，现在数据没动
rows = Users:find({id = {'in', {2, 3}}})
for i = 1, #rows do
  print('id', rows[i].id)
  print('name', rows[i].name)
  print('age', rows[i].age)
end
