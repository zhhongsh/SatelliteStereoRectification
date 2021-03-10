function [best_pts1,best_pts2,a1_best,b1_best,a2_best,b2_best] = ransac_line2( pts1,pts2, n_pts,thr )
format long;
% disp('Performing RANSAC_LINE');
line1=pts1(:,2);
line2=pts2(:,2);
py=pts2(:,1)-pts1(:,1);
best_n_inliers = -1;
n_iters = 300;%2^n_pts*n_pts; % Iteration rule of thumb :)

% fprintf('RANSAC_LINE Progress (%i iterations): <*- 0%%',n_iters)
for i = 1:n_iters
    
    idxs=randperm(length(line1),n_pts);
       %=============================================
    L1=line1(idxs,:);
    L2=line2(idxs,:);
    PY1=py(idxs,:);
    % calculat parameters of line1
    A1=[L1,ones(n_pts,1)];
    B1=[PY1];
    X1=inv(A1'*A1)*A1'*B1;
    a=X1(1);
    b=X1(2);
    % calculat parameters of line2
    A2=[L2,ones(n_pts,1)];
    B2=[PY1];
    X2=inv(A2'*A2)*A2'*B2;
    a2=X2(1);
    b2=X2(2);
    %%%%=================================================
    % compute residual
    v=abs(a*line1+b-py);
    v2=abs(a2*line2+b2-py);
    % .. and count the amount of inliers
    e1=(v<=thr);
    e2=(v2<=thr);
    e=((e1+e2)==2);
    n_inliers=sum(e);
    % improvment check
    if n_inliers > best_n_inliers
        a1_best=a;
        b1_best=b;
        a2_best=a2;
        b2_best=b2;
        best_n_inliers = n_inliers;
        %
        best_pts1=pts1(e==1,:);
        best_pts2=pts2(e==1,:);
    end
end

end
