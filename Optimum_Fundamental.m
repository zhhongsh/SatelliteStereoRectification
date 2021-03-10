% in the name of Allah
function [t1_best,t2_best,number_inliers]=Optimum_Fundamental(matchedPoints1,matchedPoints2,image1)
% this function is used to find best fundamental matrix from corresponding points
% this function implemented by Nurollah Tatar Email:
% n.tatar@ut.ac.ir University of Tehran, Tehran, Iran.
% method: projective fundamental matrix.
% If you use this code, please cite the following paper. 
% {Tatar, Nurollah, and Hossein Arefi. "Stereo rectification of ...
% pushbroom satellite images by robustly estimating the fundamental matrix." ...
% International Journal of Remote Sensing 40, no. 23 (2019): 8879-8898.}

%
[m,n,hy]=size(image1);
%
% dprojectivity_best=n*t1(1,3)+m*t1(2,3)+1;% scale from projectivity
% teta_best=atan(-t1_best(2,1)/t1_best(1,1));
for i=1:200
    [F,inliersIndex] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2);
    inliers1=matchedPoints1(inliersIndex,:);
    inliers2=matchedPoints2(inliersIndex,:);
    %
    [t1, t2] = estimateUncalibratedRectification(F,inliers1,inliers2,size(image1));
    tform1=projective2d(t1);
    tform2=projective2d(t2);
    out1=transformPointsForward(tform1,matchedPoints1);
    out2=transformPointsForward(tform2,matchedPoints2);
    idx=(abs(out2(:,2)-out1(:,2))<1);
    
    dprojectivity(i,1)=abs(n*t1(1,3)+m*t1(2,3)); % equation (15)
    teta1(i,1)=atand(-t1(2,1)/t1(1,1)); % equation (12)
    n_inlier(i,1)=sum(idx);
    t1_i{i,1}=t1;
    t2_i{i,1}=t2;
    %
    
end
%
% Remove outliers
idx0=(n_inlier>0.6*max(n_inlier));
teta2=teta1(idx0);
%==============================
% First constraint
% minimization of first derivative rotation angles
mt=mode(round(teta2/5)*5);% optimum angle. equation (13)
dteta=teta1-mt;% differencing all rotation angles from optimum angle. equation (14)
idx_teta=(abs(dteta)<5);% first constraint
%==============================
% Second constraint
% maximization of inliers
n_inlier2=n_inlier(idx_teta,:);% extract real inliers
max2=max(n_inlier2);
idx_inliers=(n_inlier>(0.8*max2));% second constraint
%-------------------------------
% Third constraint
% minimization of distortion of the projectivity
dprojectivity1_i=dprojectivity((idx_inliers+idx_teta)==2,:);
dp_best=min(dprojectivity1_i);% best distortion of the projectivity
idx_dp=(dprojectivity<(5*dp_best));
%======================
% winear tasked all
idx3=((idx_inliers+idx_teta+idx_dp)==3);
max2=max(n_inlier(idx3));
idx_optimum=(n_inlier==max2);% optimum by winear tasked all
%============================
idx=((idx_inliers+idx_teta+idx_dp+idx_optimum)==4);
for i=1:length(idx)
    if idx(i)==1
        t1_best=t1_i{i,1};
        t2_best=t2_i{i,1};
    end
end

number_inliers=max2;







