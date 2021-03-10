% in the name of Allah
function [tform1_best,tform2_best,number_inliers]=Optimum_Morgan(matchedPoints1,matchedPoints2)
% this function is used to find best fundamental matrix from corresponding
% points
% this function implemented by Nurollah Tatar Email:
% n.tatar@ut.ac.ir University of Tehran, Tehran, Iran.
% method: affine fundamental matrix.
% If you use this code, please cite the following paper. 
% {Tatar, Nurollah, and Hossein Arefi. "Stereo rectification of ...
% pushbroom satellite images by robustly estimating the fundamental matrix." ...
% International Journal of Remote Sensing 40, no. 23 (2019): 8879-8898.}
%
for i = 1:1000
    idxs=randperm(length(matchedPoints1),4);
    pts1=matchedPoints1(idxs,:);
    pts2=matchedPoints2(idxs,:);
    [tform1,tform2,teta1(i,1)]=Morgan_Matrixes(pts1,pts2);
    Trans_pts1 = transformPointsForward(tform1, matchedPoints1);
    Trans_pts2 = transformPointsForward(tform2, matchedPoints2);
    %
    e1=(abs(Trans_pts1(:,2)-Trans_pts2(:,2))<1);
    n_inliers(i,1)=sum(e1);
    t1_i{i,1}=tform1;
    t2_i{i,1}=tform2;
       
end
idx=(n_inliers>0.6*max(n_inliers));
teta1=teta1(idx);
n_inliers=n_inliers(idx,:);
jj=0;
for i=1:length(idx)
    if idx(i)==1
        jj=jj+1;
        t11_i{jj,1}=t1_i{i,1};
        t22_i{jj,1}=t2_i{i,1};
    end
end
%
mt=mode(round(teta1/5)*5); % equation (13)
dteta=teta1-mt;  % equation (14)
idx=(abs(dteta)<5);
jj=0;
for i=1:length(idx)
    if idx(i)==1
        jj=jj+1;
        t3_i{jj,1}=t11_i{i,1};
        t4_i{jj,1}=t22_i{i,1};
    end
end
n_inliers=n_inliers(idx);
idx2=(n_inliers==max(n_inliers));
for i=1:length(idx2)
    if idx2(i)==1
        t1=t3_i{i,1};
        t2=t4_i{i,1};
    end
end
tform1_best=t1;
tform2_best=t2;
number_inliers=max(n_inliers);
% tform1=projective2d(t1_best);
% Epip_im1 = imwarp(image1,tform1); figure(); imshow(Epip_im1,[])