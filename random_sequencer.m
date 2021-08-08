function [sequence] = random_sequencer()

a = [2 3 4 5];
sequence = a(randperm(length(a)));

end

