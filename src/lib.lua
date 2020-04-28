----------------------
-- Showing off Colon mode.
-- If you hate @ tags, you can use colons. However, you need to specify colon
-- mode explicitly -C or --colon, or `colon=true` in the config.ld. Be careful
-- not to use a colon followed by a space for any other purpose!
--
-- So the incantation in this case is `ldoc -C colon.lua`.

-- module: lib

local lib={}

function lib.split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function lib.csv(file, todo)
  local function what2use(row, out, put)
    out, put = {},0
    for get,txt in pairs(row) do
      if string.sub(txt, 1,1) ~= the.ch.skip then
        put      = put + 1
        out[put] = get 
    end end
    return out
  end
  --------- --------- -------- ---------- ---------  
  local function use(row, what2do, out, cell)
    out = {}
    for put,get in pairs(what2do) do 
      cell = row[get]
      cell = tonumber(cell) or cell
      out[put] = cell end
    return out
  end
  --------- --------- -------- ---------- ---------  
  local stream = file and io.input(file) or io.input()
  local l    = io.read()
  return function()
    if l then
      l = l:gsub("[\t\r ]*","") -- no whitespace
           :gsub("#.*","")      -- no comments
      local l1 = lib.split(l)
      l = io.read()
      if #l1 > 0 then 
        if todo==nil then todo=what2use(l1) end
        return use(l1, todo) 
      end
    else
      io.close(stream) end end   
end

function lib.cat(t,s) return table.concat(t,s or ", ") end

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
