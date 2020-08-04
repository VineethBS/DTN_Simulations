no = sqrt(10);

% % figure 1
% x = csvread('FB_QDCompare_RFIFOLIFO_B10_N250_K20_Beta05_Lambda_0568_167.csv', 1, 0);
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
% errorbar(arrival_rates, FIFO_Q, 2 * FIFO_Q_std, 'kv:', 'LineWidth', 3, 'MarkerSize', 8);
% errorbar(arrival_rates, R_Q, 2 * R_Q_std, 'ko:', 'LineWidth', 3, 'MarkerSize', 8);
% errorbar(arrival_rates, LIFO_Q, 2 * LIFO_Q_std, 'ks:', 'LineWidth', 3, 'MarkerSize', 8);
% xlabel('Arrival Rate - \lambda (packets/sec)');
% ylabel('Average queueing delay (secs)');
% legend('FIFO','Random','LIFO');
% grid on;

% figure 1
x = csvread('FB_QDCompare_RFIFOLIFO_B500_N50_K5_Beta0.1_Lambda1_3.csv', 1, 0);
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
legend('FIFO','Random','LIFO');
grid on;


