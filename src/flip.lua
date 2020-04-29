----------------------
-- Showing off Colon mode.
-- If you hate @ tags, you can use colons. However, you need to specify colon
-- mode explicitly -C or --colon, or `colon=true` in the config.ld. Be careful
-- not to use a colon followed by a space for any other purpose!
--
-- So the incantation in this case is `ldoc -C colon.lua`.

-- module: flip 

function the0() return {
  csv  = "../data/",
  ignore= "?",
  sep=    ",",
  tiny=   1/math.maxinteger,
  data =   { p      = 2,
             sample = 128,
             data   = .5,
             far    = .9},
  rand=   { seed = 1}, 
  ok=     { pass= 0, 
            fail= 0},
  ch=     { klass= "!",
            less = "<",
            more = ">",
            skip = "?",
            num  = "$",
            sym  = ":"
          },
  sample= { b      = 200,
            most   = 512,
            epsilon= 1.01,
            fmtstr = "%20s",
            fmtnum = "%5.3f",
            cliffs = .147
            -- cliff's small,medium,large = .147,.33,.474
            },
  nb =    { k=1,m=2},
  chop=   { m = .5,
            cohen = .2},
  num=    { conf  = 95,
            small = .38, -- small,medium = 0.38,1
            first = 3, 
            last  = 96,
            criticals = { -- Critical values for ttest
              [95] = {[ 3]=3.182,[ 6]=2.447,[12]=2.179,
                      [24]=2.064,[48]=2.011,[96]=1.985},
              [99] = {[ 3]=5.841,[ 6]=3.707,[12]=3.055,
                      [24]=2.797,[48]=2.682,[96]=2.625}}}
  } 
end

the = the0()

function requires(x)
  local y = require(x)
  if y then
    for k,v in pairs(y) do  _ENV[k] = v end end
end

class = require("ml").class

local function rogues()
  local no = {the=true,
              jit=true, utf8=true, math=true, package=true,
              table=true, coroutine=true, bit=true, os=true,
              io=true, bit32=true, string=true, arg=true,
              debug=true, _VERSION=true, _G=true }
  for k,v in pairs( _G ) do
    if type(v) ~= "function" and not no[k] then
      if k:match("^[^A-Z]") then
        print("-- ROGUE local ["..k.."]") end end end
end

function ok(t)
  for s,x in pairs(t) do  
    print("# test:", s) 
    the.ok.pass = the.ok.pass + 1
    local t1 = os.clock()
    the      = the0()
    math.randomseed(the.rand.seed)
    local passed,err = pcall(x) 
    local t2= os.clock()
    print(string.format ("%8.6f secs", t2-t1))
    if not passed then   
      the.ok.fail = the.ok.fail + 1
      print("Failure: ".. err) end 
  end 
  rogues()
end

function o(t,    indent  )
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        local fmt = string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          o(v, indent+1)
        else
          print(fmt .. tostring(v)) end end end end
end
 

