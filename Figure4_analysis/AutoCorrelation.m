clearvars
% Load left and right movie data
left_movie_data = load('E:/FPP_files_and_codes/FPP_files/Movie_watching_avg_data/notmean_left_Meanfile.mat', 'Left_data');
left_movie_data = left_movie_data.Left_data;
right_movie_data = load('E:/FPP_files_and_codes/FPP_files/Movie_watching_avg_data/notmean_right_Meanfile.mat', 'Right_data');
right_movie_data = right_movie_data.Right_data;

% Load FPPs data
FPPs_right = gifti('E:/FPP_files_and_codes/FPP_files/FPPs_combined/FPPs.rh.func.gii');
FPPs_right = FPPs_right.cdata';
FPPs_left = gifti('E:/FPP_files_and_codes/FPP_files/FPPs_combined/FPPs.lh.func.gii');
FPPs_left = FPPs_left.cdata';

% Find indices of nonzero elements for right and left FPPs
right_FPPs_indices = cell(1, 5);
left_FPPs_indices = cell(1, 5);
for i = 1:5
    right_FPPs_indices{i} = find(FPPs_right(i, :) ~= 0);
    left_FPPs_indices{i} = find(FPPs_left(i, :) ~= 0);
end

% Concatenate activity data from left and right movie data based on FPPs indices
activity_of_FPPs = cell(1, 5);
for i = 1:5
    activity_of_FPPs{i} = [right_movie_data(right_FPPs_indices{i}, :); left_movie_data(left_FPPs_indices{i}, :)];
end

% Calculate mean activity of FPPs
mean_FPPs_activity = zeros(5, size(activity_of_FPPs{1}, 2));
for i = 1:5
    mean_FPPs_activity(i, :) = mean(activity_of_FPPs{i}, 1);
end
%%
figure;
hold on;
plotHandles = gobjects(1, 5);

for i = 1:5
    [acf,lags] = autocorr(mean_FPPs_activity(i, :), NumLags=3654);  
    
    plotHandles(i) = plot(lags, acf);

end
legend(plotHandles, 'FPP1', 'FPP2', 'FPP3', 'FPP4', 'FPP5');

xlim([0 20]);

hold off;

