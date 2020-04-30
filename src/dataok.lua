require "flip"
Data=require "data"

ok{some = function (  r,t)
  r = Data()
  r:read(the.csv .. 'weather4.csv')
  t= r:some("x")
  assert( t[ 1].txt == "outlook" )
  assert( t[#t].txt == "wind" )
end}
