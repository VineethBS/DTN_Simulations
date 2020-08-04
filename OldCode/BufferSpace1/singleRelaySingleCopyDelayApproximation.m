function averageDelay = singleRelaySingleCopyDelayApproximation(arrivalRate, meetingRate)

varX = 2/meetingRate^2;
X = 2/meetingRate;
X2 = varX + X^2;

Xs = (2 * arrivalRate + meetingRate)/meetingRate/(arrivalRate + meetingRate);
Xs2 = (6 * arrivalRate + 2 * meetingRate)/meetingRate^2/(arrivalRate + meetingRate);
denom = 1 - arrivalRate * X + arrivalRate * Xs;

averageDelay = Xs / denom + arrivalRate * X2/2/(1 - arrivalRate*X) + arrivalRate * (Xs2 - X2)/2/denom;

% M/G/1 approximation
% rho = arrivalRate * X;
% averageDelay = (rho^2 + arrivalRate^2 * varX)/2/(1 - rho)/arrivalRate + X;