----------------------
-- Showing off Colon mode.
-- If you hate @ tags, you can use colons. However, you need to specify colon
-- mode explicitly -C or --colon, or `colon=true` in the config.ld. Be careful
-- not to use a colon followed by a space for any other purpose!
--
-- So the incantation in this case is `ldoc -C colon.lua`.

-- module: lib

local lib={}


function lib.any(l) return l[math.random(1,#l)] end

function lib.map(t,f, out)
  out={}
  f =  f and f or function(z) return z end
  if t then for i,v in pairs(t) do out[i] = f(v) end  end
  return out
end

function lib.reject(t,f)
  return lib.select(t, function (z) return not f(z) end) end

function lib.select(t,f, out)
  out={}
  for _,v in pairs(t) do 
    if f(v) then out[#out+1] = v  end end
  return out
end

function lib.copy(t)  
  return type(t) ~= 'table' and t or lib.map(t,lib.copy)
end

function lib.sort(t,f)
  if type(f) == "string" then
    return lib.sort(t, function(x,y) return x[f]<y[f] end) 
  elseif not f then
    return lib.sort(t, function(x,y) return x< y end) 
  end
  table.sort(t,f)
  return t
end

function lib.rpad(s,n)
  s = tostring(s)
  return  s .. string.rep(" ",n - #s) 
end

function lib.lpad(s,n)
  s = tostring(s)
  return  string.rep(" ",n - #s) .. s
end

function lib.split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function lib.dump(t)
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
