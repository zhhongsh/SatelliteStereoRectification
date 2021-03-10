function [pts1,pts2]=SURF_Tatar(im1,im2,NumberofPoints)
% this function implemented by Nurollah Tatar Email:
% n.tatar@ut.ac.ir University of Tehran
% This function is used to detect and matched feature was extracted by
% SURF operator: SURF: "Speeded Up Robust Features" 2008
% About inputs:
%im1: the first image.
% im2: the second image. 
% NumberofPoints:the number of points which be strongest. Defult is 1000
% about outputs:
%pts1& pts2: are conjugate image points
%==========================================================================


points1 = detectSURFFeatures(Tatar_Uint8(im1));
points2 = detectSURFFeatures(Tatar_Uint8(im2));
if min(size(points1,1),size(points2,1))>0
    
    if nargin<3
        NumberofPoints1=size(points1,1);
    else
        NumberofPoints1=NumberofPoints;
        if NumberofPoints>size(points1,1)
            NumberofPoints1=size(points1,1);
        end
    end
    strongest1 = points1.selectStrongest(NumberofPoints1);
    pts11=strongest1.Location;
    [features1,validPoints1] = extractFeatures(im1,pts11);
    % image points of im1
    
    if nargin<3
        NumberofPoints2=size(points2,1);
    else
        
        NumberofPoints2=NumberofPoints;
        if NumberofPoints>size(points2,1)
            NumberofPoints2=size(points2,1);
        end
    end
    strongest2 = points2.selectStrongest(NumberofPoints2);
    pts22=strongest2.Location;
    [features2,validPoints2] = extractFeatures(im2,pts22);
    %%%%%%%%%%%%
    % match features
    indexPairs = matchFeatures(features1, features2);
    matchedPoints1 = validPoints1(indexPairs(:, 1),:);
    matchedPoints2 = validPoints2(indexPairs(:, 2),:);
    %%%%%%%%
    pts1=double([matchedPoints1(:,2),matchedPoints1(:,1)]);
    pts2=double([matchedPoints2(:,2),matchedPoints2(:,1)]);
else
    pts1=[];
    pts2=[];
end