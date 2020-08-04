function run_simulation_configuration_xls(xlsfile)
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

maxNumberOfEpochs = 500000;
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
                    %%%%%%%%%%%%%%%%%%%%%%%%% Earlier code to be used for the case of DTN protocol simulation with packet traces %%%%%%%%%%%%%%%%%%%%%%%%% 
                    % [packets, ~] = simulate_DTN_protocol(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfArrivals);
                    % [packets, ~] = simulate_DTN_protocol_statusDependentMeeting(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfArrivals);
                    % [avgQueueingDelay, stdQueueingDelay, avgServiceTime, stdServiceTime, avgDeliveryDelay, stdDeliveryDelay, avgDelay, stdDelay, fractionPacketsDelivered] = find_averages(packets,numInitialPacketsDiscarded);
                    % averageDelayApprox = queueingDelayApproximation(arrivalRate, meetingRate, numberOfRelays, numberOfCopies);
                    % averageDelayApprox = singleRelaySingleCopyDelayApproximation(arrivalRate, meetingRate);
                    % data = [data; [arrivalRate, meetingRate, numberOfRelays, numberOfCopies, averageDelayApprox, avgQueueingDelay, stdQueueingDelay, avgServiceTime, stdServiceTime, avgDeliveryDelay, stdDeliveryDelay, avgDelay, stdDelay, fractionPacketsDelivered]];
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    currentNumRuns = configuration(NumRuns);
                    averageQueueLengths = zeros(1, currentNumRuns);
                    averageDelays = zeros(1, currentNumRuns);
                    for r = 1:currentNumRuns
                        fprintf('%u,%u : arrivalrate %0.2f meetingrate %0.2f numrelays %u numcopies %u\n', l, r, arrivalRate, meetingRate, numberOfRelays, numberOfCopies);
                        [averageQueueLengths(r), averageDelays(r)] = simulate_CTMC(arrivalRate, meetingRate, numberOfRelays, numberOfCopies, initialQueueLengthLimit, maxNumberOfEpochs);
                    end
                    averageDelayApprox = MGKDelayApproximation(arrivalRate, meetingRate, numberOfRelays, numberOfCopies);
                    data = [data; [arrivalRate, meetingRate, numberOfRelays, numberOfCopies, mean(averageDelays), std(averageDelays), averageDelayApprox]];
                end
            end
        end
    end
    csvwrite(outputFileNames{l + 1, filename}, data);
end