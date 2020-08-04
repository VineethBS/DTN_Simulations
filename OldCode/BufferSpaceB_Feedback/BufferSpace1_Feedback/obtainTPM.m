function P = obtainTPM(N, K)
% obtains the transition probability matrix of the embedded Markov chain

P = zeros(N + 1, N + 1);

for i = 1:(N + 1)
    if i < (N + 1)
        P(i, i + 1) = (N - (i - 1))/N; % since the total transition rate out of a state is N
    end
    % suppose i - 1 = l K + m
    m = mod((i - 1), K);
    l = floor((i - 1)/K);
    if (i - m) >= 1
        P(i, i - m) = m/N;
    end
    if (i - K) >= 1
        P(i, i - K) = l*K/N;
    end
end