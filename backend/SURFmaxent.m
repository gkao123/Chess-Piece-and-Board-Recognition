clear;
close all;
clc;
%This is the adress for trainning set
rootFolder = fullfile('c:\','Users','hurui','Desktop','CS177a','Project','ChessTrain');
%Catagories and filenames for each image subset
categories = {'BP', 'WP','BR','WR','Empty','BB','BK','WK','WB','BQ','WQ','BKi','WKi'};

               
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
%
tbl = countEachLabel(imds)
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
countEachLabel(imds)
wp = find(imds.Labels == 'WP', 1);
bp = find(imds.Labels == 'BP', 1);
wr=find(imds.Labels=='WR',1);
br=find(imds.Labels=='BR',1);
empty=find(imds.Labels=='Empty',1);
bk=find(imds.Labels=='BK',1);
wk=find(imds.Labels=='WK',1);
bq=find(imds.Labels=='BQ',1);
wq=find(imds.Labels=='WQ',1);
bki=find(imds.Labels=='BKi',1);
wki=find(imds.Labels=='WKi',1);
bb=find(imds.Labels=='BB',1);
wb=find(imds.Labels=='WB',1);

%{
figure
subplot(1,2,1);
imshow(readimage(imds,wp))
subplot(1,2,2);
imshow(readimage(imds,bp))
%}


% Visualize the first section of the network.
%{
figure
plot(net)
title('First section of ResNet-50')
set(gca,'YLim',[150 170]);
%}


[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');

bag = bagOfFeatures(trainingSet)
featureVector = encode(bag, trainingSet)

%linear svm
linearSVMClassifier = trainImageCategoryClassifier(trainingSet,  bag)


confmatrix = evaluate(linearSVMClassifier, testSet)
% find average accuracy
mean(diag(confmatrix))
%[r,c] = size(trainingFeatures)
%img = imread()
%[labelIDx, score] = predict(categoryClassifier, img)
%categroyClassifier.Labels(labelIdx)



