clc;
clear;
close all;

%==========================================================================
p = 0.6; % Change p here!
%==========================================================================

% Image directory
img_dir = './images/';
images = dir([img_dir '*.bmp']); % Get all .bmp images in the folder

% Create result directories if they do not exist
target_dir = './result/target/';
background_dir = './result/background/';

if ~exist(target_dir, 'dir')
    mkdir(target_dir);
end
if ~exist(background_dir, 'dir')
    mkdir(background_dir);
end

% Options initiation
len = 30;
step = 10;
lambda = 1 / len;

% Loop over all images
for ii = 1:length(images)
    img_path = [img_dir images(ii).name];
    Img = imread(img_path);
    if ndims(Img) == 3
        Img = rgb2gray(Img);
    end
    Img = im2double(Img);
    [m, n] = size(Img);

    % Construct image-patch
    patchImg = image2patch(Img, len, step);

    % Iterate solution
    [B, T, loss] = optimization(patchImg, lambda, p);

    % Reconstruct target image and background image
    rstT = patch2image(T, len, step, size(Img));
    rstB = patch2image(B, len, step, size(Img));

    % Save the result
    imwrite(rstT .* (rstT>0), [target_dir images(ii).name]);
    imwrite(rstB .* (rstB>0), [background_dir images(ii).name]);
    
    % Displaying progress
    fprintf('Processed image %d of %d: %s\n', ii, length(images), images(ii).name);
end

% Informing that the process is complete
disp('All images have been processed.');