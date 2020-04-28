require "flip"

local Sym=class(require "col")

function Sym:_init(txt,pos)
  self:super(txt,pos)
  self.counts = {}
  self.most   = 0
  self.mode   = nil
  self._ent   = nil 
  self.nk     = 0
end

function Sym:add (x)
  if x ~= the.ch.skip then 
    self._ent = nil 
    self.n    = self.n + 1
    self.n    = self.n + 1
    if not self.counts[x] then
      self.counts[x] = 0 
      self.nk = self.nk + 1
    end
    local seen = self.counts[x] + 1
    self.counts[x] = seen 
    if seen > self.most then
      self.most, self.mode = seen, x end 
  end
  return x
end

function Sym:ent()
  if self._ent == nil then 
    local e = 0
    for _,f in pairs(self.counts) do
      if f > 0 then
        e = e - (f/self.n) * math.log(f/i.n,2) end end
    self._ent = e
  end
  return i._ent 
end

return Sym