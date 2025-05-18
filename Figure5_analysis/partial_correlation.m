%% Load ROIs
clearvars
clc

addpath(genpath('E:/FPP_files_and_codes/FPP_files/matlabGiftiCifti'));

Names = {'FPP1', 'FPP2', 'FPP3', 'FPP4','FPP5'};

data_L = zeros(32492,1);
data_R = zeros(32492,1);
for i=1:5
    Filename = ['E:\FPP_files_and_codes\FPP_files\FPPs_Uncombined\' Names{i} '.lh.func.gii']
    t = gifti(Filename);
    t = t.cdata;
    data_L = data_L + (t ~= 0)*i;
    
    Filename = ['E:\FPP_files_and_codes\FPP_files\FPPs_Uncombined\' Names{i} '.rh.func.gii'];
    t = gifti(Filename);
    t = t.cdata;
    data_R = data_R + (t ~= 0)*i;
end

mask = [data_L;data_R];
%% Load Data
load('E:\FPP_files_and_codes\FPP_files\Movie_watching_avg_data\notmean_left_Meanfile.mat');
load('E:\FPP_files_and_codes\FPP_files\Movie_watching_avg_data\notmean_right_Meanfile.mat');

data_movie = [Left_data;Right_data];

data_rois = zeros(4,3655);
for i=1:5
    data_rois(i,:) = mean(data_movie(mask == i,:),1);
end
%% New ROIs
meanFPP23 = mean(data_rois(2:3, :), 1);
meanFPP45 = mean(data_rois(4:5, :), 1);
newROIs = [
    data_rois(1, :);
    meanFPP23
    meanFPP45
];
%% Partial correlation
corr = [];
pval = [];
for i=1:(32492*2)
    col = data_movie(i,:);
    [corr1,pval1] = partialcorr(col', newROIs(1,:)', newROIs([2,3],:)');
    [corr2,pval2] = partialcorr(col', newROIs(2,:)', newROIs([1,3],:)');
    [corr3,pval3] = partialcorr(col', newROIs(3,:)', newROIs([1,2],:)');
    corr = [corr; [corr1 corr2 corr3]];
    pval = [pval; [pval1 pval2 pval3]];
end
%%
save('partial_corr_data.mat', 'corr', 'pval');
%%
corr(isnan(corr)) = 0;
pval(isnan(pval)) = 0;
significance = -1 * sign(corr) .* log(pval);




Filename = 'E:\FPP_files_and_codes\FPP_files\classic_place_patches\ROIs.L.func.gii';
t = gifti(Filename);
t.cdata = single(corr(1:32492,:));
save(t, 'E:\FPP_files_and_codes\FPP_files\partial_corr_FPPs\PartialCorr_1_23_45.L.func.gii');
t.cdata = single(significance(1:32492,:));
save(t, 'E:\FPP_files_and_codes\FPP_files\partial_corr_FPPs\sig_PartialCorr_1_23_45.L.func.gii');
Filename = 'E:\FPP_files_and_codes\FPP_files\classic_place_patches\ROIs.R.func.gii';
t = gifti(Filename);
t.cdata = single(corr(32493:64984,:));
save(t, 'E:\FPP_files_and_codes\FPP_files\partial_corr_FPPs\PartialCorr_1_23_45.R.func.gii');
t.cdata = single(significance(32493:64984,:));
save(t, 'E:\FPP_files_and_codes\FPP_files\partial_corr_FPPs\sig_PartialCorr_1_23_45.R.func.gii');
