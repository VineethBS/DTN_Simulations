addpath partitions/

% The N and K for the DTN
N = 5;
K = 2;

% Total variables (m_{ij})
num_vars = (K + 1) * (K + 2)/2;
base_values = (N + 1).^((num_vars - 1):-1:0);
base_values = repmat(base_values, nx, 1);

code = @(x) (sum(x .* base_values, 2));

set_of_values = permn(0:N, num_vars);
sum_values = sum(set_of_values, 2);
set_of_values = set_of_values(sum_values == N, :);

nx = size(set_of_values, 1);
ny = size(set_of_values, 2);


scalar_code = sum(set_of_values .* base_values, 2);

tpm = zeros(nx, nx);

for i = 1:nx
    % Source meetings
    if set_of_values(i, 1) > 0
        rate = set_of_values(i, 1);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(1) = next_set_of_values(1) - 1;
        next_set_of_values(2) = next_set_of_values(2) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end
    if set_of_values(i, 2) > 0
        rate = set_of_values(i, 2);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(2) = next_set_of_values(2) - 1;
        next_set_of_values(3) = next_set_of_values(3) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end
    if set_of_values(i, 4) > 0
        rate = set_of_values(i, 4);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(4) = next_set_of_values(4) - 1;
        next_set_of_values(3) = next_set_of_values(3) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end
    % Destination meetings
    if set_of_values(i, 2) > 0
        rate = set_of_values(i, 2);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(2) = next_set_of_values(2) - 1;
        next_set_of_values(1) = next_set_of_values(1) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end
    if set_of_values(i, 3) > 0
        rate = set_of_values(i, 3);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(3) = next_set_of_values(3) - 1;
        next_set_of_values(2) = next_set_of_values(2) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end
    if set_of_values(i, 4) > 0
        rate = set_of_values(i, 4);
        next_set_of_values = set_of_values(i, :);
        next_set_of_values(4) = next_set_of_values(4) - 1;
        next_set_of_values(2) = next_set_of_values(2) + 1;
        next_scalar_code = code(next_set_of_values);
        next_index = find(scalar_code == next_scalar_code, 1, 'first');
        tpm(i, next_index) = tpm(i, next_index) + rate;
    end


