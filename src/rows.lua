local ml  = require "ml"
local lib = require "lib"

tbl = ml.class()
num = ml.class()
sym = ml.class()

function tbl:_init()
  self.cols = {}
end

function tbl:read(file, f0,f)
  local stream = file and io.input(file) or io.input()
  local first,line = true,io.read()
  while line do
    line= line:gsub("[\t\r ]*","")
              :gsub("#.*","")
    local cells = lib.split(line)
    line = io.read()
    if #cells > 0 then
      if first then f0(cells) else f(cells) end end
      first = false
  end 
  io.close(stream)
  return t
end

lib.rogues()

return tbl
