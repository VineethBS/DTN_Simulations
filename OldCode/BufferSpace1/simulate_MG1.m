function [averageQueueLength, averageDelay] = simulate_MG1(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfEpochs, numRuns)

averageQueueLength = 0;

for r = 1:numRuns
    currentTime = 0;
    initialQueueLength = randi(initialQueueLengthLimit) - 1; % uniformly (randomly) pick the initial queue length from 0:initialQueueLengthLimit - 1
    
    q = initialQueueLength; % the state(length) of the queue including the packet in service
    n = 0; % the number of infected relays
    
    queueLengths = [q];
    epochs = [0];
    
    for e = 1:maxNumberOfEpochs
        if q == 0
            queueLengths = [queueLengths, q];
            epochs = [epochs, currentTime];
            
            nextArrivalTime = exprnd(1/arrivalRate);
            currentTime = currentTime + nextArrivalTime;
            q = q + 1;
        end
        
        [nextDepartureTime, nextn] = sampleServiceTime(n);
        n = nextn;
        numNewArrivals = poissrnd(arrivalRate * nextDepartureTime);
        
        queueLengths = [queueLengths, q + 0.5 * arrivalRate * nextDepartureTime];
        epochs = [epochs, currentTime];
        
        q = q - 1 + numNewArrivals;
        currentTime = currentTime + nextDepartureTime;
    end
    
    totalQueueLength = sum(queueLengths(1:end - 1) .* diff(epochs));
    averageQueueLength = averageQueueLength + totalQueueLength/currentTime;
end

averageQueueLength = averageQueueLength / numRuns;
averageDelay = averageQueueLength / arrivalRate;


function [x, nr] = sampleServiceTime(num)
    k = 0;
    nr = num;
    x = 0;
    while k < numberOfCopies
        relayDestinationMeetingTime = exprnd(1/nr/meetingRate);
        relaySourceMeetingTime = exprnd(1/(numberOfRelays - nr)/meetingRate);
        
        [minTime, event] = min([relayDestinationMeetingTime, relaySourceMeetingTime]);
        if event == 1
            nr = nr - 1;
            x = x + minTime;
        else
            nr = nr + 1;
            k = k + 1;
            x = x + minTime;
        end
    end
end
end
