no = sqrt(10);

% % figure 1
% x = csvread('Qcompare_RFIFOLIFO_B1_N50_K5_Beta0.1_Rho01_09.csv', 1, 0);
% arrival_rates = x(:, 1);
% FIFO_D = x(:, 3);
% FIFO_D_std = x(:, 5)/no;
% R_D = x(:,7);
% R_D_std = x(:, 9)/no;
% LIFO_D = x(:, 11);
% LIFO_D_std = x(:, 13)/no;
% 
% figure(1);
% hold on;
% errorbar(arrival_rates, FIFO_D, FIFO_D_std, 'kv:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, R_D, R_D_std, 'ko:', 'LineWidth', 2, 'MarkerSize', 4);
% errorbar(arrival_rates, LIFO_D, LIFO_D_std, 'k*:', 'LineWidth', 2, 'MarkerSize', 4);
% xlabel('Arrival Rate - \lambda (packets/sec)');
% ylabel('Average delivery delay (secs)');
% legend('FIFO','Random','LIFO');
% grid on;


% figure 1
x = csvread('Qcompare_RFIFOLIFO_B10_N250_K20_Beta0.5_Rho01_098.csv', 1, 0);
arrival_rates = x(:, 1);
FIFO_D = x(:, 3);
FIFO_D_std = x(:, 5)/no;
R_D = x(:,7);
R_D_std = x(:, 9)/no;
LIFO_D = x(:, 11);
LIFO_D_std = x(:, 13)/no;

figure(1);
hold on;
errorbar(arrival_rates, FIFO_D, 2 * FIFO_D_std, 'kv:', 'LineWidth', 3, 'MarkerSize', 8);
errorbar(arrival_rates, R_D, 2 * R_D_std, 'ko:', 'LineWidth', 3, 'MarkerSize', 8);
errorbar(arrival_rates, LIFO_D, 2 * LIFO_D_std, 'ks:', 'LineWidth', 3, 'MarkerSize', 8);
xlabel('Arrival Rate - \lambda (packets/sec)');
ylabel('Average delivery delay (secs)');
legend('FIFO','Random','LIFO');
grid on;

% % figure 1
% x = csvread('Qcompare_RFIFOLIFO_B500_N50_K5_Beta0.1_Lambda01_098.csv', 1, 0);
% arrival_rates = x(:, 1);
% FIFO_D = x(:, 3);
% FIFO_D_std = x(:, 5)/no;
% R_D = x(:,7);
% R_D_std = x(:, 9)/no;
% LIFO_D = x(:, 11);
% LIFO_D_std = x(:, 13)/no;
% 
% figure(1);
% hold on;
% errorbar(arrival_rates, FIFO_D, 2 * FIFO_D_std, 'kv:', 'LineWidth', 3, 'MarkerSize', 8);
% errorbar(arrival_rates, R_D, 2 * R_D_std, 'ko:', 'LineWidth', 3, 'MarkerSize', 8);
% errorbar(arrival_rates, LIFO_D, 2 * LIFO_D_std, 'ks:', 'LineWidth', 3, 'MarkerSize', 8);
% xlabel('Arrival Rate - \lambda (packets/sec)');
% ylabel('Average delivery delay (secs)');
% legend('FIFO','Random','LIFO');
% grid on;


