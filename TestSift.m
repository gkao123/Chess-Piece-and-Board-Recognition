clear;
close all;
clc;
addpath('C:\Users\hurui\Desktop\CS177a\Project\ChessTrain\BR');
t1=imread('20160529_214840.pgm');
figure;
imshow(t1);
t2=imread('20160529_214822.pgm');
figure;
imshow(t2);
match('20160529_214840.pgm','20160529_214822.pgm')
