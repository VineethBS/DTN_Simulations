function compareMG1DelayApproximationsForSingleRelay(arrivalRates, meetingRate, numCopies)

delaySpecialFirstCustomer = zeros(1, length(arrivalRates));
delayMG1 = zeros(1, length(arrivalRates));
for a = 1:length(arrivalRates)
    delaySpecialFirstCustomer(a) = singleRelayKCopiesDelayApproximation(arrivalRates(a), meetingRate, numCopies);
    delayMG1(a) = singleRelayKCopiesMG1DelayApproximation(arrivalRates(a), meetingRate, numCopies);
end

plot(arrivalRates, delayMG1, 'rx:');
hold on;
plot(arrivalRates, delaySpecialFirstCustomer, 'bo:');

