require "flip"
local Cols=object()

-- `Cols` is a place to store summaries 
-- of `Num`s or `Sym` columns.
local function c(s,k) 
  return string.sub(s,1,1) == the.ch[k] end

function Cols:klass(x) return c(x,"klass") end 
function Cols:goal(x)  return c(x,"less") or c(x,"more") end
function Cols:num(x)   return c(x,"num") or self:goal(x) end
function Cols:y(x)     return self:klass(x) or self:goal(x) end
function Cols:x(x)     return not self:y(x)   end
function Cols:sym(x)   return not self:num(x) end

function Cols:_init(t) 
  self._some, some.all = {},{}
  for k,v in pairs(t) do
    col = self:num(v) and Num or Sym
    self.all[k] = col(v,k) end
end

function Cols:add(t) 
  for k,v in pairs(t) do self.all[k]:add(v) end end

function Cols:some(f) 
  local all = function(    g,out)
    out,g = {},getmetatable(self)[f]
    for _,col in pairs(self.all) do 
      if g(self,col.txt) then out[#out+1] = col end end
    return out
  end
  --------- --------- --------- --------- 
  self._some[f] = self._some[f] or all() 
  return self._some[f]
end

return Cols
