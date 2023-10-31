function [returnedObs] = Sorting(Obs)
%SORT Summary of this function goes here
%   Detailed explanation goes here
% A = zeros(4,1);
% stored_obs = Obs
% 
% % Remove smallest sum row
% for row_idx = 1:length(Obs)
%     row_sum = sum(Obs(row_idx, :));
%     A(row_idx) = row_sum; 
% end
% [~, smallest_row_index] = min(A);
% Obs(smallest_row_index, :) = []
% 
% % Remove largest sum row
% for row_idx = 1:length(Obs)
%     row_sum = sum(Obs(row_idx, :));
%     A(row_idx) = row_sum; 
% end
% [~, largest_row_index] = max(A);
% Obs(largest_row_index, :) = []
% 
% % Compare remaining column values
% sortedObs = sort(Obs)
% C = stored_obs(smallest_row_index, :)
% D = stored_obs(largest_row_index, :)
% E = sortedObs(1, :)
% F = sortedObs(2, :)
% returnedObs = [C;D;E;F];

% Calculate the row sums
row_sums = sum(Obs, 2);
% Find the index of the row with the smallest sum
[~, smallest_row_index] = min(row_sums);
% Get the row with the smallest sum
smallest_row = Obs(smallest_row_index, :);

Obs(smallest_row_index, :) = [];

% Calculate the row sums
row_sums = sum(Obs, 2);
% Find the index of the row with the smallest sum
[~, largest_row_index] = max(row_sums);
% Get the row with the smallest sum
largest_row = Obs(largest_row_index, :);

Obs(largest_row_index, :) = [];

returnedObs = [smallest_row; Obs(1,:); Obs(2,:); largest_row];
end

