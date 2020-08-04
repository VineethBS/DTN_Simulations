function averageDelay = singleRelayKCopiesDelayApproximation(arrivalRate, meetingRate, numCopies)

varX = 2/meetingRate^2 * numCopies;
X = 2/meetingRate * numCopies;
X2 = varX + X^2;

Xs = (2 * numCopies * arrivalRate + (2 * numCopies - 1) * meetingRate)/meetingRate/(arrivalRate + meetingRate);
Xs2 = (2 * numCopies * (2 * numCopies + 1) * arrivalRate + 2 * numCopies * (2 * numCopies - 1) * meetingRate)/meetingRate^2/(arrivalRate + meetingRate);

denom = 1 - arrivalRate * X + arrivalRate * Xs;
averageDelay = Xs / denom + arrivalRate * X2/2/(1 - arrivalRate*X) + arrivalRate * (Xs2 - X2)/2/denom;

% M/G/1 approximation
% rho = arrivalRate * X;
% averageDelay = (rho^2 + arrivalRate^2 * varX)/2/(1 - rho)/arrivalRate + X;