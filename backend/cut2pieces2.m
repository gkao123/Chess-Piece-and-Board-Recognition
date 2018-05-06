%This function is basically some for loops that can cut an image of
%checkerboard into a group of images of all those squares on that
%detectCheckerboardPoints.

function cut2pieces2(imgname)
    InImage=imread(imgname);
    pImg=rgb2gray(InImage);
    [pointCoor,Size]=detectCheckerboardPoints(pImg);
    [imgX,imgY]=size(pImg);
    figure(1); imshow(InImage);
    title('Select points that didnt get detected with right-to-left and up to-down sequences');
    hold on;
    plot(pointCoor(:,1),pointCoor(:,2),'ro');
    fprintf('Please select points that didnt get detected with right-to-left and up to-down sequences.\nPress enter to continue after you selected all.\n')
    xy=ginput;
    fprintf('Coordinates are recorded.\n');
    hold on;
    plot(xy(:,1),xy(:,2),'ro');
    close 1;
    pointCoor=[xy;pointCoor];
    x=pointCoor(:,1);
    y=pointCoor(:,2);
    [y1,index]=sort(y);
    y2=reshape(y1,[9,9]);
    index1=reshape(index,[9,9]);
    x1=x(index1);
    [x2,index2]=sort(x1);
    y3=zeros(9,9);
    for i=1:1:9
        temp1=index2(:,i);
        temp2=y2(:,i);
        y3(:,i)=temp2(temp1);
    end
    x3=reshape(x2,[81,1]);
    y4=reshape(y3,[81,1]);
    pointCoor2=[x3,y4];
    dy=diff(y3(1,:));
    dy=mean(dy);
for num=1:1:64
    temp1=fix(num/8);
    temp2=rem(num,8);
    if temp2==0
        fp=num+temp1-1;
    else
        fp=num+temp1;
    end
    P1=pointCoor2(fp,:);
    P1(1,2)=P1(1,2)-dy;
    P2=pointCoor2(fp+1,:);
    P2(1,2)=P2(1,2)-dy;
    P3=pointCoor2(fp+10,:);
    P4=pointCoor2(fp+9,:);
    
    maskX=[P1(1) P2(1) P3(1) P4(1)];
    maskY=[P1(2) P2(2) P3(2) P4(2)];
    mask=uint8(poly2mask(maskX,maskY,imgX,imgY));
    
    %result=InImage.*uint8(bw);
    croppedImage = uint8(zeros(size(pImg)));
    croppedImage = pImg.*uint8(mask);
    measurements = regionprops(croppedImage>0, 'BoundingBox');
    result= imcrop(croppedImage, measurements.BoundingBox);
    nameGen="Cut\"+"piece"+num+".png";
    
    name=char(nameGen);
    imwrite(result,name);
end
end
    
    
    