%% Script to obtain plots for the Comsnets paper
colNumRelay = 3;
colNumCopies = 4;
colApproxQD = 5;
colSimQD = 6;
colStdQD = 7;
colSimDD = 8;
colStdDD = 9;
colSimWD = 10;
colStdWD = 11;

numRuns = 5;

%% Read the results from the simulation
% nr50 = csvread('varNumCopiesArrivalRate0.45MeetingRate1NumRelay50.csv');
% nr100 = csvread('varNumCopiesArrivalRate0.45MeetingRate1NumRelay100.csv');

nr50 = csvread('newvarNumCopiesArrivalRate0.45MeetingRate1NumRelay50.csv');
nr100 = csvread('newvarNumCopiesArrivalRate0.45MeetingRate1NumRelay100.csv');

%% 1. Plot the delivery delay as a function of k/n and show that there is optimum k at which the delivery delay is minimized
figure(1);
errorbar(nr50(:, colNumCopies) / nr50(1, colNumRelay), nr50(:, colSimDD), 2 * nr50(:, colStdDD) / sqrt(numRuns), 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
hold on;
errorbar(nr100(:, colNumCopies) / nr100(1, colNumRelay), nr100(:, colSimDD), 2 * nr100(:, colStdDD) / sqrt(numRuns), 'ko:', 'LineWidth', 2, 'MarkerSize', 4);

%% 2. Plot the two components of the delay - note that the underlying parameter that changes is the number of copies K
figure(2);
hold on;
plot(nr50(:, colSimDD), nr50(:, colSimQD), 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
plot(nr100(:, colSimDD), nr100(:, colSimQD), 'ko:', 'LineWidth', 2, 'MarkerSize', 4);
plot(nr50(:, colSimDD), nr50(:, colApproxQD), 'kv-', 'LineWidth', 2, 'MarkerSize', 4);
plot(nr100(:, colSimDD), nr100(:, colApproxQD), 'ko-', 'LineWidth', 2, 'MarkerSize', 4);

%% 3. Plot the end to end delay as a function of k/n
figure(3)
errorbar(nr50(:, colNumCopies) / nr50(1, colNumRelay), nr50(:, colSimDD) + nr50(:, colSimWD), 2 * (sqrt(nr50(:, colStdDD).^2 + nr50(:, colStdWD).^2)) / sqrt(numRuns), 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
hold on
errorbar(nr100(:, colNumCopies) / nr100(1, colNumRelay), nr100(:, colSimDD) + nr100(:, colSimWD), 2 * (sqrt(nr100(:, colStdDD).^2 + nr100(:, colStdWD).^2))/ sqrt(numRuns), 'ko:', 'LineWidth', 2, 'MarkerSize', 4);