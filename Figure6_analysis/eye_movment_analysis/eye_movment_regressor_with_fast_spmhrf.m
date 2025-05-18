clearvars
addpath(genpath('E:\FPP_files_and_codes\FPP_files\eye_movment_data\spm12'))

eye_movment_regressor = load('E:\FPP_files_and_codes\FPP_files\eye_movment_data\final162.mat').final162;
eye_movment_regressor = transpose(eye_movment_regressor);
%%
TR=1; % seconds
Ntp=3655;
t = (TR*[0:Ntp-1])';
h = fast_spmhrf(t);
a = zeros(Ntp,1); a(1) = 1;
X = toeplitz(h,a);
eye_movment_regressor_new = X*eye_movment_regressor;
save('E:\FPP_files_and_codes\FPP_files\eye_movment_data\eye_movment_regressor_fast_spmhrf.mat', 'eye_movment_regressor_new');
