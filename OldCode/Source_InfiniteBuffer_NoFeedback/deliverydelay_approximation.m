function dd = deliverydelay_approximation(beta, N, K)

dd = 1/K/beta; % this is t(k) - the expected time to deliver when the number of relays holding copies is K

for j = (K - 1):-1:1
    dd = 1/N/beta + (N - j)/N * dd;
end


