function [st, distribution_batchsize] = stability_threshold(K, N, beta, buffer_sizes)
distribution_batchsize = zeros(1, K);
for k = 1:K-1
    temp = (N - 1):-1:(N - k + 1);
    distribution_batchsize(k) = prod(temp)/N^length(temp) * k/N;
end
temp = (N - 1):-1:(N - K + 1);
distribution_batchsize(K) = prod(temp)/N^length(temp);
EK = sum(distribution_batchsize .* (1:K));
st = N * beta / EK;
st = st * buffer_sizes ./ (buffer_sizes + 1);


    