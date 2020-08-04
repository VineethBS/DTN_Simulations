%% Comparison of queueing delay and delivery delay for the case with feedback

% Comparison for B = 1, N = 50, K = 5, beta = 0.1 as a function of \lambda

b1 = csvread('Results_B1_N50_K5_Beta0.1_LambdaVar.csv', 1);
b5 = csvread('Results_B5_N50_K5_Beta0.1_LambdaVar.csv', 1);
b10 = csvread('Results_B10_N50_K5_Beta0.1_LambdaVar.csv', 1);
b100 = csvread('Results_B100_N50_K5_Beta0.1_LambdaVar.csv', 1);
b500 = csvread('Results_B500_N50_K5_Beta0.1_LambdaVar.csv', 1);

figure(1);
hold on;
plot(b1(:,1), b1(:, 2), 'm:o', 'LineWidth', 2);
plot(b5(:,1), b5(:, 2), 'c:o', 'LineWidth', 2);
% plot(b10(:,1), b10(:, 2), 'k:o', 'LineWidth', 2);
plot(b100(:,1), b100(:, 2), 'r:o', 'LineWidth', 2);
% plot(b500(:,1), b500(:, 2), 'b:o', 'LineWidth', 2);

figure(2);
hold on;
plot(b1(:,1), b1(:, 3), 'm:o', 'LineWidth', 2);
plot(b5(:,1), b5(:, 3), 'c:o', 'LineWidth', 2);
% plot(b10(:,1), b10(:, 3), 'k:o', 'LineWidth', 2);
plot(b100(:,1), b100(:, 3), 'r:o', 'LineWidth', 2);
% plot(b500(:,1), b500(:, 3), 'b:o', 'LineWidth', 2);

b1 = csvread('Results_LIFO/Results_B1_N50_K5_Beta0.1_LambdaVar.csv', 1);
b5 = csvread('Results_LIFO/Results_B5_N50_K5_Beta0.1_LambdaVar.csv', 1);
b10 = csvread('Results_LIFO/Results_B10_N50_K5_Beta0.1_LambdaVar.csv', 1);
b100 = csvread('Results_LIFO/Results_B100_N50_K5_Beta0.1_LambdaVar.csv', 1);
b500 = csvread('Results_LIFO/Results_B500_N50_K5_Beta0.1_LambdaVar.csv', 1);

figure(1);
hold on;
plot(b1(:,1), b1(:, 2), 'm-o', 'LineWidth', 2);
plot(b5(:,1), b5(:, 2), 'c-o', 'LineWidth', 2);
% plot(b10(:,1), b10(:, 2), 'k-o', 'LineWidth', 2);
plot(b100(:,1), b100(:, 2), 'r-o', 'LineWidth', 2);
% plot(b500(:,1), b500(:, 2), 'b-o', 'LineWidth', 2);
hold off;

figure(2);
hold on;
plot(b1(:,1), b1(:, 3), 'm-', 'LineWidth', 2);
plot(b5(:,1), b5(:, 3), 'c-', 'LineWidth', 2);
% plot(b10(:,1), b10(:, 3), 'k-', 'LineWidth', 2);
plot(b100(:,1), b100(:, 3), 'r-', 'LineWidth', 2);
% plot(b500(:,1), b500(:, 3), 'b-', 'LineWidth', 2);
hold off

% Comparison of queueing delay and delivery delay for B = 100 and B = 500 for N = 50, K = 5, beta = 0.1 as a function of
% lambda
% beta = 0.5;
% K = 20;
% N = 250;
% rho = [0.1:0.1:0.9, 0.91:0.01:0.98]';
% 
% b1 = csvread('Results_B1_N250_K20_Beta0.5_LambdaVar.csv', 1);
% b5 = csvread('Results_B5_N250_K20_Beta0.5_LambdaVar.csv', 1);
% b10 = csvread('Results_B10_N250_K20_Beta0.5_LambdaVar.csv', 1);
% b100 = csvread('Results_B100_N250_K20_Beta0.5_LambdaVar.csv', 1);
% b500 = csvread('Results_B500_N250_K20_Beta0.5_LambdaVar.csv', 1);
% 
% delivery_delay_approx = deliverydelay_approximation(beta, N, K);
% delivery_delay_approx = delivery_delay_approx * ones(numel(rho), 1);
% [queueing_delay_approx, ~] = MkM1_approximation(rho * (N*beta/K), beta, N, K);
% 
% figure(3);
% hold on;
% plot(rho, b1(:, 2), 'm');
% plot(rho, b5(:, 2), 'c');
% plot(rho, b10(:, 2), 'k');
% plot(b100(:, 1)/(N * beta/K), b100(:, 2), 'r');
% plot(b100(:, 1)/(N * beta/K), b500(:, 2), 'b');
% plot(rho, queueing_delay_approx, 'g');

