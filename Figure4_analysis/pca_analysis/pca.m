%%
clearvars
clc
close all

addpath(genpath('D:/place_ROIs_project/matlabGiftiCifti'))
addpath('E:/FPP_files_and_codes/FPP_codebase/Figure4_analysis/pca_analysis/altmany-export_fig-3.46.0.0')

gL = gifti('E:/FPP_files_and_codes/FPP_files/FPPs_combined/FPPs.lh.func.gii');
gL = gL.cdata;
gL = [gL;zeros(32492,5)];
gR = gifti('E:/FPP_files_and_codes/FPP_files/FPPs_combined/FPPs.rh.func.gii');
gR = gR.cdata;
gR = [zeros(32492,5);gR];


mask = zeros(32492*2,1);
for i=1:5
    mask(gL(:,i)==1)=i;
    mask(gR(:,i)==1)=i+5;
end

%%
Left = load('E:/FPP_files_and_codes/FPP_files/Movie_watching_avg_data/notmean_left_Meanfile.mat');
Left = Left.Left_data;

Right = load('E:/FPP_files_and_codes/FPP_files/Movie_watching_avg_data/notmean_right_Meanfile.mat');
Right = Right.Right_data;
%%
data = [Left; Right];
data = data(mask~=0,:);
mask = mask(mask~=0);
%%
% Exclude Rest + 10 Samples after
% Fix = [1:21+10 265:285+10 506:526+10 714:734+10 798:818+10 901:921 921+[1:21+10 247:267+10 526:546+10 795:815+10 898:918] ...
%        921+918+[1:21+10 201:221+10 406:426+10 630:650+10 792:812+10 895:915] 921+918+915+[1:21+10 253:273+10 503:523+10 778:798+10 881:901]];
% Times = ones(3655,1);
% Times(Fix) = 0;
% 
% data = data(:,Times==1);
%% PCA
[coeff,score,latent] = pca(data);
% gscatter3(score(:,1),score(:,2),score(:,3), mask)

%%
close all

figure;
hold on;
set(gcf,'Color',[1 1 1]);
set(gca,'FontName','arial','FontSize',12); % Check this
%colors = {'OrangeRed', 'Red', 'Lime', 'Cyan', 'MediumPurple', 'DarkOrange', 'DarkRed', 'Darkgreen', 'MediumBlue', 'Purple' }; 
colors = [
    252/255, 192/255, 45/255;   % OrangeRed
    217/255, 136/255, 128/255;    % Red
    102/255, 187/255, 106/255;  % Lime
    129/255, 212/255, 250/255;  % Cyan
    206/255, 147/255, 216/255;  % MediumPurple
    255/255, 111/255, 0/255;    % DarkOrange
    183/255, 28/255, 28/255;    % DarkRed
    46/255, 125/255, 50/255;    % Darkgreen
    21/255, 101/255, 192/255;   % MediumBlue
    106/255, 27/255, 154/255    % Purple
];
% Convert color names to RGB triplets

% Plot the scatter plot with the specified colors
g = gscatter(score(:,1), score(:,2), mask, colors);
desiredOrder = [1, 6, 2, 7, 3, 8, 4, 9, 5, 10]; % Change this to the desired order

% Reorder legend entries
legendEntries = {'FPP1 LH', 'FPP2 LH', 'FPP3 LH', 'FPP4 LH', 'FPP5 LH', 'FPP1 RH', 'FPP2 RH', 'FPP3 RH', 'FPP4 RH', 'FPP5 RH'};
legend(g(desiredOrder), legendEntries(desiredOrder), 'Location', 'eastoutside', 'FontSize', 12);


axis square;
box off;
legend box off;
xlabel('PC1');
ylabel('PC2');



export_fig('E:\FPP_files_and_codes\Figures\Figure4_files\Row2\pca_plot.png', '-png', '-r600');
%%%%%%%