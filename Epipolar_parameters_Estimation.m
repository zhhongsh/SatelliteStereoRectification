% Bismillah
function [tform1, tform2, outputViewRef, inliers_pts, epip_par, scale1, bmpts3, bmpts4]=Epipolar_parameters_Estimation(image1, image2, pts11, pts22, method)
	
	matchedPoints1 = pts11(:,[2,1]);
	matchedPoints2 = pts22(:,[2,1]);
	
	if nargin <4
		method = 'projective';
	end
	
	switch method
		case 'projective'
			[t1,t2] = Optimum_Fundamental(matchedPoints1,matchedPoints2,image1);tform1 = projective2d(t1);tform2 = projective2d(t2);
		case 'affine'
			[tform1, tform2] = Optimum_Morgan(matchedPoints1 , matchedPoints2); % Estimate epipolar geometry by robust affine funadamental matrix
	end

	% transform all tie points in epipolar space to identify inliers and outliers
	out1 = transformPointsForward(tform1, matchedPoints1);% transform left points
	out2 = transformPointsForward(tform2, matchedPoints2);% transform right points
	idx = (abs(out2(:,2)-out1(:,2))<1);% thresholding on vertical disparities to identify inliers and outliers
	bmpts1 = matchedPoints1(idx,:);% left inliers
	bmpts2 = matchedPoints2(idx,:);% right inliers
    bmpts3 = bmpts1;% left inliers in original coordinate system
	bmpts4 = bmpts2;% right inliersin original coordinate system
	% Compute the transformed location of image corners.
	outPts = zeros(8, 2);
	numRows = size(image1, 1);
	numCols = size(image1, 2);
	inPts = [1, 1; 1, numRows; numCols, numRows; numCols, 1];
	outPts(1:4,1:2) = transformPointsForward(tform1, inPts);
	numRows = size(image2, 1);
	numCols = size(image2, 2);
	inPts = [1, 1; 1, numRows; numCols, numRows; numCols, 1];
	outPts(5:8,1:2) = transformPointsForward(tform2, inPts);

	xSort   = sort(outPts(:,1));
	ySort   = sort(outPts(:,2));
	xLim = zeros(1, 2);
	yLim = zeros(1, 2);
	% xLim(1) = ceil(xSort(4)) - 0.5;
	% xLim(2) = floor(xSort(5)) + 0.5;
	% yLim(1) = ceil(ySort(4)) - 0.5;
	% yLim(2) = floor(ySort(5)) + 0.5;
	xLim(1) = ceil(xSort(1)) - 0.5;
	xLim(2) = floor(xSort(8)) + 0.5;
	yLim(1) = ceil(ySort(1)) - 0.5;
	yLim(2) = floor(ySort(8)) + 0.5;
	width   = xLim(2) - xLim(1) - 1;
	height  = yLim(2) - yLim(1) - 1;
	outputViewRef = imref2d([height, width], xLim, yLim);
	%
    bmpts1 = transformPointsForward(tform1, bmpts1);% transform left points
	bmpts2 = transformPointsForward(tform2, bmpts2);% transform right points
	bmpts1(:,1) = bmpts1(:,1) - xLim(1); bmpts1(:,2) = bmpts1(:,2) - yLim(1);
	bmpts2(:,1) = bmpts2(:,1) - xLim(1); bmpts2(:,2) = bmpts2(:,2) - yLim(1);
	inliers_pts = [bmpts1, bmpts2];% all inliers
	%=================================================
	teta=0;
	epip_par{1,1}=tform1;
	epip_par{1,2}=tform2;
	epip_par{1,3}=outputViewRef;
	epip_par{1,4}=teta;
	N1=size(image1,2);
	N2=size(image2,2);
	epip_par{1,5}=N1;
	epip_par{1,6}=N2;
	epip_par{1,7}=0;
	epip_par{1,8}=0;
	epip_par{1,9}=0;
	epip_par{1,10}=0;
	%===================================================
	scale1=sqrt(width^2+height^2)/sqrt(numRows^2+numCols^2);
end