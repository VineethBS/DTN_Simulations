function [averageQueueLength, averageDelay] = queueingDelayApproximation(arrivalRate, meetingRate, numOfRelays, numOfCopies)

averageQueueLength = arrivalRate * numOfCopies * (numOfCopies + 1) * (1 + arrivalRate * numOfCopies * (1 + arrivalRate * numOfCopies)/(numOfRelays * meetingRate/2 - arrivalRate * numOfCopies));
averageDelay = averageQueueLength/arrivalRate;



