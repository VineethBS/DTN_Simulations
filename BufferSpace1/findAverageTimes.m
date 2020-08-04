function [averageIdleTime, averageBusyTime, averageIdleProbability, nAtStartOfBusy] = findAverageTimes(queueLengths, epochs, n)

last_state = 0;
state = 0;

idleperiods = [];
busyperiods = [];
nAtStartOfBusy = [];

idlePeriodStart = 0;
busyPeriodStart = 0;
idlePeriodEnd = 0;
busyPeriodEnd = 0;

for i = 2:length(queueLengths)
    if queueLengths(i - 1) == 0 && queueLengths(i) > 0
        busyPeriodStart = epochs(i);
        nAtStartOfBusy = [nAtStartOfBusy, n(i)];
        idlePeriodEnd = epochs(i);
        last_state = state;
        state = 1;
        if last_state == 2
            idleperiods = [idleperiods, idlePeriodEnd - idlePeriodStart];
        end
    end
    if queueLengths(i - 1) > 0 && queueLengths(i) == 0
        busyPeriodEnd = epochs(i);
        idlePeriodStart = epochs(i);
        last_state = state;
        state = 2;
        if last_state == 1
            busyperiods = [busyperiods, busyPeriodEnd - busyPeriodStart];
        end
    end
end
   
averageIdleTime = mean(idleperiods);
averageBusyTime = mean(busyperiods);
averageIdleProbability = averageIdleTime / (averageIdleTime + averageBusyTime);

        
        