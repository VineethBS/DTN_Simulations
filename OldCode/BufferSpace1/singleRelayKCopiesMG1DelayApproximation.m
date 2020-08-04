function averageDelay = singleRelayKCopiesMG1DelayApproximation(arrivalRate, meetingRate, numCopies)

varX = 2/meetingRate^2 * numCopies;
X = 2/meetingRate * numCopies;

% M/G/1 approximation
rho = arrivalRate * X;
averageDelay = (rho^2 + arrivalRate^2 * varX)/2/(1 - rho)/arrivalRate + X;