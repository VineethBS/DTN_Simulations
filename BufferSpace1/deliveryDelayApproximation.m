function deliveryDelay = deliveryDelayApproximation(meetingRate, numCopies, numRelays)

initialY = 1;
lambdat = @(t) (meetingRate * min([numCopies * ones(1, length(t)), numRelays - initialY * meetingRate * t .* exp(-meetingRate * t)]));

% exp(-integral(hazardFunc, 0, 10))
% SFunc = @(u) (exp(-integral(hazardFunc, 0, u)));
% deliveryDelay = integral(SFunc, 0, 10);
    deliveryDelay = 0;
