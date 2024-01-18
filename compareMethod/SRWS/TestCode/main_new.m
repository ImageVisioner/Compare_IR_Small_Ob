

clc;    clear; 
close all;

Img = imread('images\1.bmp');

if ndims(Img) == 3
    Img = rgb2gray(Img);
end
Img = im2double(Img);
figure,subplot(121),imshow(Img),title('Original Image');

alg = SRWS;
alg = alg.process(Img);
subplot(122),imshow(alg.result, []),title('result');

figure,
subplot(131),imshow(alg.rstB, []),title('Background');
subplot(132),imshow(alg.rstE, []),title('Noise');
subplot(133),imshow(alg.Z, []),title('Coefficient Matrix');