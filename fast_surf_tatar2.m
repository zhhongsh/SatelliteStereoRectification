% in the name of Allah
function [final_pts1,final_pts2]=fast_surf_tatar2(im1, im2, N_tileX, N_tileY)
% This function implemented by Nurollah Tatar Email: n.tatar@ut.ac.ir.
% this function is used to find conjugate image points
% inputs:
% im1 = first (or left) image(type: uint8 or 16)
%  im2 = second (or right) image(type: uint8 or 16)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%
% Note : the image's should be streo!!!!!!!!!!!!!
% Note2: the images should be have same size
%
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
% outputs:
% final_pts1 = they are   points of area covering in image 1
% final_pts2 = they are   points of area covering in image 2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<3
    N_tileX=3;
    N_tileY=3;
end
if nargin<4
    N_tileY=N_tileX;
end
[m1,n1,hy1]=size(im1);
[m2,n2,hy2]=size(im2);
if hy1==3
    im1=rgb2gray(im1);
end
if hy2==3
    im2=rgb2gray(im2);
end
%==
dx1=n1/N_tileX;
dy1=m1/N_tileY;
dx2=n2/N_tileX;
dy2=m2/N_tileY;
final_pts1=[];
final_pts2=[];
for i=1:N_tileY
    for j=1:N_tileX
        im1_1=im1(round((i-1)*dy1)+1:round(i*dy1), round((j-1)*dx1)+1:round(j*dx1));
        im2_2=im2(round((i-1)*dy2)+1:round(i*dy2), round((j-1)*dx2)+1:round(j*dx2));
        % extract conjugate points
        if size(im1_1,1)<10 || size(im1_1,2)<10 || size(im2_2,1)<10 || size(im2_2,2)<10
            continue
        end
        [pts11 pts22] =SURF_Tatar( Tatar_Uint8(im1_1), Tatar_Uint8(im2_2),2000);
        if size(pts11,1)>=1
            pts11(:,1)=pts11(:,1)+round((i-1)*dy1);
            pts11(:,2)=pts11(:,2)+round((j-1)*dx1);
            pts22(:,1)=pts22(:,1)+round((i-1)*dy2);
            pts22(:,2)=pts22(:,2)+round((j-1)*dx2);
        end
        final_pts1=[pts11;final_pts1];
        final_pts2=[pts22;final_pts2];
    end
end