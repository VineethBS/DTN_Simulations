function [packets, listNumOfInfectedRelays] = simulate_DTN_protocol_statusDependentMeeting(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfArrivals)
% Returns a structure array of packets with packet id, entry time, service
% time, and delivery time. This array can be post-processed to obtain
% metrics of interest.

listNumOfInfectedRelays = [];

NotServiced = -1;
NotDelivered = -1;

currentTime = 0; % the actual time

% Initializing the queue
initialQueueLength = randi(initialQueueLengthLimit) - 1; % uniformly (randomly) pick the initial queue length from 0:initialQueueLengthLimit - 1
currentQueueLength = initialQueueLength; % the state(length) of the queue including the packet in service
currentQueue = [];

for p = 1:currentQueueLength
    packets(p).entryTime = currentTime;
    packets(p).firstServiceTime = NotServiced;
    packets(p).serviceTime = NotServiced;
    packets(p).deliveryTime = NotDelivered;
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
    relay(r).status = 0; % if status is 0, then not infected (carrying packet), if 1 then infected (carrying packet)
    relay(r).packetId = 0;
end

while currentPacketNumber < maxNumberOfArrivals % run the simulation until maxNumberOfArrivals has happened
    currentQueueLength = length(currentQueue);
    
    numOfInfectedRelays = 0;
    for r = 1:numberOfRelays
        if relay(r).status == 1
            numOfInfectedRelays = numOfInfectedRelays + 1;
        end
    end
    listNumOfInfectedRelays = [listNumOfInfectedRelays, numOfInfectedRelays];

    % We sample the exponential time to the next arrival
    sampleInterarrivalTime = exprnd(1/arrivalRate);
    
    % We sample the intercontact time for a source to meet an uninfected relay
    tempSourceRelayIntercontacts = [];
    if currentQueueLength > 0
        for r = 1:numberOfRelays
            if relay(r).status == 0
                tempSourceRelayIntercontacts = [tempSourceRelayIntercontacts; [r, exprnd(1/meetingRate)]];
            end
        end
        if size(tempSourceRelayIntercontacts, 1) > 0
            [minSourceRelayIntercontactTime, relayIndex] = min(tempSourceRelayIntercontacts(:, 2));
            minSourceRelayIntercontactTimeRelayIndex = tempSourceRelayIntercontacts(:, 1);
            minSourceRelayIntercontactTimeRelayIndex = minSourceRelayIntercontactTimeRelayIndex(relayIndex);
        else % if there are no non-infected relays
            minSourceRelayIntercontactTime = Inf;
        end
    else
        minSourceRelayIntercontactTime = Inf; % if the source does not have any packets to transmit
    end
    
    % We sample the intercontact time for infected relays to meet the destination
    tempRelayDestIntercontacts = [];
    for r = 1:numberOfRelays
        if relay(r).status == 1
            tempRelayDestIntercontacts = [tempRelayDestIntercontacts; [r, exprnd(1/meetingRate)]];
        end
    end
   
    if size(tempRelayDestIntercontacts, 1) > 0
        [minRelayDestIntercontactTime, relayIndex] = min(tempRelayDestIntercontacts(:, 2));
        minRelayDestIntercontactTimeRelayIndex = tempRelayDestIntercontacts(:, 1);
        minRelayDestIntercontactTimeRelayIndex = minRelayDestIntercontactTimeRelayIndex(relayIndex);
    else % if there are no infected relays
        minRelayDestIntercontactTime = Inf;
    end
    
    % Which event occurs next?
    [intereventTime, eventId] = min([sampleInterarrivalTime, minSourceRelayIntercontactTime, minRelayDestIntercontactTime]);
    
    % Increment the current time
    currentTime = currentTime + intereventTime; 
    
    % Change the system according to the event that has happened
    if eventId == 1 % new packet has arrived
        currentPacketNumber = currentPacketNumber + 1;
        packets(currentPacketNumber).entryTime = currentTime;
        if currentQueueLength > 0
            packets(currentPacketNumber).firstServiceTime = NotServiced;
        else
            packets(currentPacketNumber).firstServiceTime = currentTime;
        end
        packets(currentPacketNumber).serviceTime = NotServiced;
        packets(currentPacketNumber).deliveryTime = NotDelivered; % to record that it has still not been delivered
        currentQueue = [currentQueue, currentPacketNumber];
    elseif eventId == 2 % the source queue is non-empty and the source has met a relay
        relay(minSourceRelayIntercontactTimeRelayIndex).status = 1;
        relay(minSourceRelayIntercontactTimeRelayIndex).packetId = currentQueue(1); % assign the HoL packet to this relay

        currentServiceStage = currentServiceStage - 1;
        if currentServiceStage == 0 % have made enough copies
            packets(currentQueue(1)).serviceTime = currentTime; % record the service time of this packet
            currentQueue(1) = []; % remove the packet from the source queue
            currentServiceStage = numberOfCopies; % start service of the next packet in queue
            if ~isempty(currentQueue)
                if packets(currentQueue(1)).firstServiceTime == NotServiced % for the HOL packet
                    packets(currentQueue(1)).firstServiceTime = currentTime;
                end
            end 
        end
    elseif eventId == 3 % an infected relay has met the destination
        relay(minRelayDestIntercontactTimeRelayIndex).status = 0; % become non-infected
        temp = relay(minRelayDestIntercontactTimeRelayIndex).packetId;
        
        if packets(temp).deliveryTime == NotDelivered
            packets(temp).deliveryTime = currentTime; % record the first time of delivery
        end
    end
end
