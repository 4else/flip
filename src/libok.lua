require "flip"

lib = require "lib"

for row in lib.csv( the.data .. 'weather4.csv') do
  print(table.concat(row,", "))
end
