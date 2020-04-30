require "flip"

local Num=require("num")

ok {sd1 = function (m)
  m = Num():adds {9,2,5,4,12,7,8,11,9,
                  3,7,4,12,5,4,10,9,6,9,4}
  assert(m.mu == 7)
  assert(3.06 < m.sd and m.sd < 3.061)
end} 
