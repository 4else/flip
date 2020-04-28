require "flip"

Cols=object()

function Cols:_init(t) 
  self._some = {}
  self.all   = {}
  for k,v in pairs(t) do
    col = self:num(v) and Num or Sym
    self.all[k] = col(v,k) end
end

function Cols:add(t) 
  for k,v in pairs(t) do self.all[k]:add(v) end end

local function c(s,k) 
  return string.sub(s,1,1) == the.ch[k] end

function Cols:klass(x) return c(x,"klass") end 
function Cols:goal(x)  return c(x,"less") or c(x,"more") end
function Cols:num(x)   return c(x,"num") or self:goalp(x) end
function Cols:y(x)     return self:klassp(x) or self:goalp(x) end
function Cols:x(x)     return not self:yp(x) end
function Cols:sym(x)   return not self:nump(x) end

function Cols:some(f) 
  if not self._some[f] then 
    local tmp,f = {},getmetatable(self)[f]
    for _,col in pairs(self.all) do 
      if f(self,col.txt) then tmp[#tmp+1] = col end 
    self.cache[f] = tmp
  end
  return self.cache[f]
end

return Cols
