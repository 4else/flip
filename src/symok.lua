require "sym"
local Sym=require("sym")

ok {ent1 = function (m)
  m = Sym():adds {"a","b","b","c","c","c","c"}
  near(m:var(), 1.378)
end} 
