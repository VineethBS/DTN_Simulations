numRuns = 1;
numSources = 2;
commonArrivalRate = 3;
arrivalRateMin = 4;
arrivalRateStep = 5;
arrivalRateMax = 6;
meetingRateMin = 7;
meetingRateStep = 8;
meetingRateMax = 9;
numRelayMin = 10;
numRelayStep = 11;
numRelayMax = 12;
numCopiesMin = 13;
numCopiesStep = 14;
numCopiesMax = 15;
relayBufferSize = 16;

config = xlsread('2SDPair/configuration.xls');
config = config(:,1);
config = config(2:end);
arrivalrates = config(arrivalRateMin):config(arrivalRateStep):config(arrivalRateMax);
approxdelay = zeros(length(arrivalrates), 1);

for i = 1:length(arrivalrates)
    approxdelay(i) = MGKDelayApproximation(arrivalrates(i), config(meetingRateMin), config(numRelayMin), config(numCopiesMin), config(numSources));
end

plot(arrivalrates, approxdelay, 'o');