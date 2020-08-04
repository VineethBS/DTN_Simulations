function [qd, dq] = MkM1_approximation(lambda, beta, N, K)

rho = lambda * K / N / beta;
dq = rho * (K + 1) / 2 ./ (1 - rho);
qd = dq / K ./ lambda;
