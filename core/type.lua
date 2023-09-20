--- Type.lua
--- A simple and tiny Rich Type Programming module
--- @author Jakit Liang 泊凛
--- @date 2023-08-31
--- @license MIT

local TypeMetatable = {}

--- <b>Create new type inherit to the parent type:</b> <br>
--- 1. Type() # Create class type without inheritance <br>
--- 2. Type({...}) # Create class type {...} without inheritance <br>
--- 3. Type(Parent); # Create class type and inherit from Parent <br>
--- 4. Type({...}, Parent); # Create class type {...} and inherit from Parent
--- @class Type : table
--- @field getSuper fun(self:self):table Get super class
--- @field inheritof fun(self:self, type:table|function):boolean Check class inheritance
--- @overload fun(base: table, parent:table|function):table
--- @overload fun(parent: table|function):table
--- @overload fun(base: table):table
--- @overload fun():table
local Type = setmetatable({}, TypeMetatable)

local function GetSuper(type)
  --- @cast Type table
  return rawget(Type, type)
end

--- Check whether the type is inherit from the specified type
--- @param _t table Type to be checked
--- @param type table|function Target type
--- @return boolean bool The check result
local function Inheritof(_t, type)
  if _t == type then
    return true
  end

  while GetSuper(_t) do
    _t = GetSuper(_t)
    if _t == type then
      return true
    end
  end

  return false
end

--- Mixin a module to the base type <br>
--- Using mixin means <b>no inherit relationship</b>
--- @param base any The object or type to be mixin
--- @param module any The mixin traits module
local function Mixin(base, module)
  for k, v in pairs(module) do
    if string.find(k, '__') or k == 'new' then
      goto continue
    end

    base[k] = base[k] or module[k]

    ::continue::
  end

  return base
end

--- <b>Create new type inherit to the parent type:</b> <br>
--- 1. Type() # Create class type without inheritance <br>
--- 2. Type({...}) # Create class type {...} without inheritance <br>
--- 3. Type(Parent); # Create class type and inherit from Parent <br>
--- 4. Type({...}, Parent); # Create class type {...} and inherit from Parent
--- @private
--- @overload fun(parent: table|function):table
--- @overload fun(base: table):table
--- @overload fun():table
--- @param base table Base type or Parent type
--- @param parent table|function Parent type or not given
--- @return table Type New type
function TypeMetatable:__call(base, parent)
  base = base or {}
  --- @cast parent table
  parent = parent or self

  if Inheritof(base, self) then
    base, parent = {}, base
  end

  rawset(self, base, parent)

  --- @type metatable
  local baseMeta = {}

  local __index = (function (__index, __indexParent)
    return __index and function (t, k, v)
      return __index(t, k, v) or rawget(base, k) or __indexParent(t, k, v)
    end or function (t, k, v)
      return rawget(base, k) or __indexParent(t, k, v)
    end
  end)(rawget(base, '__index'), rawget(parent, '__index'))

  local __newindex = rawget(base, '__newindex') and (function (__newindex, __newindexParent)
    return function (t, k, v)
      return __newindex(t, k, v) or __newindexParent(t, k, v)
    end
  end)(rawget(base, '__newindex'), rawget(parent, '__newindex')) or rawget(parent, '__newindex')

  function baseMeta:__index(k)
    return rawget(base, k) or getmetatable(parent).__index(self, k)
  end

  function baseMeta:__call(...)
    local instance = setmetatable({}, self)
    instance:new(...)
    return instance
  end

  rawset(base, '__index', __index)
  rawset(base, '__newindex', __newindex)
  rawset(base, '__add', rawget(base, '__add') or rawget(parent, '__add'))
  rawset(base, '__sub', rawget(base, '__sub') or rawget(parent, '__sub'))
  rawset(base, '__mul', rawget(base, '__mul') or rawget(parent, '__mul'))
  rawset(base, '__div', rawget(base, '__div') or rawget(parent, '__div'))
  rawset(base, '__concat', rawget(base, '__concat') or rawget(parent, '__concat'))

  return setmetatable(base, baseMeta)
end

function TypeMetatable:__index(k)
  if k == 'getSuper' then
    return GetSuper

  elseif k == 'inheritof' then
    return Inheritof

  elseif k == 'mixin' then
    return Mixin
  end
end

--- @private
function Type:__index(k)
  --- @cast Type table
  return rawget(Type, k)
end

--- @private
function Type:__newindex(k, v)
  rawset(self, k, v)
end

function Type:new() end

--- Get the type of this value
--- @return table|nil|fun(...):table
function Type:getType()
  return getmetatable(self)
end

--- Check if the value matches the specified type
--- @param type table|function Target type
--- @return boolean bool The check result
function Type:is(type)
  return getmetatable(self) == type
end

--- Check whether the value is an instance of the specified type
--- @param type table|function Target type
--- @return boolean bool The check result
function Type:instanceof(type)
  local _t = getmetatable(self)
  if _t == type then
    return true
  end

  while GetSuper(_t) do
    _t = GetSuper(_t)
    if _t == type then
      return true
    end
  end

  return false
end

return Type
