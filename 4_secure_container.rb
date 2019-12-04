@answer1 = 0
@answer2 = 0

low, high = DATA.each_line.first.split("-").map(&:to_i)

class Array
  def sorted?
    sort == self
  end

  def indistinct?
    uniq != self
  end
end

(low..high).each do |i|
  digits = i.digits.reverse
  if digits.sorted? && digits.indistinct?
    @answer1 += 1
    if digits.chunk(&:itself).any? { |a| a.last.size == 2 }
      @answer2 += 1
    end
  end
end

pp @answer1
pp @answer2

__END__
357253-892942
