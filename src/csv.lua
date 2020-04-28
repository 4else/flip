require "flip"

-- Return an iterator that returns all non-blank
-- lines, divided into cells (coerced to numbers,
-- if need be), with all white space and comments removed.

-- ----------------
-- ## Support code

-- Select the cells listed in `want` from `row`
-- (and while we are here, coerce any 
-- number strings to numbers).
local function select(want,row,     out,cell)
  out = {}
  for put,get in pairs(want) do 
    cell     = row[get]
    cell     = tonumber(cell) or cell -- coercian
    out[put] = cell end
  return out
end

-- Determine what we want. Specifically, We want to
-- skip over any column whose name starts with `the.ch.skip`
-- (which defaults to `?`).
local function wanted(row,    out,put)
  out, put = {},0
  for get,txt in pairs(row) do
    if string.sub(txt,1,1) ~= the.ch.skip then
      put      = put + 1
      out[put] = get 
  end end
  return out
end

-- Low-level function: Split the string `s` on some seperatpr `sep` 
-- (which defaults to ",") into a return list.
local function split(s,     sep,out)
  out, sep = {}, sep or ","
  for y in string.gmatch(s, "([^" ..sep.. "]+)") do 
    out[#out+1] = y end
  return out
end
-- ----------------
-- ## Main
-- This iterator reads from `file` or, if that is absent,
-- from standard input.
return function (file,     want)
  local stream = file and io.input(file) or io.input()
  local tmp    = io.read()
  return function()
    if tmp then
      tmp = tmp:gsub("[\t\r ]*","") -- no whitespace
               :gsub("#.*","")      -- no comments
      local row = split(tmp)
      tmp = io.read()
      if #row > 0 then 
        want = want or wanted(row) 
        return select(want,row) 
      end
    else
      io.close(stream) end end   
end
