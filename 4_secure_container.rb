@answer1 = nil
@answer2 = nil

input = DATA.each_line.first.split("-").map(&:to_i)

a1 = []
a2 = []
(input[0]..input[1]).each do |inp|
  if inp.to_s.chars.instance_eval do
    chunk(&:itself).map(&:last).size < size && sort == self
  end
    a1 << inp
    if inp.to_s.chars.instance_eval { chunk(&:itself).map(&:last).map(&:size).any? { @1 == 2} }
      a2 << inp
    end
  end
end

pp a1.uniq.size
pp a2.uniq.size
# pp @answer1
# pp @answer2

__END__
357253-892942
