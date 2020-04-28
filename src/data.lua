----------------------
-- Showing off Colon mode.
-- If you hate @ tags, you can use colons. However, you need to specify colon
-- mode explicitly -C or --colon, or `colon=true` in the config.ld. Be careful
-- not to use a colon followed by a space for any other purpose!
--
-- So the incantation in this case is `ldoc -C colon.lua`.

-- module: Data

require "flip"
local lib = require "lib"
local Num = require "Num"
local Sym = require "Sym"

local function c(s,k) 
  return string.sub(s,1,1) == the.ch[k] end

local Data=class()

function Data:_init() self.rows,self.cols = {},{} end

function Data:klassp(x) return c(x,"klass") end 
function Data:goalp(x)  return c(x,"less") or c(x,"more") end
function Data:nump(x)   return c(x,"num") or self:goalp(x) end
function Data:yp(x)     return self:klassp(x) or self:goalp(x) end
function Data:xp(x)     return not self:yp(x) end
function Data:symp(x)   return not self:nump(x) end
function Data:xsymp(x)  return self:xp(x) and self:symp(x) end
function Data:xnump(x)  return self:xp(x) and self:nump(x) end

function Data:p(f) 
  local out,f = {},getmetatable(self)[f]
  for _,col in pairs(self.cols) do 
    if f(self,col.txt) then out[#out+1] = col end end
  return out
end

function Data:head(t,  col)
  for k,v in pairs(t) do
    col = self:nump(v) and Num or Sym
    self.cols[k] = col(v,k) end
end

function Data:add(t)
  for k,v in pairs(t) do self.cols[k]:add(v) end
  self.rows[#self.rows+1] = t
end

function Data:read(f)
  for n,row in lib.csv(f) do
    if n==0 then self:head(row) else self:add(row) end end
end

return Data