% Plot wrt arrival rate
% plot(b1(:,1), b1(:, 2), 'm');
% plot(b5(:,1), b5(:, 2), 'c');
% plot(b10(:,1), b10(:, 2), 'k');
% plot(b100(:, 1), b100(:, 2), 'r');
% plot(b500(:, 1), b500(:, 2), 'b');
% plot(rho * (N*beta/K), queueing_delay_approx, 'g');
% hold off;
% figure(4);
% hold on;
% plot(rho, b1(:, 3), 'm');
% plot(rho, b5(:, 3), 'c');
% plot(rho, b10(:, 3), 'k');
% plot(b100(:, 1)/(N * beta/K), b100(:, 3), 'r');
% plot(b100(:, 1)/(N * beta/K), b500(:, 3), 'b');
% plot(rho, delivery_delay_approx, 'g');
% hold off

% % Comparison of queueing delay and delivery delay for B = 100, K = 5, beta = 0.1, lambda = 0.8 and 0.85 as a function of
% % N
% B = 100;
% beta = 0.1;
% K = 5;
% Ns = 50:50:500;
% dd = zeros(numel(Ns), 1);
% qd = dd;
% 
% lambda = 0.8;
% l80 = csvread('ResultsB100_N50_500_K5_Beta0.1_Lambda0.8.csv', 1);
% for n = 1:numel(Ns)
%     dd(n) = deliverydelay_approximation(beta, Ns(n), K);
%     [qd(n), ~] = MkM1_approximation(lambda, beta, Ns(n), K);
% end
% figure(1);
% hold on;
% plot(l80(:, 1), l80(:, 2), 'r');
% plot(l80(:, 1), qd, 'b');
% figure(2);
% hold on;
% plot(l80(:, 1), l80(:, 3), 'r');
% plot(l80(:, 1), dd, 'b');
% lambda = 0.85;
% l85 = csvread('ResultsB100_N50_500_K5_Beta0.1_Lambda0.85.csv', 1);
% for n = 1:numel(Ns)
%     dd(n) = deliverydelay_approximation(beta, Ns(n), K);
%     [qd(n), ~] = MkM1_approximation(lambda, beta, Ns(n), K);
% end
% figure(1);
% plot(l85(:, 1), l85(:, 2), 'k');
% plot(l85(:, 1), qd, 'c');
% figure(2);
% hold on;
% plot(l85(:, 1), l85(:, 3), 'k');
% plot(l85(:, 1), dd, 'c');

% Comparison of queueing delay and delivery delay for B = 500, beta = 0.5, lambda = 0.7 as a function
% of K for N = 50 and 100
% B = 500;
% beta = 0.5;
% Ks = [5, 10, 15, 20, 25, 30];
% lambda = 0.7;
% 
% n50 = csvread('ResultsB500_N50_K5_30_Beta0.5_Lambda07.csv', 1);
% n100 = csvread('ResultsB500_N100_K5_30_Beta0.5_Lambda07.csv', 1);
% qd = zeros(numel(n50(:, 1)), 1);
% dd = qd;
% 
% figure(1);
% hold on;
% plot(n50(:, 1), n50(:, 2), 'r');
% plot(n100(:, 1), n100(:, 2), 'b');
% figure(2);
% hold on;
% plot(n50(:, 1), n50(:, 3), 'r');
% plot(n100(:, 1), n100(:, 3), 'b');
% 
% N = 50;
% for k = 1:numel(Ks)
%     [qd(k), ~] = MkM1_approximation(lambda, beta, N, Ks(k));
%     dd(k) = deliverydelay_approximation(beta, N, Ks(k));
% end
% figure(1);
% plot(n50(:, 1), qd, 'k');
% figure(2);
% plot(n50(:, 1), dd, 'k');
% 
% N = 100;
% for k = 1:numel(Ks)
%     [qd(k), ~] = MkM1_approximation(lambda, beta, N, Ks(k));
%     dd(k) = deliverydelay_approximation(beta, N, Ks(k));
% end
% figure(1);
% plot(n100(:, 1), qd, 'c');
% figure(2);
% plot(n100(:, 1), dd, 'c');