function [inliers,outliers]=dual_rank(win1,percentage)
% This function wrote and developted by Norallah Tatar Email:
% n.tatar@ut.ac.ir, University of Tehran, Iran. (or noorollah.tatar@gmail.com)
% this function is used to extract best valid data of win1 by remove
% percentage of lower and higher data.
% about inputs:
% win1: it is the value of a window
% percentage: the percentage of data which will be removed. it's can be 0.1
% or 0.15
% about outputs:
% inliers: best data which don't have noise
% outliers: the noise of data
if nargin<2
    percentage=0.1;
end
[m,n]=size(win1);
L=m*n;
R=round(L*percentage);
S=sort(win1(:));
inliers=S(R+1:end-R-1);
outliers=[S(1:R);S(end-R:end)];

