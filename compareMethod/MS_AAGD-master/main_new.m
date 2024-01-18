close all
clc 
clear all

% 读取图像文件
img = imread('1.bmp');  % 替换成你图像的路径

% 如果图像是彩色的，先将其转换为灰度图像
if size(img, 3) == 3
    img = rgb2gray(img);
end

% 转换图像数据类型为double，以供处理
img = double(img);

% 设定最大和最小邻域大小的参数
lmax = [19, 19, 19, 19];  % 与最大邻域对应的窗口尺寸
lmin = [3, 5, 7, 9];      % 与最小邻域对应的窗口尺寸

% 调用 final_AAGD 函数处理图像
out = final_AAGD(img, lmax, lmin);

% 显示结果
imshow(out); % 或者使用 imshow 函数
% colormap('jet'); % 颜色映射使用热图
% title('AAGD处理结果');
% colorbar; % 显示颜色条