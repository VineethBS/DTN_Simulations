no = sqrt(10);

% % figure 1
% x = csvread('Qcompare_RFIFOLIFO_B1_N50_K5_Beta0.1_Rho01_09.csv', 1, 0);
% arrival_rates = x(:, 1);
% FIFO_Q = x(:, 2);
% FIFO_Q_std = x(:, 4)/no;
% R_Q = x(:,6);
% R_Q_std = x(:, 8)/no;
% LIFO_Q = x(:, 10);
% LIFO_Q_std = x(:, 12)/no;
% 
% figure(1);
% hold on;
% errorbar(arrival_rates, FIFO_Q, FIFO_Q_std, 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, R_Q, R_Q_std, 'ko:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, LIFO_Q, LIFO_Q_std, 'k*:', 'LineWidth', 2, 'MarkerSize', 4);
% xlabel('Arrival Rate - \lambda (packets/sec)');
% ylabel('Average queueing delay (secs)');

% % figure 1
% x = csvread('Qcompare_RFIFOLIFO_B10_N250_K20_Beta0.5_Rho01_098.csv', 1, 0);
% arrival_rates = x(:, 1);
% FIFO_Q = x(:, 2);
% FIFO_Q_std = x(:, 4)/no;
% R_Q = x(:,6);
% R_Q_std = x(:, 8)/no;
% LIFO_Q = x(:, 10);
% LIFO_Q_std = x(:, 12)/no;
% 
% figure(1);
% hold on;
% errorbar(arrival_rates, FIFO_Q, 2 * FIFO_Q_std, 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, R_Q, 2 * R_Q_std, 'ko:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, LIFO_Q, 2 * LIFO_Q_std, 'ks:', 'LineWidth', 2, 'MarkerSize', 4);
% xlabel('Arrival Rate - \lambda (packets/sec)');
% ylabel('Average queueing delay (secs)');

% figure 1
x = csvread('Qcompare_RFIFOLIFO_B500_N50_K5_Beta0.1_Lambda01_098.csv', 1, 0);
arrival_rates = x(:, 1);
FIFO_Q = x(:, 2);
FIFO_Q_std = x(:, 4)/no;
R_Q = x(:,6);
R_Q_std = x(:, 8)/no;
LIFO_Q = x(:, 10);
LIFO_Q_std = x(:, 12)/no;

figure(1);
hold on;
errorbar(arrival_rates, FIFO_Q, 2 * FIFO_Q_std, 'kv:', 'LineWidth', 3, 'MarkerSize', 8);
errorbar(arrival_rates, R_Q, 2 * R_Q_std, 'ko:', 'LineWidth', 3, 'MarkerSize', 8);
errorbar(arrival_rates, LIFO_Q, 2 * LIFO_Q_std, 'ks:', 'LineWidth', 3, 'MarkerSize', 8);
xlabel('Arrival Rate - \lambda (packets/sec)');
ylabel('Average queueing delay (secs)');
grid on;


