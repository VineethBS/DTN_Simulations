% Threshold wo feedback
th = @(N, beta, K) (N * beta/K/2);

figure(1);
hold on;

% Case 1
N = 50;
beta = 0.1;
Ks = 2:1:25;
threshold_withfeedback = zeros(1, numel(Ks));
threshold_wofeedback = zeros(1, numel(Ks));

for i = 1:numel(Ks)
    threshold_withfeedback(i) = saturation_throughput(N, beta, Ks(i));
    threshold_wofeedback(i) = th(N, beta, Ks(i));
end

plot(Ks, threshold_withfeedback, 'r');
plot(Ks, threshold_wofeedback, 'k');

% Case 2
N = 50;
beta = 1;
Ks = 2:1:25;
threshold_withfeedback = zeros(1, numel(Ks));
threshold_wofeedback = zeros(1, numel(Ks));

for i = 1:numel(Ks)
    threshold_withfeedback(i) = saturation_throughput(N, beta, Ks(i));
    threshold_wofeedback(i) = th(N, beta, Ks(i));
end

plot(Ks, threshold_withfeedback, 'g');
plot(Ks, threshold_wofeedback, 'b');

% Case 3
N = 150;
beta = 0.1;
Ks = 2:1:40;
threshold_withfeedback = zeros(1, numel(Ks));
threshold_wofeedback = zeros(1, numel(Ks));

for i = 1:numel(Ks)
    threshold_withfeedback(i) = saturation_throughput(N, beta, Ks(i));
    threshold_wofeedback(i) = th(N, beta, Ks(i));
end

plot(Ks, threshold_withfeedback, 'r');
plot(Ks, threshold_wofeedback, 'k');

% Case 4
N = 150;
beta = 0.5;
Ks = 2:1:40;
threshold_withfeedback = zeros(1, numel(Ks));
threshold_wofeedback = zeros(1, numel(Ks));

for i = 1:numel(Ks)
    threshold_withfeedback(i) = saturation_throughput(N, beta, Ks(i));
    threshold_wofeedback(i) = th(N, beta, Ks(i));
end

plot(Ks, threshold_withfeedback, 'g');
plot(Ks, threshold_wofeedback, 'b');

legend('N = 50, \beta = 0.1 (F)', 'N = 50, \beta = 0.1 (NF)', ... 
    'N = 50, \beta = 1 (F)', 'N = 50, \beta = 1 (NF)', ...
    'N = 150, \beta = 0.1 (F)', 'N = 150, \beta = 0.1 (NF)', ...
    'N = 150, \beta = 0.5 (F)', 'N = 150, \beta = 0.5 (NF)');
