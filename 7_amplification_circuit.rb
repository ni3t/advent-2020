require_relative 'lib/intcode'

verbose = ARGV.delete("-v")
slow = ARGV.delete("-s")

memory = DATA.each_line.first.split(",").map(&:to_i)

# vals = {}
# (0..4).to_a.permutation.to_a.map do |ps|
#   amps = 5.times.map do
#     Intcode.new(memory.dup, v: verbose, slow: slow)
#   end
#   ps.each.with_index do |p,i|
#     amps[i].inputs.push p
#   end
#   amps.first.inputs.push 0
#   amps.map.with_index do |amp, i|
#     puts "NOW IN AMP #{i}" if verbose
#     amp.run
#     next if i+1 >= amps.length
#     amps[i+1].inputs.concat amp.outputs
#   end
#   vals[ps.join("")] = amps.last.outputs.max
# end
# # pp vals.max_by(&:last)

vals = {}
(5..9).to_a.permutation.to_a.map do |ps|
  amps = 5.times.map do
    Intcode.new(memory.dup, v: verbose, slow: slow)
  end
  ps.each.with_index do |p,i|
    amps[i].inputs.push p
  end
  amps.first.inputs.push 0
  amps.cycle.each.with_index do |amp, i|
    if verbose
      puts "NOW IN AMP #{i%5}"
    end
    amp.run
    break if amps.all? &:halted
    amps[(i+1)%5].inputs.concat amp.outputs
    amp.outputs.clear
  end
  vals[ps.join("")] = amps.last.outputs.max
end
pp vals.max_by(&:last)



__END__
3,8,1001,8,10,8,105,1,0,0,21,46,59,84,93,110,191,272,353,434,99999,3,9,101,2,9,9,102,3,9,9,1001,9,5,9,102,4,9,9,1001,9,4,9,4,9,99,3,9,101,3,9,9,102,5,9,9,4,9,99,3,9,1001,9,4,9,1002,9,2,9,101,2,9,9,102,2,9,9,1001,9,3,9,4,9,99,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,1002,9,3,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,99