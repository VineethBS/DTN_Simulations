function [avgQueueingDelay, stdQueueingDelay, avgServiceTime, stdServiceTime, avgDeliveryDelay, stdDeliveryDelay, avgDelay, stdDelay, fractionPacketsDelivered] = find_averages(packets, numInitialPacketsDiscarded)

entryTime = [packets.entryTime];
firstServiceTime = [packets.firstServiceTime];
serviceTime = [packets.serviceTime];
deliveryTime = [packets.deliveryTime];

entryTime = entryTime(numInitialPacketsDiscarded + 1:end);
firstServiceTime = firstServiceTime(numInitialPacketsDiscarded + 1:end);
serviceTime = serviceTime(numInitialPacketsDiscarded + 1:end);
deliveryTime = deliveryTime(numInitialPacketsDiscarded + 1:end);

totalNumberOfPackets = length(entryTime);
numberOfPacketsServed = length(serviceTime(serviceTime > 0));
numberOfPacketsDelivered = length(deliveryTime(deliveryTime > 0));
fractionPacketsDelivered = numberOfPacketsDelivered / totalNumberOfPackets;

queueingDelays = serviceTime(1:numberOfPacketsServed) - entryTime(1:numberOfPacketsServed);
avgQueueingDelay = mean(queueingDelays);
stdQueueingDelay = std(queueingDelays);

serviceTimes = serviceTime(1:numberOfPacketsServed) - firstServiceTime(1:numberOfPacketsServed);
avgServiceTime = mean(serviceTimes);
stdServiceTime = std(serviceTimes);

deliveryTimes = deliveryTime(1:numberOfPacketsDelivered) - firstServiceTime(1:numberOfPacketsDelivered);
avgDeliveryDelay = mean(deliveryTimes);
stdDeliveryDelay = std(deliveryTimes);

delays = deliveryTime(1:numberOfPacketsDelivered) - entryTime(1:numberOfPacketsDelivered);
avgDelay = mean(delays);
stdDelay = std(delays);





