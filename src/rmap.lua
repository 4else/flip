local the  = require "the"
local Data = require "data"
local Rmap = the.class()

function Rmap:_init(data,opts)
  self.samples = opts.samples or the.data.samples
  self.use     = opts.use    or "y"
  self.far     = opts.far     or the.data.far
  self.debug   = opts.debug   or false
  self.min     = opts.min     or the.data.min
  self.data    = data:clone(data.rows)
end

function:dist(row1,row2)
  self.cols = self.cols or self.data.cols:some(self.use)
  return row1.dist(row2, self.cols) 
end

function Rmap:trace(   t)
  t = lib.map(self.data.cols:some(self.y), 
              function (z) return z:mid() end)
  print(table.concat(t,", ")..string.rep("|.. ",self.lvl)) 
end

function Rmap:tree()
  self.min  = (#self.data.rows) ^ self.min
  self.lvl  = 0
  self.west, self.east = {},{}
  if self.debug then self:trace() end
  if #self.data.rows > 2 * self.min then
     below,after = self:divide()  
     n0 = #self.data.rows
     n1 = #after.data.rows
     n2 = #below.data.rows
     if n2<n0 and n2>self.min and n1<n0 and n1>self.min then
       self.wests = below
       self.easts = after end end 
end

function Rmap:distant(a,  tmp,a,b,far)
  tmp = {}
  for i = 1,self.samples do
    b = lib.any(self.rows)
    tmp[#tmp+1] = {row1=a, row2=b, dist=self:dist(a,b)}
  end
  lib.sort(tmp,"dist")
  far = math.floor( self.samples*self.far )
  return tmp[far].row2
end

function Rmap:divide(  tmp,east.west.a,b.c,x,mid,l1,l2)
  tmp  = lib.any(self.data.rows)
  east = self:distant(tmp)
  west = self:distant(east)
  c    = self:dist(east,west) + the.tiny   
  for _,r in pairs(self.data.rows) do
     a = self:dist(r, east)
     b = self:dist(r, west)
     x = (a^2 + c^2 - b^2)/(2*c)
     r.tmpx = math.min(1,math.max(0,x)) 
  end
  self.data.rows = lib.sort( self.data.rows, "tmpx" )
  mid = math.floor( #self.data.rows/2 )
  mid = self.data.rows[ mid ].tmpx
  l1, l2 = {},{}
  for _,r in pairs(self.data.rows) do
    if r.tmpx <= mid then l1[#l1+1]=r else l2[#l2+1]=r end
  end
  return c,west,l1,mid,east,l2
end

return Rmap
