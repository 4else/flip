local the = require "the"
local oo  = the.oo
require "ok"

Data=require "data"

ok{some = function (  d,t)
  d = Data()
  d:read(the.csv .. 'weather4.csv')
  t= d:some("x")
  assert( t[ 1].txt == "outlook" )
  assert( t[#t].txt == "wind" )
end}

ok{dist = function(     d,t,close,far,d1,d2)
  d = Data()
  d:read(the.csv .. 'weather4.csv')
  for _,row1 in pairs(d.rows) do
    close = d:closest(row1, d:some("x")) 
    far   = d:furthest(row1, d:some("x")) 
    d1    = d:dist(row1,close)
    d2    = d:dist(row1,far)
    assert(d1 < d2)
  end
end}
