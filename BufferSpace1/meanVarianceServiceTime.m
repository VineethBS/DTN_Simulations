function [meanServiceTime, varianceServiceTime] = meanVarianceServiceTime(numOfRelays, meetingRate, numOfCopies)

meanServiceTime = zeros(numOfCopies + 1, numOfRelays + 1);
varianceServiceTime = zeros(numOfCopies + 1, numOfRelays + 1);

for x = numOfCopies: -1: 1
    for y = 1: (numOfRelays + 1)
        if y == 1
            meanServiceTime(x, y) = 1/numOfRelays/meetingRate + meanServiceTime(x + 1, y + 1);
            varianceServiceTime(x, y) = 1/numOfRelays^2/meetingRate^2 + varianceServiceTime(x + 1, y + 1);
        elseif y == (numOfRelays + 1)
            meanServiceTime(x, y) = 1/numOfRelays/meetingRate + meanServiceTime(x, y - 1);
            varianceServiceTime(x, y) = 1/numOfRelays^2/meetingRate^2 + varianceServiceTime(x, y - 1);
        else
            meanServiceTime(x, y) = (y - 1)/numOfRelays * (1/(y - 1)/meetingRate + meanServiceTime(x, y - 1));
            meanServiceTime(x, y) = meanServiceTime(x, y) + (numOfRelays - y + 1)/numOfRelays * (1/(numOfRelays - y + 1)/meetingRate + meanServiceTime(x + 1, y + 1));
            varianceServiceTime(x, y) = (y - 1)/numOfRelays * (1/(y - 1)^2/meetingRate^2 + varianceServiceTime(x, y - 1));
            varianceServiceTime(x, y) = varianceServiceTime(x, y) + (numOfRelays - y + 1)/numOfRelays * (1/(numOfRelays - y + 1)^2/meetingRate^2 + varianceServiceTime(x + 1, y + 1));
        end
    end
end

meanServiceTime = meanServiceTime(1, :); % only need the first row
varianceServiceTime = varianceServiceTime(1, :);
