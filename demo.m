% Bismillah
% date: 07-07-2020
% Satellite Stereo  rectification code.
% These codes are allowed to use only for research purposes, and we don't provide any warranty.
% Be aware we share Matlab code of this paper in private. 

% If you use this code, please cite the following paper. 
% {Tatar, Nurollah, and Hossein Arefi. "Stereo rectification of ...
% pushbroom satellite images by robustly estimating the fundamental matrix." ...
% International Journal of Remote Sensing 40, no. 23 (2019): 8879-8898.}

% note; the input images should be divided into tiles befor. this code os
% suitable for stereo tiles!

clc;
clear;


% get file information by selecting them
[filename1, pathname1, filterindex1] = uigetfile({'*.tif','TIFF(*.tif)';'*.*','all data(*.*)'},'Open first image');
[filename2, pathname2, filterindex2] = uigetfile({'*.tif','TIFF(*.tif)';'*.*','all data(*.*)'},'Open second image');

image1 = imread([pathname1, filename1]);% load first epipolared image
image2 = imread([pathname2, filename2]);% load second epipolared image

i0 = 0; j0 = 0; ii0 = 0; jj0 = 0;


%====================================================================
% Step 1: Extract feature points
N_tileX = 3;% number of tiles in x axis
N_tileY = 3;% number of tiles in y axis
[pts11,pts22] = fast_surf_tatar2(image1, image2 , N_tileX, N_tileY);


%============================================================================
%  Step 2: epipolar geometry estimation
% projective fundamental matrix method
[tform1, tform2, outputViewRef, inliers_pts, epip_par, scale1, bmpts1, bmpts2] = Epipolar_parameters_Estimation(image1, image2, pts11, pts22, 'projective');

% Affine fundamental matrix method.
%[tform1, tform2, outputViewRef, inliers_pts, epip_par, scale1, bmpts1, bmpts2] = Epipolar_parameters_Estimation(image1, image2, pts11, pts22, 'affine');


%============================================================================
% Step 3: Epipolar resampling
a=[outputViewRef.XWorldLimits(1); outputViewRef.YWorldLimits(1); outputViewRef.ImageSize(1);outputViewRef.ImageSize(2)];
Epip_im1 = Projective_Rectification(double(image1), tform1.T, inv(tform1.T), a); % resampling first image along the epipolar geometry

% If mex fuction is not available, Use the following code for resampling.
% Epip_im1 = imwarp(image1, tform1, 'bilinear', 'OutputView', outputViewRef, 'FillValues', 0); % resampling first image along the epipolar geometry

Epip_im1 = uint16(Epip_im1);
%or 
%Epip_im1 = cast(Epip_im1,'like',image1);


Epip_im2 = Projective_Rectification(double(image2), tform2.T, inv(tform2.T), a);% resampling the scond image along the epipolar geometry

% If mex fuction is not available, Use the following code for resampling.
% Epip_im2 = imwarp(image2, tform2, 'bilinear', 'OutputView', outputViewRef, 'FillValues', 0); % resampling the second image along the epipolar geometry
Epip_im2 = uint16(Epip_im2);
%or 
%Epip_im2 = cast(Epip_im2,'like',image2);

% display
figure();
subplot(1,2,1); imshow(Epip_im1,[]); title('The firse epipolar image');
subplot(1,2,2); imshow(Epip_im2,[]); title('The Second epipolar image');



% stereo matching

% now the Epip_im1 and Epip_im2 could serve as inpute for stereo matching like SGM or ...
% for stereo matching you can use the disparity function in matlab

% [disparity_map]= disparity(Tatar_Uint8(Epip_im1),Tatar_Uint8(Epip_im2),'DisparityRange',[-64,64],'BlockSize',9);% an example of stereo matching code
% figure(); imshow(disparity_map,[-64, 64])

% figure(); imshowpair(Tatar_Uint8(Epip_im2),Tatar_Uint8(Epip_im1),'ColorChannels','red-cyan'); % code for generating stereo anaglyph

% Automatic evaluation

[pts1,pts2]=fast_surf_tatar2(Tatar_Uint8(Epip_im1),Tatar_Uint8(Epip_im2));

[bpts1,bpts2] = ransac_line2( pts1,pts2, 2,0.6);


py=bpts2(:,1)-bpts1(:,1);
%
py_max=max(abs(py));
py_mean=mean((py));
% compute density
stdx=std(bpts1(:,2));
stdy=std(bpts1(:,2));

%==============================================
A1=[bpts1(:,2),ones(size(bpts1,1),1)];
B1=[py];
X1=inv(A1'*A1)*A1'*B1;
a=X1(1);
b=X1(2);
    %
helpdlg({['max y parallax: ' num2str(py_max)]...
    ['Average of y parallax: ' num2str(py_mean)]...
    ['a parameter for y parallax linear function: ' num2str(a)]...
    ['b parameter for y parallax linear function: ' num2str(b)]},...
    'evaluation of rectified images');