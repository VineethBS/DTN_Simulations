% Find out the time taken for transitions

n = [p.numInfectedRelaysAtFirstServiceTime];
p11 = [];
p12 = [];
p2 = [];
p31 = [];
p32 = [];
p33 = [];

n1 = [];

for i = 1:length(n)
    if n(i) == 1
        if size(p(i).epochTimes, 1) == 2
            p11 = [p11, p(i).epochTimes(1, 2) - p(i).firstServiceTime];
            p12 = [p12, p(i).epochTimes(2, 2) - p(i).epochTimes(1, 2)];
        elseif size(p(i).epochTimes, 1) == 3
            p31 = [p31, p(i).epochTimes(1, 2) - p(i).firstServiceTime];
            p32 = [p32, p(i).epochTimes(2, 2) - p(i).epochTimes(1, 2)];
            p33 = [p33, p(i).epochTimes(3, 2) - p(i).epochTimes(2, 2)];
        else
            p2 = [p2, p(i).epochTimes(1, 2) - p(i).firstServiceTime];
            n1 = [n1, p(i).epochTimes(1, 3)];
        end
    end
end

fprintf(1, '%.4f, %.4f, %.4f\n', mean(p31), mean(p32), mean(p33));
fprintf(1, '%.4f, %.4f, %.4f\n', mean(p11), mean(p12), mean(p2));