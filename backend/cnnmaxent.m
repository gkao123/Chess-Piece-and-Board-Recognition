%clear;
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

% Load pretrained network
net = resnet50();


% Visualize the first section of the network.
%{
figure
plot(net)
title('First section of ResNet-50')
set(gca,'YLim',[150 170]);
%}
% Inspect the first layer
net.Layers(1);

% Inspect the last layer
net.Layers(end);

% Number of class names for ImageNet classification task
numel(net.Layers(end).ClassNames);


[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');

imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');

w1 = net.Layers(2).Weights;

% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5);

% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
%figure
%montage(w1)
%title('First convolutional layer weights')

%SURF Atttempt
%bag = bagOfFeatures(trainingSet)
%img = readimage(imds,1)
%featureVector = encode(bag,img)

featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;


%svmParams = templateSVM('Standardize', 1, 'KernelFunction', 'gaussian');
%classifier = fitcecoc(trainingFeatures, trainingLabels, ...
 %   'Learners', svmParams, 'Coding', 'onevsall', 'ObservationsIn', 'columns');

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.

linearParams= templateLinear('Learner', 'logistic')
    classifier = fitcecoc(trainingFeatures, trainingLabels, linearParams,'ClassNames', {'BP', 'WP','BR','WR','Empty','BB','BK','WK','WB','BQ','WQ','BKi','WKi'});

% Extract test features using the CNN
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.

confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

% Display the mean accuracy
mean(diag(confMat))
[r,c] = size(trainingFeatures);


newImage = imread(fullfile(rootFolder, 'BP', '20160529_234947.jpg'));

% Create augmentedImageDatastore to automatically resize the image when
% image features are extracted using activations.
ds = augmentedImageDatastore(imageSize, newImage, 'ColorPreprocessing', 'gray2rgb');

% Extract image features using the CNN
imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');

% Make a prediction using the classifier
label = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')