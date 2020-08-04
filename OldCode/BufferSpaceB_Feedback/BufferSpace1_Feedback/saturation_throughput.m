function st = saturation_throughput(N, beta, K)

P = obtainTPM(N, K);
[u, v] = eigs(P', 1);
pi = u(:, 1)/sum(u(:, 1)); 

reward = zeros(N + 1, 1);
for i = 1:(N + 1)
    if i == 1
        reward(i) = 0;
    else
        reward(i) = 1 * (i - 1)/N;
    end
end
reward = sum(reward .* pi);
st = reward * N * beta;
