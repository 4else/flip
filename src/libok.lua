require "flip"

lib = require "lib"

for n,row in lib.csv( the.data .. 'weather4.csv') do
  print(n, lib.cat(row))
end
