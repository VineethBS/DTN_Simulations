addpath partitions/

% The N and K for the DTN
N = 2;
K = 2;

% Total variables (m_{ij})
num_vars = (K + 1) * (K + 2)/2;

% Generate solutions to \sum_ij m_{ij} = N
choices = partitions(N, 0:N, [], num_vars);
nx = size(choices, 1);
ny = size(choices, 2);

possible_permutations = perms(1:num_vars);
nxp = size(possible_permutations, 1);
nyp = size(possible_permutations, 2);

possible_variable_values = [];

for i = 1:nx
    variable_values = [];
    for j = 1:ny
        if choices(i, j) == 0
            continue
        end
        variable_values = [variable_values, (j - 1) * ones(1, choices(i, j))];
    end
    for k = 1:nxp
            possible_variable_values = [possible_variable_values; variable_values(possible_permutations(k, :))];
    end
end
        
% Apply the rules that we have obtained to remove some of the possibilities
nx = size(possible_variable_values, 1);
ny = size(possible_variable_values, 2);

linear_index =  @(i, j) (i * (i + 1)/2 + j + 1);

% Apply rules to eliminate states

% First constraint that no two m_{i0} can be positive
constraint_1_indices = [];
for j = 1:(K - 1)
    constraint_1_indices = [constraint_1_indices, linear_index(j, 0)];
end

constrained_variable_values = [];
code_variable_values = [];

for i = 1:nx
    constraint_check_values = possible_variable_values(i, :);
    constraint_check_values = constraint_check_values(constraint_1_indices);
    constraint_check_values = constraint_check_values > 0;
    if sum(constraint_check_values > 1)
        continue;
    end
    
    constrained_variable_values = [constrained_variable_values; possible_variable_values(i, :)];
end

