function run_simulation_configuration_xls_deliveryDelay(xlsfile)
% Runs the simulation based on the run configuration mentioned in the
% configuration (xls) file

% the column names
NumRuns = 1;
arrivalRateMin = 2;
arrivalRateStep = 3; 
arrivalRateMax = 4;
meetingRateMin = 5;
meetingRateStep	= 6;
meetingRateMax = 7;
numRelayMin = 8;
numRelayStep = 9;
numRelayMax	= 10;
numCopiesMin = 11;
numCopiesStep = 12; 
numCopiesMax = 13;
filename = 14;

maxNumberOfArrivals = 15000;
initialQueueLengthLimit = 10;
numInitialPacketsDiscarded =  1000;
data = importdata(xlsfile);
configurations = data.data(2:end, :);
outputFileNames = data.textdata;

for l = 1:size(configurations, 1)
    data = [];
    configuration = configurations(l, :);
    if configuration(NumRuns) == 0
        continue;
    end
    for arrivalRate = configuration(arrivalRateMin): configuration(arrivalRateStep): configuration(arrivalRateMax)
        for meetingRate = configuration(meetingRateMin): configuration(meetingRateStep): configuration(meetingRateMax)
            for numberOfRelays = configuration(numRelayMin): configuration(numRelayStep): configuration(numRelayMax)
                for numberOfCopies = configuration(numCopiesMin): configuration(numCopiesStep): configuration(numCopiesMax)
                    currentNumRuns = configuration(NumRuns);
                    averageQueueingDelays = zeros(1, currentNumRuns);
                    averageDeliveryDelays = zeros(1, currentNumRuns);
                    averageServiceTimes = zeros(1, currentNumRuns);
                    for r = 1:currentNumRuns
                        fprintf('%u,%u : arrivalrate %0.2f meetingrate %0.2f numrelays %u numcopies %u\n', l, r, arrivalRate, meetingRate, numberOfRelays, numberOfCopies);
                        packets = simulate_DTN_protocol(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfArrivals);
                        [averageQueueingDelays(r), ~, averageServiceTimes(r), ~, averageDeliveryDelays(r), ~, ~, ~, ~] = find_averages(packets,numInitialPacketsDiscarded);
                    end
                    
                    averageQDelayApprox = MGKDelayApproximation(arrivalRate, meetingRate, numberOfRelays, numberOfCopies);
                    averageWaitingTimes = averageQueueingDelays - averageServiceTimes;
                    data = [data; [arrivalRate, meetingRate, numberOfRelays, numberOfCopies, averageQDelayApprox, mean(averageQueueingDelays), std(averageQueueingDelays), mean(averageDeliveryDelays), std(averageDeliveryDelays), mean(averageWaitingTimes), std(averageWaitingTimes)]];
                    csvwrite(outputFileNames{l + 1, filename}, data);
                end
            end
        end
    end
end