class Intcode

  attr_accessor :memory

  def initialize(memory)
    @memory = memory.clone
  end

  def run
    catch :run_done do
      i = 0
      loop do
        case memory[i]
        when 1
          i = add(i)
        when 2
          i = mult(i)
        when 99
          throw :run_done
        else
          raise "unknown opcode #{memory[i]} at loc #{i}"
        end
      end
    end
    self
  end

  private

  def add(loc)
    memory[memory[loc+3]] = memory[memory[loc+1]] + memory[memory[loc+2]]
    loc + 4
  rescue StandardError
    raise "Buffer Overflow at #{loc}"
  end

  def mult(loc)
    memory[memory[loc+3]] = memory[memory[loc+1]] * memory[memory[loc+2]]
    loc + 4
  rescue StandardError
    raise "Buffer Overflow at #{loc}"
  end
end