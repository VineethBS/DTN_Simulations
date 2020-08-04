import numpy as np

def MGKApprox(arrivalRate, otherArrivalRate, meetingRate, numRelays, numCopies, numSources):
    numSources = 2
    rho = otherArrivalRate * numCopies * (numSources + 1) / numRelays / meetingRate
    
    EX = ((numSources - 1.0) * rho + 2) / meetingRate
    
    EX2 = 2/(meetingRate ** 2) + 2/(numSources ** 2)/(meetingRate ** 2) + 2/(meetingRate ** 2) * (1 + (numSources - 1) * rho) + \
          3 * (numSources - 1)/(numSources ** 2)/(meetingRate ** 2) + \
          (numSources - 1) * (2 * numSources - 1)/(numSources ** 2)/(meetingRate ** 2) + \
          rho * (numSources - 1) * (2 * numSources) * (1/(meetingRate ** 2) + 2/(numSources)/(meetingRate ** 2))
    
    Xbar = EX * 1.0/numRelays;
    Xbarsq = EX2 * 1.0/(numRelays ** 2);
    
    Xstar = (Xbarsq - (Xbar ** 2)) * numCopies + (numCopies ** 2) * (Xbar ** 2);
    
    averageDelay = numCopies * Xbar + arrivalRate * Xstar/2/(1 - arrivalRate * numCopies * Xbar);

    return averageDelay
        
