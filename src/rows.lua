require "flip"
local lib = require "lib"
local Num = require "Num"
local Sym = require "Sym"

local function c(s,k) 
  return string.sub(s,1,1) == the.ch[k] end

local Rows=class(require "col")

function Rows:_init()
  self.rows, self.cols = {},{}
end

function Rows:read(f)
  for n,row in lib.csv(f) do
    if n==0 then self:head(row) else self:add(row) end end
end

function Rows:klassp(x) return c(x,"klass") end 
function Rows:goalp(x) return c(x,"less") or c(x,"more") end
function Rows:nump(x) return c(x,"num") or self:goalp(x) end
function Rows:yp(x) return self:klassp(x) or self:goalp(x) end

function Rows:xp(x)     return not self:yp(x) end
function Rows:symp(x)   return not self:nump(x) end

function Rows:head(t,  col)
  for k,v in pairs(t) do
    col = self:nump(v) and Num or Sym
    self.cols[k] = col(k,v) end
end

function Rows:add(t)
  for k,v in pairs(t) do self.cols[k]:add(v) end
  self.rows[#self.rows+1] = t
end


return Rows
