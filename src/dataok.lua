require "flip"

Data=require "data"

r=Data()
r:read(the.data .. 'weather4.csv')
o(r.cols)

for k,v in pairs(r:p("xsymp")) do
  print(100,k,v)
end
