import numpy as np

def MGKApprox(arrivalRate, meetingRate, numRelays, numCopies, numSources):
    EX = (numSources + 1.0) / meetingRate
    EX2 = 2/(meetingRate ** 2) + 2/(numSources ** 2)/(meetingRate ** 2) + \
          (numSources - 1) * (1/(meetingRate ** 2) + 2/numSources/(meetingRate ** 2) + 3/(numSources ** 2)/(meetingRate ** 2)) \
          + (numSources - 1) * (2 * numSources - 1) * (1/(meetingRate ** 2) + 2/numSources/(meetingRate ** 2) + 1/(numSources ** 2)/(meetingRate ** 2))\
          + 2/(meetingRate) * (1/numSources/meetingRate + (numSources - 1) * (1/numSources/meetingRate + 1/meetingRate));
    
    Xbar = EX * 1.0/numRelays;
    Xbarsq = EX2 * 1.0/(numRelays ** 2);
    
    Xstar = (Xbarsq - (Xbar ** 2)) * numCopies + (numCopies ** 2) * (Xbar ** 2);
    
    averageDelay = numCopies * Xbar + arrivalRate * Xstar/2/(1 - arrivalRate * numCopies * Xbar);

    return averageDelay
        
