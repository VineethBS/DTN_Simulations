function plot_results_configuration_xls(xlsfile)
% Plots the results for simulation based on the run configuration mentioned in the
% configuration (xls) file

% the column names
runOrNot = 1;
filename = 14;

data = importdata(xlsfile);
configurations = data.data(2:end, :);
outputFileNames = data.textdata;

data_arrivalrate = 1;
data_meetingrate = 2;
data_numrelays = 3;
data_numcopies = 4;
data_simdelay = 5;
data_simstd = 6;
data_approx = 7;

for l = 1:size(configurations, 1)
    data = [];
    configuration = configurations(l, :);
    if configuration(runOrNot) == 0
        continue;
    end
    data = csvread(outputFileNames{l + 1, filename});

    arrivalrates = data(:, data_arrivalrate);
    meetingrate = data(1, data_meetingrate);
    numrelays = data(1, data_numrelays);
    numcopies = data(1, data_numcopies);
    simdelays = data(:, data_simdelay);
    simstd = data(:, data_simstd);
    approx = data(:, data_approx);
    
    if numrelays == 1
        exactdelay = zeros(1, length(arrivalrates));
        for a = 1:length(arrivalrates)
            exactdelay(a) = singleRelayKCopiesDelayApproximation(arrivalrates(a), meetingrate, numcopies);
        end
    end
    figure(l);
    errorbar(arrivalrates, simdelays, 2 * simstd/sqrt(configuration(runOrNot)), 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
    hold on;
    plot(arrivalrates, approx, 'ko:', 'LineWidth', 2, 'MarkerSize', 8);
    if numrelays == 1
        plot(arrivalrates, exactdelay, 'kx:', 'LineWidth', 2, 'MarkerSize', 8);
        legend('Simulated average delay', 'Analytical approximation', 'Exact analysis');
    else
        legend('Simulated average delay', 'Analytical approximation');
    end
    xlabel('Arrival rate - \lambda');
    ylabel('Average delay');
    grid on;
    title(sprintf('Meeting rate = %0.2f, Number of Relays = %u, Number of Copies = %u', meetingrate, numrelays, numcopies));
end