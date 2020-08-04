function [packets, listNumOfInfectedRelaysEpochs, listNumOfInfectedRelaysAtDeparture, listNumOfInfectedRelaysFirstArrivalBusyPeriod] = simulate_DTN_protocol_debugging(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfArrivals)
% Returns a structure array of packets with packet id, entry time, service
% time, and delivery time. This array can be post-processed to obtain
% metrics of interest.

listNumOfInfectedRelaysEpochs = [];
listNumOfInfectedRelaysAtDeparture = [];
listNumOfInfectedRelaysFirstArrivalBusyPeriod = [];
epoch_details = [];

NotServiced = -1;
NotDelivered = -1;
NotInfected = 0;
Infected = 1;

currentTime = 0; % the actual time

% Initializing the queue
initialQueueLength = randi(initialQueueLengthLimit) - 1; % uniformly (randomly) pick the initial queue length from 0:initialQueueLengthLimit - 1
currentQueueLength = initialQueueLength; % the state(length) of the queue including the packet in service
currentQueue = [];

for p = 1:currentQueueLength
    packets(p).entryTime = currentTime;
    packets(p).firstServiceTime = NotServiced;
    packets(p).numInfectedRelaysAtFirstServiceTime = NotServiced;
    packets(p).serviceTime = NotServiced;
    packets(p).deliveryTime = NotDelivered;
    packets(p).epochTimes = [];
    currentQueue = [currentQueue, p];
end
packets(1).firstServiceTime = 0; % the HOL packet

% The current stage of service for the head of line packet
currentServiceStage = numberOfCopies;

% Since delivery delay needs to be simulated we cannot just simulate a
% CTMC, but we need to track each packet. The packets that arrive into the
% system are put in a list (packets) for processing at the end.
% currentPacketNumber is used to generate the packet ids.
currentPacketNumber = currentQueueLength;

% Since delivery delay needs to be simulated, we need to keep track of
% which relays are carrying which packets.
for r = 1:numberOfRelays
    relay(r).status = NotInfected; % if status is '0', then not infected (carrying packet), if '1' then infected (carrying packet)
    relay(r).packetId = 0;
end

