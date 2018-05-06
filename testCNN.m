%This file is used with CNN4Chess.m. This function is used to test
%whether the neural network works.
imgDir  = dir(['ChessTrain\Testimg2']); % Go through files in that folder
total=32;
    
for i = 3:1:34         
    img = imread(['ChessTrain\Testimg2\' imgDir(i).name]); %read jpg
    DS = augmentedImageDatastore(imageSize, img, 'ColorPreprocessing', 'gray2rgb');
    imageFeatures = activations(net, DS, featureLayer, 'OutputAs', 'columns');
    realName=imgDir(i).name;
    realName(end-4:end)=[];
    fprintf("It should be "+realName);
    label = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')
end
%{
testImage = imread(fullfile(rootFolder, 'Testimg2', name));
DS = augmentedImageDatastore(imageSize, testImage, 'ColorPreprocessing', 'gray2rgb');
imageFeatures = activations(net, DS, featureLayer, 'OutputAs', 'columns');
label = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')
%}
