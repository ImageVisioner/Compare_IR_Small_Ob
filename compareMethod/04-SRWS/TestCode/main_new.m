clc;   
clear; 
close all;

% 定义输入输出路径
input_folder = 'images';
output_folder_target = 'result/target';
output_folder_background = 'result/background';

% 如果输出目录不存在，则创建它们
if ~exist(output_folder_target, 'dir')
    mkdir(output_folder_target);
end
if ~exist(output_folder_background, 'dir')
    mkdir(output_folder_background);
end

% 获取图像文件列表
image_files = dir(fullfile(input_folder, '*.bmp'));

% 初始化算法对象
alg = SRWS;

% 遍历图像文件进行处理
for i = 1:length(image_files)
    img_name = image_files(i).name;
    img_path = fullfile(input_folder, img_name);
    
    % 读取图像
    Img = imread(img_path);

    if ndims(Img) == 3
        Img = rgb2gray(Img);
    end
    Img = im2double(Img);
    
    % 处理图像
    alg = alg.process(Img);
    
    % 保存结果
    imwrite(alg.result, fullfile(output_folder_target, img_name));
    imwrite(alg.rstB, fullfile(output_folder_background, img_name));
    % 
    % % 显示原始图像和处理结果
    % figure;
    % subplot(131), imshow(Img), title('Original Image');
    % subplot(132), imshow(alg.result, []), title('result');
    % subplot(133), imshow(alg.rstB, []), title('Background');
    % 
    % %适当等待以显示图像
    % pause(1);
end
disp("done!")