while currentPacketNumber < maxNumberOfArrivals % run the simulation until maxNumberOfArrivals has happened
    currentQueueLength = length(currentQueue);

    numOfInfectedRelays = 0;
    for r = 1:numberOfRelays
        if relay(r).status == Infected
            numOfInfectedRelays = numOfInfectedRelays + 1;
        end
    end
    listNumOfInfectedRelaysEpochs = [listNumOfInfectedRelaysEpochs, numOfInfectedRelays];
    
    % We sample the exponential time to the next arrival
    sampleInterarrivalTime = exprnd(1/arrivalRate);
    
    % We sample the intercontact time for a source to meet a relay
    tempSourceRelayIntercontacts = [];
    for r = 1:numberOfRelays
        if relay(r).status == NotInfected
            tempSourceRelayIntercontacts = [tempSourceRelayIntercontacts; [r, exprnd(1/meetingRate)]];
        end
    end
    if size(tempSourceRelayIntercontacts, 1) > 0
        [minSourceRelayIntercontactTime, relayIndex] = min(tempSourceRelayIntercontacts(:, 2));
        minSourceRelayIntercontactTimeRelayIndex = tempSourceRelayIntercontacts(:, 1);
        minSourceRelayIntercontactTimeRelayIndex = minSourceRelayIntercontactTimeRelayIndex(relayIndex);
    else
        minSourceRelayIntercontactTime = Inf;
    end
    
    % We sample the intercontact time for relays to meet the destination
    tempRelayDestIntercontacts = [];
    for r = 1:numberOfRelays
        if relay(r).status == Infected
            tempRelayDestIntercontacts = [tempRelayDestIntercontacts; [r, exprnd(1/meetingRate)]];
        end
    end   
    if size(tempRelayDestIntercontacts, 1) > 0
        [minRelayDestIntercontactTime, relayIndex] = min(tempRelayDestIntercontacts(:, 2));
        minRelayDestIntercontactTimeRelayIndex = tempRelayDestIntercontacts(:, 1);
        minRelayDestIntercontactTimeRelayIndex = minRelayDestIntercontactTimeRelayIndex(relayIndex);
    else
        minRelayDestIntercontactTime = Inf;
    end
    
    % Which event occurs next?
    [intereventTime, eventId] = min([sampleInterarrivalTime, minSourceRelayIntercontactTime, minRelayDestIntercontactTime]);
    
    % Increment the current time
    currentTime = currentTime + intereventTime; 
    
    % Skip event
    skipEvent = 0;
    
    % Change the system according to the event that has happened
    if eventId == 1 % new packet has arrived
        % Track what happens for the current HOL packet
        % if currentQueueLength > 0
        %    packets(currentQueue(1)).epochTimes = [packets(currentQueue(1)).epochTimes; [1, currentTime]];
        % end
        currentPacketNumber = currentPacketNumber + 1;
        packets(currentPacketNumber).entryTime = currentTime;
        if currentQueueLength > 0
            packets(currentPacketNumber).firstServiceTime = NotServiced;
            packets(currentPacketNumber).numInfectedRelaysAtFirstServiceTime = NotServiced;
        else
            packets(currentPacketNumber).firstServiceTime = currentTime;
            % To find the distribution of infected relays for a packet
            % arrival to an empty system
            numOfInfectedRelays = 0;
            for r = 1:numberOfRelays
                if relay(r).status == Infected
                    numOfInfectedRelays = numOfInfectedRelays + 1;
                end
            end
            listNumOfInfectedRelaysFirstArrivalBusyPeriod = [listNumOfInfectedRelaysFirstArrivalBusyPeriod, numOfInfectedRelays];
            % Find the number of infected relays that this packet sees
            % This is for finding the service time for the M/G/1
            % approximation
            % packets(currentPacketNumber).numInfectedRelaysAtFirstServiceTime = numOfInfectedRelays;
            packets(currentPacketNumber).numInfectedRelaysAtFirstServiceTime = NotServiced;
        end
        packets(currentPacketNumber).serviceTime = NotServiced;
        packets(currentPacketNumber).deliveryTime = NotDelivered; % to record that it has still not been delivered
        packets(currentPacketNumber).epochTimes = [];
        currentQueue = [currentQueue, currentPacketNumber];
    elseif eventId == 2 % the source has met a relay
        if currentQueueLength == 0 % if queue length is 0, then don't copy
            skipEvent = 1;
            continue;
        end       
        if relay(minSourceRelayIntercontactTimeRelayIndex).status == Infected % if the relay already has a packet then don't copy
            skipEvent = 2;
            continue;
        end
        % Track what happens for the current HOL packet
        numOfInfectedRelays = 0;
        for r = 1:numberOfRelays
            if relay(r).status == Infected
                numOfInfectedRelays = numOfInfectedRelays + 1;
            end
        end
        
        if currentQueueLength > 0
            packets(currentQueue(1)).epochTimes = [packets(currentQueue(1)).epochTimes; [2, currentTime, numOfInfectedRelays]];
        end
      
        relay(minSourceRelayIntercontactTimeRelayIndex).status = Infected;
        relay(minSourceRelayIntercontactTimeRelayIndex).packetId = currentQueue(1); % assign the HoL packet to this relay

        currentServiceStage = currentServiceStage - 1;
        if currentServiceStage == 0 % have made enough copies
            packets(currentQueue(1)).serviceTime = currentTime; % record the service time of this packet
            currentQueue(1) = []; % remove the packet from the source queue
            currentServiceStage = numberOfCopies; % start service of the next packet in queue
            numOfInfectedRelays = 0;
            for r = 1:numberOfRelays
                if relay(r).status == Infected
                    numOfInfectedRelays = numOfInfectedRelays + 1;
                end
            end
            listNumOfInfectedRelaysAtDeparture = [listNumOfInfectedRelaysAtDeparture, numOfInfectedRelays];
            
            if ~isempty(currentQueue)
                if packets(currentQueue(1)).firstServiceTime == NotServiced % for the HOL packet
                    packets(currentQueue(1)).firstServiceTime = currentTime;
                    packets(currentQueue(1)).numInfectedRelaysAtFirstServiceTime = numOfInfectedRelays;
                end
            end
        end
    elseif eventId == 3 % an infected relay has met the destination
        if relay(minRelayDestIntercontactTimeRelayIndex).status == NotInfected % relay is not infected
            skipEvent = 3;
            continue;
        end
        % Track what happens for the current HOL packet
        numOfInfectedRelays = 0;
        for r = 1:numberOfRelays
            if relay(r).status == Infected
                numOfInfectedRelays = numOfInfectedRelays + 1;
            end
        end
        
        if currentQueueLength > 0
            packets(currentQueue(1)).epochTimes = [packets(currentQueue(1)).epochTimes; [3, currentTime, numOfInfectedRelays]];
        end
        
        relay(minRelayDestIntercontactTimeRelayIndex).status = 0; % become non-infected
        temp = relay(minRelayDestIntercontactTimeRelayIndex).packetId;
        
        if packets(temp).deliveryTime == NotDelivered
            packets(temp).deliveryTime = currentTime; % record the first time of delivery
        end
    end    
end
