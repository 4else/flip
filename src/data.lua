require "flip"
local lib  = require "lib"
local csv  = require "csv"
local Row  = require "row"
local Cols = require "cols"
local Data = class()

-- `Data` stores `rows` as well as `cols` that summarize the
-- columns of that rows.
--------- --------- -------- ---------- ---------  ---------  
-- ## Creation and Updates

function Data:_init(header)   
  self.p     = the.data.p 
  self._some = {}
  self.rows  = {}
  self.cols  = nil
  if header then self:header(header) end
end

function Data:header(t) self.cols = Cols(t) end

function Data:add(t,   row)
  row = t.cells and t or Row(t) 
  self.cols:add(row.cells)
  self.rows[#self.rows+1] = row
end

function Data:read(f)
  for row in csv(f) do
    if   self.cols 
    then self:add(row) 
    else self:header(row) end end
end

function Data:clone(rows,  clone)
  clone = Data( lib.keys(self.cols, "txt") )
  if rows then
    for _,row in pairs(rows) do clone:add(row) end end
  return clone
end

--------- --------- -------- ---------- ---------  ---------  
-- ## Querying

-- Get klass columm.
function Data:klass() 
  return self.cols:some("klass")[1] end

-- Get klass value from a row.
function Data:klassVal(row) 
  local klass=self:klass()
  return row.cells[klass.pos]
end

function Data:some(x)
  self._some[x] = self._some[x] or self.cols:some(x)
  return self._some[x]
end

-- Get the `dist` between two rows.
function Data:dist(r1,r2,cols,   n,d,d0,x,y)
  d,n=0,the.tiny
  cols = cols or self.cols:some("x")
  for _,c in pair(cols) do
    n  = n+1
    d0 = c:dist( r1.cells[c.pos], r2.cells[c.pos] )
    d  = d + d0^self.p
  end
  return  (d/n)^self.p
end

  
return Data
