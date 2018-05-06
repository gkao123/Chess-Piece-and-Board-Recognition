clear;
close all;
clc;
InImg=imread('i3.jpg');
figure;
imshow(InImg);

PImg=rgb2gray(InImg);
figure;
imshow(PImg);
pImg=histeq(PImg);
figure;
imshow(pImg);

[r,c]=detectCheckerboardPoints(pImg);
figure;
%subplot(2,2,1);
imshow(InImg);
hold on;
plot(r(:,1),r(:,2),'ro');
