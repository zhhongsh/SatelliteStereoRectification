% In the Name of Allah
function [im_uint8]=Tatar_Uint8(image, percentage)
%  This function implemented by Norallah Tatar Email: n.tatar@ut.ac.ir,
% University of Tehran, Iran. (or noorollah.tatar@gmail.com)
% This function is used to transform any type of image into uint8
% aboute inputs;
% image: original image
% percentage: how much of intensities in dual rank algorithm will be removed. 
% it is must be between 1~100. Defualt is  1%
% output:
% im_uint8: tranfered image
if nargin<2
    percentage=1;
end
p=percentage/100;
I1=double(image(:));
I1(I1==0)=[];
I2=dual_rank(I1,p);
max_I2=max(I2);
min_I2=min(I2);
%
im2=double(image);
im_uint8=uint8((im2-min_I2)/(max_I2-min_I2)*255);