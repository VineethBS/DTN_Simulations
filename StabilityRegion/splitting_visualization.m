B = 50;
K = 2;
alpha = 0:0.01:1;

arrival_rate = B/(B + 1)/(K + 1) * ones(numel(alpha), 1);

figure(1);
hold on;
plot(alpha,arrival_rate, 'r');

for b = 1:(B - 1)
    plot(alpha, b/(b + 1) * (1 - alpha), 'b');
    plot(alpha, (B - b)/(B - b + 1) * alpha/K, 'g');
end