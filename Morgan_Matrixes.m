% In the name of Allah
function [tform1,tform2,teta1 , teta2]=Morgan_Matrixes(pts1,pts2)
% This function wrote by Nurollah Tatar Email: n.tatar@ut.ac.ir
% this function use to calculat and product epipolar resampling images of
% linear arrey image 
% inputs:
% im1&im2 = thay are original image which have overlapping area
% G1&G2&G3&G4 = thay are parameters in epipolar equation
%%%%% epipolar equation is   G1*x2+G2*x1+G3*y1+G4*y2=1 ==>  x1&y1 in pts1
%%%%%                                                     x2&y2 in pts2
%%%%% pts1 is points of image1 and pts2 is points of image2
% outputs:
% Epip_im1,Epip_im2 = thay are images which are epipolar  resampled
%==========================================================================
best_pts1=pts1;
best_pts2=pts2;
% [best_pts1,best_pts2] = ransac_morgan( pts1,pts2,4,1 );
x1=best_pts1(:,1);
y1=best_pts1(:,2);
x2=best_pts2(:,1);
y2=best_pts2(:,2);
%========================
A=[x1 y1 x2 y2 -1*ones(size(x1))];
[s v d]=svd(A);
G1=d(1,end)/d(end,end);
G2=d(2,end)/d(end,end);
G3=d(3,end)/d(end,end);
G4=d(4,end)/d(end,end);
%===========================================================
% V=G1*x1+G2*y1+G3*x2+G4*y2-1;
%=============================================================
teta1=atand(-G1/G2);  % equation (12)
teta2=atand(-G3/G4);
S=sqrt(-G4*cosd(teta1)/(G2*cosd(teta2)));
dy=-S*cosd(teta2)/G4;
%%%%%%%
H1=[cosd(teta1)/S sind(teta1)/S 0;-sind(teta1)/S cosd(teta1)/S -dy/2; 0 0 1];
H2=[cosd(teta2)*S sind(teta2)*S 0;-sind(teta2)*S cosd(teta2)*S dy/2; 0 0 1];
%%%%%%%%
tform1=affine2d(H1');
tform2=affine2d(H2');






