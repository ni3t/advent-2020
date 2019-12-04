@answer1 = 0
@answer2 = 0

low, high = DATA.each_line.first.split("-").map(&:to_i)

(low..high).each do |i|
  digits = i.digits.reverse
  if digits.uniq != digits && digits.sort == digits
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
