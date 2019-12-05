require "pry"

class Intcode

  attr_accessor :m, :verbose


  def initialize(memory)
    @m = memory.clone
  end
  


  def run(id)
    _procs = [
      ->(*_) { raise "wtf" },
      ->(m,i,a,b) { m[m[i+3]] = a + b; [i+4,m] }, #add
      ->(m,i,a,b) { m[m[i+3]] = a * b; [i+4,m] }, #multiply
      ->(m,i,a,_) { m[i+1] = a; [i+2,m] }, # input
      ->(m,i,a,_) { puts a unless a.zero?; [i+2,m] }, #output
      ->(m,i,a,b) { a.zero? ? [i+3,m] : [b,m] }, #jump(T)
      ->(m,i,a,b) { a.zero? ? [b,m] : [i+3,m] }, #jump(F)
      ->(m,i,a,b) { m[m[i+3]] = a < b ? 1 : 0; [i+4,m] }, #less than
      ->(m,i,a,b) { m[m[i+3]] = a == b ? 1 : 0; [i+4,m] } #equals
    ]
    i = 0
    loop do
      c = m[i] % 100
      d = m[i].digits # this comes back in this order: code, code, 1p, 2p, 3p
      a = d[2]&.==(1) ? m[i+1] : m[m[i+1]]
      b = d[3]&.==(1) ? m[i+2] : m[m[i+2]]
      pp [i,m[i],c,a,b]
      puts m[11]
      puts m[225]
      case c
      when 1..2, 4..8; i,m = _procs[c].call(m,i,a,b)
      when 3; i,m = _procs[c].call(m,i,id,nil)
      when 99; break
      else; raise "unknown opcode #{i}"
      end
    end
    self
  end
end