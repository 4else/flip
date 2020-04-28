local lib={}

function lib.split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function lib.o(t,    indent  )
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        local fmt = string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          lib.o(v, indent+1)
        else
          print(fmt .. tostring(v)) end end end end
end

function lib.csv(file)
  local stream = file and io.input(file) or io.input()
  local l      = io.read()
  return function()
    if l then
      l = l:gsub("[\t\r ]*","")
           :gsub("#.*","")
      local l1 = lib.split(l)
      for k,v in pairs(l1) do l1[k] = tonumber(v) or v end
      l = io.read()
      if #l1 > 0 then return l1 end
    else
      io.close(stream) end end   
end

function lib:dump(t)
   if type(t) ~= 'table' then return tostring(o) end
   local s = '{ '
   for k,v in pairs(t) do
     s = s ..k..' = ' .. lib.dump(v) .. ','
   end
   return s .. '} '
end

function lib.rogues()
  local no = {jit=true, utf8=true, math=true, package=true,
            table=true, coroutine=true, bit=true, os=true,
            io=true, bit32=true, string=true, arg=true,
            debug=true, _VERSION=true, _G=true }
  for k,v in pairs( _G ) do
    if type(v) ~= "function" and not no[k] then
      if k:match("^[^A-Z]") then
        print("-- alert: rogue local ["..k.."]") end end end
end

return lib
