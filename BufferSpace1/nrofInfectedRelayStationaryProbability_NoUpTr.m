function stationaryProbability = nrofInfectedRelayStationaryProbability(numOfRelays)

birthRates = numOfRelays: -1 : 1;
deathRates = 1:numOfRelays;

multFactor = birthRates ./ deathRates;
multFactor = cumprod(multFactor);

stationaryProbability(1) = 1 / (1 + sum(multFactor));

for r = 2:(numOfRelays + 1)
    stationaryProbability(r) = stationaryProbability(1) * multFactor(r - 1);
end
