% Comparison of delivery delay for different delivery mechanisms
% for B = 100, K = 5, beta = 0.1, lambda = 0.8 and 0.85 drawn as a function of N
B = 100;
beta = 0.1;
K = 5;
Ns = 50:50:500;
dd = zeros(numel(Ns), 1);

% for lambda = 0.8

for n = 1:numel(Ns)
    dd(n) = deliverydelay_approximation(beta, Ns(n), K);
end

figure(1);
hold on;

l80 = csvread('ResultsB100_N50_500_K5_Beta0.1_Lambda0.8.csv', 1);
plot(l80(:, 1), l80(:, 3), 'ro-');
% plot(l80(:, 1), dd, 'rv-');

l80 = csvread('NoFeedback-Random-RD/ResultsB100_N50_500_K5_Beta0.1_Lambda0.8.csv', 1);
plot(l80(:, 1), l80(:, 3), 'bo-');

l80 = csvread('NoFeedback-FIFO-RD/ResultsB100_N50_500_K5_Beta0.1_Lambda0.8.csv', 1);
plot(l80(:, 1), l80(:, 3), 'ko-');

l80 = csvread('NoFeedback-LIFO-RD/ResultsB100_N50_500_K5_Beta0.1_Lambda0.8.csv', 1);
plot(l80(:, 1), l80(:, 3), 'go-');

% % for lambda = 0.85
% for n = 1:numel(Ns)
%     dd(n) = deliverydelay_approximation(beta, Ns(n), K);
% end
% figure(2);
% hold on;
% 
% l85 = csvread('ResultsB100_N50_500_K5_Beta0.1_Lambda0.85.csv', 1);
% plot(l85(:, 1), l85(:, 3), 'k');
% plot(l85(:, 1), dd, 'c');

