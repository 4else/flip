----------------------
-- Showing off Colon mode.

-- module: Data

require "flip"
local csv  = require "csv"
local Cols = require "cols"

local Data = class()

function Data:_init()   self.rows,self.cols = {},nil end
function Data:header(t) self.cols = Cols(t) end

function Data:add(t)
  self.cols:add(t)
  self.rows[#self.rows+1] = t
end

function Data:read(f)
  for row in csv(f) do
    if self.cols then 
      self:add(row) 
    else 
      self:header(row) end end
end

return Data
