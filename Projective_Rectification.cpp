//// in the name of Allah
//// This mex function implemented by Nurollah Tatar Ph.D. Student in Photogrammetry
//// at the University of Tehran, Iran. Email: n.tatar@ut.ac.ir
//// this function is used to rectify an image by projective transformation
//// date : 2019-16-10
#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "time.h"
#include <iostream>
#include <algorithm>

using namespace std;
//
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ){
	double *image = (double *)mxGetData(prhs[0]);
    const mwSize *size = mxGetDimensions(prhs[0]);
    int rows = size[0];
    int cols = size[1];
	
	double *H1 = (double *)mxGetData(prhs[1]);//// direct 2D homography
	double *H2 = (double *)mxGetData(prhs[2]);//// inverse 2D homography
	
	double *outputViewRef = (double *)mxGetData(prhs[3]);
	double X0 = outputViewRef[0];
	double Y0 = outputViewRef[1];
	double M1 = outputViewRef[2]+1;
	double N1 = outputViewRef[3]+1;
	//// double M1 = ceil( (H1[0]*cols + H1[1]*rows + H1[2])/(H1[6]*cols + H1[7]*rows + H1[8]) )+1;
	//// double N1 = ceil( (H1[3]*cols + H1[4]*rows + H1[5])/(H1[6]*cols + H1[7]*rows + H1[8]) )+1;
	
	int M = M1;
	int N = N1;
	
	plhs[0] = mxCreateNumericMatrix( M , N , mxDOUBLE_CLASS, mxREAL );	
	double *rectified_image = (double *)mxGetData(plhs[0]);
	
	//rectified_image[0] = M; rectified_image[1]= N;
	 register int i , j , d ;
	
	double ii, jj, dx, dy, no, so;
	int ii1, jj1, ii2, jj2;
	for (i=0;  i<M; i++)
		{
		for (j=0;  j<N; j++)
			{
			jj = (H2[0]*(j+X0) + H2[1]*(i+Y0) + H2[2]) / (H2[6]*(j+X0) + H2[7]*(i+Y0) + H2[8]);
			ii = (H2[3]*(j+X0) + H2[4]*(i+Y0) + H2[5]) / (H2[6]*(j+X0) + H2[7]*(i+Y0) + H2[8]);
			
			if (ii<0 || jj<0 || ii>(rows-1) || jj>(cols-1))
				rectified_image[i + j*M] = 0;
			else{
				
                //// resampling  bilinear
                ii1 = ceil(ii);
                ii2 = floor(ii);
                jj1 = ceil(jj);
                jj2 = floor(jj);
                //dx = jj-floor(jj);
                //dy = ii-floor(ii);
				dx = ceil(jj)-jj;//updated
                dy = ceil(ii)-ii;//updated
			    no = image[ii2 + rows*jj2]*dy + (1-dy)*image[ii1 + rows*jj2];
                so = image[ii2 + rows*jj1]*dy + (1-dy)*image[ii1 + rows*jj1];
				rectified_image[i + j*M] = floor(no*dx + so*(1-dx));
			}
		}
	} 
	
	void mexMakeMemoryPersistent(void *image);
	void mexMakeMemoryPersistent(void *rectified_image);
}