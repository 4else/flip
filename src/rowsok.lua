require "flip"

Rows=require "rows"

r=Rows()
r:read(the.data .. 'weather4.csv')
o(r.cols)
