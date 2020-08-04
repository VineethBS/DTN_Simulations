function packets = singleRelaySingleCopySimulation(arrivalRate, meetingRate, maxNumberOfArrivals)
% Returns a structure array of packets with packet id, entry time, service
% time, and delivery time. This array can be post-processed to obtain
% metrics of interest.

NotServiced = -1;

currentTime = 0; % the actual time

currentQueue = [];
currentQueueLength = 0;

% The current stage of service for the head of line packet
currentServiceStage = 1;

% Since delivery delay needs to be simulated we cannot just simulate a
% CTMC, but we need to track each packet. The packets that arrive into the
% system are put in a list (packets) for processing at the end.
% currentPacketNumber is used to generate the packet ids.
currentPacketNumber = currentQueueLength;
idleFlag = 0;

while currentPacketNumber < maxNumberOfArrivals % run the simulation until maxNumberOfArrivals has happened
    currentQueueLength = length(currentQueue);
    
    if currentQueueLength == 0
        % We sample the exponential time to the next arrival
        sampleInterarrivalTime = exprnd(1/arrivalRate);
        currentTime = currentTime + sampleInterarrivalTime;
        currentPacketNumber = currentPacketNumber + 1;
        packets(currentPacketNumber).entryTime = currentTime;
        packets(currentPacketNumber).firstServiceTime = currentTime;
        packets(currentPacketNumber).serviceTime = NotServiced;
        currentQueue = [currentQueue, currentPacketNumber];
        idleFlag = 1;
    else
        % We sample the service time
        if idleFlag == 1
            if rand <= arrivalRate/(arrivalRate + meetingRate)
                sampleServiceTime = exprnd(1/meetingRate) + exprnd(1/meetingRate);
                % sampleServiceTime = exprnd(1/meetingRate); % for M/M/1 testing
            else
                sampleServiceTime = exprnd(1/meetingRate);
            end
            idleFlag = 0;
        else
            sampleServiceTime = exprnd(1/meetingRate) + exprnd(1/meetingRate);
            % sampleServiceTime = exprnd(1/meetingRate); % for M/M/1 testing
        end
        % New arrivals in this service time
        numNewArrivals = poissrnd(arrivalRate * sampleServiceTime);
        newArrivalTimes = unifrnd(currentTime, currentTime + sampleServiceTime, numNewArrivals, 1);
        newArrivalTimes = sort(newArrivalTimes);
        for i = 1:numNewArrivals
            currentPacketNumber = currentPacketNumber + 1;
            packets(currentPacketNumber).entryTime = newArrivalTimes(i);
            packets(currentPacketNumber).firstServiceTime = NotServiced;
            packets(currentPacketNumber).serviceTime = NotServiced;
            currentQueue = [currentQueue, currentPacketNumber];
        end
        
        currentTime = currentTime + sampleServiceTime;
        
        currentServiceStage = currentServiceStage - 1;
        if currentServiceStage == 0
            packets(currentQueue(1)).serviceTime = currentTime; % record the service time of this packet
            currentQueue(1) = []; % remove the packet from the source queue
            currentServiceStage = 1; % start service of the next packet in queue
            if ~isempty(currentQueue)
                if packets(currentQueue(1)).firstServiceTime == NotServiced % for the HOL packet
                    packets(currentQueue(1)).firstServiceTime = currentTime;
                end
            end
        end
    end
end
