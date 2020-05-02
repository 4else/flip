local the = require "the"
local lib = require "lib"
local Fmap= the.class()

function Fmap:_init(data,   rows,cols,min,far,n)
  self.data = data
  self.rows = rows or data.rows
  self.cols = cols or data:some("y")
  self.min  = min  or the.fmap.min 
  self.min  = (#rows)^self.min
  self.far  = far  or the.fmap.far
  self.n    = n    or the.fmap.n
end

function Fmap:split()
  if #self.rows > self.min then
    Fmap(self.data, self:best(), self.cols,
         self.min,  self.far,    self.n):split()
  else 
    for _,row in pairs(self.rows) do 
      row.best = true end end
end

function Fmap:best(    some,tmp,l,r,c,minx,lo,hi,what)
  some = lib.anys( self.rows, self.n )
  tmp  = lib.any( some )
  l    = self:far( tmp,some )
  r    = self:far( l,  some )
  c    = self:dist(l,  r)
  minx = self:project(l,r,c)
  lo,hi= {},{}
  for _,row in pairs(self.rows) do
    what = row.tmpx <= midx lo or hi 
    what[#what+1] = row
  end
  return l:dominates(r,row) lo or ho
end

function Fmap:project(l,r,c,     a,b,x)
  for _,row in pairs(self.rows) do
    a        = self:dist(row,l)
    b        = self:dist(row,r)
    x        = (a^2 + c^2 - b^2) / (2*c)
    row.tmpx = math.max(0, math.min(1, x))
  end
  self.rows = lib.sort(rows, "tmpx")
  return self.rows[ #self.rows //2 ].tmpx
end

function Fmap:far(row,some)
  returm self.data:far(row, self.cols,some,self.far) end

function Fmap:dist(row1,row2)
 returm self.data:dist(row1,row2,self.cols) end

return Fmap
