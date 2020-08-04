function [averageQueueLength, averageDelay] = simulate_CTMC(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfEpochs)

currentTime = 0;
initialQueueLength = randi(initialQueueLengthLimit) - 1; % uniformly (randomly) pick the initial queue length from 0:initialQueueLengthLimit - 1

q = initialQueueLength; % the state(length) of the queue including the packet in service
k = 0; % the current stage of service for the packet at head of line
n = 0; % the number of infected relays

queueLengths = zeros(1, maxNumberOfEpochs);
epochs = zeros(1, maxNumberOfEpochs);

for e = 1:maxNumberOfEpochs
    queueLengths(e) = q;
    epochs(e) = currentTime;

    interArrivalTime = exprnd(1/arrivalRate);
    relayDestinationTime = exprnd(1/n/meetingRate);
    sourceRelayTime = exprnd(1/(numberOfRelays - n)/meetingRate);
    
    [minTime, minTimeIndex] = min([interArrivalTime, relayDestinationTime, sourceRelayTime]);
    
    currentTime = currentTime + minTime;
    
    if minTimeIndex == 1
        q = q + 1;
    elseif minTimeIndex == 2
        n = n - 1;
    elseif minTimeIndex == 3
        if q > 0
            k = k + 1;
            n = n + 1;
            if k == numberOfCopies
                k = 0;
                q = q - 1;
            end
        end
    end
end

totalQueueLength = sum(queueLengths(1:end - 1) .* diff(epochs));
averageQueueLength = totalQueueLength/currentTime;
averageDelay = averageQueueLength/arrivalRate;
