function averageDelay = MGKDelayApproximation(arrivalRate, meetingRate, numRelays, numCopies)

term1 = 2 * numCopies/meetingRate^2/numRelays^2;
term2 = 4 * numCopies^2/meetingRate^2/numRelays^2;

averageDelay = 2 * numCopies/meetingRate/numRelays + arrivalRate * (term1 + term2)/2/(1 - 2 * arrivalRate * numCopies/numRelays/meetingRate);


