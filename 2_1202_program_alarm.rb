@program = DATA.each_line.first.split(?,).map(&:to_i)

@answer1 = nil
@answer2 = nil

catch :done do
  0.step(to: 99) do |a|
    0.step(to: 99) do |b|
      clone = @program.clone
      clone[1..2] = [a,b]
      0.step(by: 4, to: @program.length) do |i|
        if clone[i] == 1
          clone[clone[i+3]] = clone[clone[i+1]] + clone[clone[i+2]]
        elsif clone[i] == 2
          clone[clone[i+3]] = clone[clone[i+1]] * clone[clone[i+2]]
        elsif clone[i] == 99
          break
        end
        if clone.first == 19690720
          @answer2 = (100 * a) + b
          throw :done if @answer1 && @answer2
        end
      end
      if a == 12 && b == 2
        @answer1 = clone.first
        throw :done if @answer1 && @answer2
      end
    end
  end
end

pp @answer1
pp @answer2

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,5,23,1,23,9,27,2,27,6,31,1,31,6,35,2,35,9,39,1,6,39,43,2,10,43,47,1,47,9,51,1,51,6,55,1,55,6,59,2,59,10,63,1,6,63,67,2,6,67,71,1,71,5,75,2,13,75,79,1,10,79,83,1,5,83,87,2,87,10,91,1,5,91,95,2,95,6,99,1,99,6,103,2,103,6,107,2,107,9,111,1,111,5,115,1,115,6,119,2,6,119,123,1,5,123,127,1,127,13,131,1,2,131,135,1,135,10,0,99,2,14,0,0