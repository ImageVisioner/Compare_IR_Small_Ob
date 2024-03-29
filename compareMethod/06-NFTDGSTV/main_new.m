%% 基于WSNM的RNIPT算法
tic
clc;
clear;
close all;
%% setup parameters
lambdaL =4;%
C=5;%5
L1=3;%L4 L
mkdir results

imgpath='C:\Users\ImageVisioner\Desktop\DeeplearningImageFusion_code_ver240123\small_result\sirst_aug\sirst_aug\test\images\';        % Data input path
saveDir= '.\results\1\';     % Save path
saveTargetDir = [saveDir 'target\'];  % Target images save path
saveBackgroundDir = [saveDir 'background\'];  % Background images save path

% Create directories to save target and background images
if ~exist(saveTargetDir, 'dir')
    mkdir(saveTargetDir);
end
if ~exist(saveBackgroundDir, 'dir')
    mkdir(saveBackgroundDir);
end

imgDir = dir([imgpath '*.png']);
len = length(imgDir);
for i = 1:len
    picname = [imgpath imgDir(i).name];
    I = imread(picname);%
    [m, n] = size(I);
    [~, ~, ch] = size(I);
    if ch == 3
        I = rgb2gray(I); 
    end
    D(:, :, i) = I;
end
tenD = double(D);
[n1, n2, n3] = size(tenD);
n_1 = max(n1, n2);%n(1)
n_2 = min(n1, n2);%n(2)
patch_frames = L1;% temporal slide parameter
patch_num = n3 / patch_frames;
%% constrcut image tensor
for l = 1:patch_num
  
    for p = 1:patch_frames
        temp(:,:,p) = tenD(:,:,patch_frames * (l - 1) + p);
    end           
    T = C * sqrt(n1 * n2);
    lambda4 = lambdaL / sqrt(min(n_1 * patch_frames));
    %% The proposed NFTDGSTV model
    [tenB, tenT, change] = NFTDGSTV(temp, lambda4); 
    %% recover the target and background image       
    for p = 1:patch_frames
        tarImg = tenT(:,:,p);
        backImg = tenB(:,:,p);
        maxv = max(max(double(I)));
        tarImg = double(tarImg);
        backImg = double(backImg);
        E = uint8(mat2gray(tarImg) * maxv);
        A = uint8(mat2gray(backImg) * maxv);
        %% save the results
        imwrite(E, [saveTargetDir imgDir(p + patch_frames * (l - 1)).name]);     % Save target image 
        imwrite(A, [saveBackgroundDir imgDir(p + patch_frames * (l - 1)).name]); % Save background image
    end 
end
toc  