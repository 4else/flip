local lib={}

lib.data = "../../etc/data"

function lib.split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function lib.o(t,    indent, depth   )
  indent = indent or 0
  depth  = depth or 7
  if depth > 0 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        local fmt = string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          lib.o(v, indent+1,depth-1)
        else
          print(fmt .. tostring(v)) end end end end
end

function lib.csv(file,f,f1)
  local stream = file and io.input(file) or io.input()
  local line   = io.read()
  while line do
    line= line:gsub("[\t\r ]*","")
              :gsub("#.*","")
    local cells = lib.split(line)
    line = io.read()
    if #cells > 0 then
      f(cells) 
      f=f1
  end 
  io.close(stream)
end

function lib:dump(t)
   if type(t) ~== 'table' then return tostring(o) end
   local s = '{ '
   for k,v in pairs(t) do
     if type(k) ~= 'number' then k = '"'..k..'"' end
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
