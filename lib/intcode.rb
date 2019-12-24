require "pry"

class Intcode

  attr_accessor :mem, :pos, :inputs, :outputs, :halted, :v, :slow, :base, :ots
  
  INSTRUCTION_MAP = {
    1 => :add,
    2 => :mul,
    3 => :inp,
    4 => :out,
    5 => :jit,
    6 => :jif,
    7 => :lt,
    8 => :eq,
    9 => :adj,
    99 => :halt
  }

  def initialize(m, v: false, slow: false, output_target_size: 9999999)
    @mem = m
    @pos = 0
    @inputs, @outputs = [],[]
    @halted = false
    @v = v
    @slow = slow
    @base = 0
    @ots = output_target_size
  end

  def run
    until self.halted
      puts "pos #{pos} | base #{base} | inputs #{inputs} | outputs #{outputs}" if v
      sleep 1 if slow
      instr = determine_instructions
      result = self.send(instr)
      if v
        puts "+" * 30
      #   puts (0..mem.size-1).map { |m| m.to_s.ljust(4, " ")}.join("|")
      #   puts mem.map{|m| m.to_s.ljust(4, " ")}.join("|")
        # puts "+" * 30
      end
      break if result == :paused
    end
  end

  def determine_instructions
    code = determine_code
    instr = INSTRUCTION_MAP[code]
    puts "determined instruction #{instr} (#{mem[pos]})" if v
    instr
  end
 
  def determine_code
    code = mem[pos]
    code.digits.first(2).reverse.join("").to_i
  end

  # gets the argument in position i of the current @pos
  def get_arg i
    mode = mem[pos].digits[i+1] || 0
    case mode
    when 0
      puts "arg #{i} - position mode, so finding value at #{mem[pos+i]} (#{mem[mem[pos+i]]})" if v
      mem[mem[pos+i]]
    when 1
      puts "arg #{i} - absolute mode, so using value #{mem[pos+i]}" if v
      mem[pos+i]
    when 2
      puts "arg #{i} - relative mode, so using base #{base} and arg #{mem[pos+i]}"\
      " (pos #{base + mem[pos + i]}, value #{mem[base+mem[pos+i]]})" if v
      mem[base + mem[pos + i]]
    end
  end

  def add
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    loc = mem[pos+3]
    result = arg1 + arg2
    mem[loc] = result
    puts "loc #{loc} is now #{result}" if v
    self.pos += 4
  end

  def mul
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    loc = mem[pos+3]
    result = arg1 * arg2
    mem[loc] = result
    puts "loc #{loc} is now #{result}" if v
    self.pos += 4
  end

  def inp
    unless inputs.any?
      puts "pausing, no inputs!" if v
      return :paused
    end
    result = self.inputs.shift
    loc = get_arg(1)
    mem[loc] = result
    puts "loc #{loc} is now #{result}" if v
    self.pos += 2
  end

  def out
    arg1 = get_arg(1)
    self.outputs.push arg1 
    puts "outputs are now #{outputs}" if v
    if outputs.size >= ots
      puts "output target size achieved" if v
      return :paused
    end
    self.pos += 2
  end

  def jit
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    result = !arg1.zero?
    if result
      puts "arg1 is #{arg1} so jumping to #{arg2}" if v
      self.pos = arg2
    else
      puts "arg1 is #{arg1} so not jumping, just moving to #{self.pos + 3}" if v
      self.pos += 3
    end
  end

  def jif
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    result = arg1.zero?
    if result
      puts "arg1 is #{arg1} so jumping to #{arg2}" if v
      self.pos = arg2
    else
      puts "arg1 is #{arg1} so not jumping, just moving to #{self.pos + 3}" if v
      self.pos += 3
    end
  end

  def lt
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    loc = mem[pos+3]
    result = arg1 < arg2
    if result
      puts "#{arg1} is less than #{arg2} so placing 1 in loc #{loc}" if v
      mem[loc] = 1
    else
      puts "#{arg1} is not less than #{arg2} so placing 0 in loc #{loc}" if v
      mem[loc] = 0
    end
    self.pos += 4
  end

  def eq
    arg1 = get_arg(1)
    arg2 = get_arg(2)
    loc = mem[pos+3]
    result = arg1 == arg2
    if result
      puts "#{arg1} is equal to #{arg2} so placing 1 in loc #{loc}" if v
      mem[loc] = 1
    else
      puts "#{arg1} is not equal to #{arg2} so placing 0 in loc #{loc}" if v
      mem[loc] = 0
    end
    self.pos += 4
  end

  def adj
    arg1 = get_arg(1)
    self.base += arg1
    puts "base is now #{self.base}" if v
    self.pos += 2
  end

  def halt
    self.halted = true  
  end
end
