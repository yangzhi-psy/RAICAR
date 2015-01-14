#include <math.h> 
#include <stdlib.h> 
#include <stdio.h>
#include <float.h>
#include <string.h>
#include "mex.h" 
  
  
double sqr(double x) 
{ 
 return x*x; 
} 
  
struct prvek{ 
              double dat; 
              int ind; 
            }; 
  
struct prvekz{ 
              int x1,y1,x2,y2; 
              void set(int nx1,int ny1,int nx2,int ny2){ 
                        x1=nx1; x2=nx2; y1=ny1; y2=ny2;}; 
            }; 
  
struct zasobnik{ 
       int index; 
       prvekz data[100]; 
       zasobnik(){index=0;}; 
       void add(int x1, int y1, int x2, int y2) 
                   { data[++index].x1=x1; 
                     data[index].x2=x2; 
                     data[index].y1=y1; 
                     data[index].y2=y2;}; 
       void add(prvekz X){data[++index]=X;}; 
       void uber(){index--;}; 
       prvekz &aktiv(){return data[index];}; 
               }; 
  
int sort_function( const void *a, const void *b) 
{ 
 int k=-1; 
 prvek *A,*B; 
 A=(prvek*)a;B=(prvek*)b; 
 if (A->dat > B->dat) k=1; 
 if (A->dat == B->dat) k=0; 
 return k; 
} 
  
double MI1(double *X,double *Y,int Pocet)
{ 
 prvek *x=new prvek[Pocet]; 
 prvek *y=new prvek[Pocet]; 
 //prvek x[Pocet];prvek y[Pocet]; 
 int *xx=new int[Pocet]; 
 int *yy=new int[Pocet]; 
// int xx[Pocet];int yy[Pocet]; 
 for(int i=0;i<Pocet;i++) { 
                            x[i].dat=X[i]; 
                            x[i].ind=i; 
                            y[i].dat=Y[i]; 
                            y[i].ind=i; 
                          } 
 qsort((void *)x, Pocet, sizeof(prvek), sort_function); 
 qsort((void *)y, Pocet, sizeof(prvek), sort_function); 
 for(int i=0;i<Pocet;i++) { 
                           xx[x[i].ind]=i; 
                           yy[y[i].ind]=i; 
                        } 
 zasobnik marg; 
 prvekz amarg[4]; 
 int poc[100],kon[100]; 
 double m=0; 
 double tst; 
 int Nex,avex,avey; 
// int poradi[Pocet],apor[Pocet]; 
 int *poradi=new int[Pocet]; 
 int *apor=new int[Pocet]; 
 for(int i=0;i<Pocet;i++) poradi[i]=i; //indexy se pocitaji od nuly 
 int run=0; 
 int NN[4]={0,0,0,0}; 
 int apoc,akon; 
 int Nx,Ny; 
 poc[1]=0; 
 kon[1]=Pocet-1; 
 marg.add(0,0,Pocet-1,Pocet-1); 
 while (marg.index>0) 
 { 
  run++; 
  NN[0]=0;NN[1]=0;NN[2]=0;NN[3]=0; 
  apoc=poc[marg.index]; 
  akon=kon[marg.index]; 
  for(int i=apoc;i<=akon;i++) apor[i]=poradi[i]; 
  Nex=akon-apoc+1; 
  avex=(marg.aktiv().x1+marg.aktiv().x2)/2; 
  avey=(marg.aktiv().y1+marg.aktiv().y2)/2; 
  for (int i=apoc;i<=akon;i++) 
    { 
     if (xx[apor[i]]<=avex) if (yy[apor[i]]<=avey) NN[0]++;else NN[1]++; 
     else if (yy[apor[i]]<=avey) NN[2]++;else NN[3]++; 
    }//for  NN=sum(I) 
  amarg[0].set(marg.aktiv().x1, marg.aktiv().y1, avex, avey); 
  amarg[1].set(marg.aktiv().x1, avey+1, avex, marg.aktiv().y2); 
  amarg[2].set(avex+1, marg.aktiv().y1, marg.aktiv().x2, avey); 
  amarg[3].set(avex+1, avey+1, marg.aktiv().x2, marg.aktiv().y2); 
  tst=(double)4*(sqr(NN[0]-(double)Nex/4)+sqr(NN[1]-(double)Nex/4) 
                +sqr(NN[2]-(double)Nex/4)+sqr(NN[3]-(double)Nex/4))/Nex; 
  if ((tst>7.8)||(run==1)) 
    { 
     marg.uber(); 
     int ap=apoc, ak=akon; 
     for(int k=0;k<4;k++) 
       { 
        if (NN[k]>2){ 
                     marg.add(amarg[k]); 
                     akon=apoc+NN[k]-1; 
                     poc[marg.index]=apoc; 
                     kon[marg.index]=akon; 
                     int j=apoc; 
                     switch (k) { 
                       case 0:for(int i=ap;i<=ak;i++) 
                               if ((xx[apor[i]]<=avex)&&(yy[apor[i]]<=avey)) 
                                              poradi[j++]=apor[i]; 
                              break; 
                       case 1:for(int i=ap;i<=ak;i++) 
                               if ((xx[apor[i]]<=avex)&&(yy[apor[i]]>avey)) 
                                              poradi[j++]=apor[i]; 
                              break; 
                       case 2:for(int i=ap;i<=ak;i++) 
                               if ((xx[apor[i]]>avex)&&(yy[apor[i]]<=avey)) 
                                              poradi[j++]=apor[i]; 
                              break; 
                       case 3:for(int i=ap;i<=ak;i++) 
                               if ((xx[apor[i]]>avex)&&(yy[apor[i]]>avey)) 
                                              poradi[j++]=apor[i]; 
                                };//switch 
                     apoc=akon+1; 
                    } 
        else        { 
                     if (NN[k]>0) { 
                        Nx=amarg[k].x2-amarg[k].x1+1; 
                        Ny=amarg[k].y2-amarg[k].y1+1; 
                        m+=(double)NN[k]*log((double)NN[k]/(Nx*Ny)); 
                                  }//if 
                    } //else 
       }//for 
    } //if test 
   else 
   { 
    Nx=marg.aktiv().x2-marg.aktiv().x1+1; 
    Ny=marg.aktiv().y2-marg.aktiv().y1+1; 
    m+=(double)Nex*log((double)Nex/(Nx*Ny)); 
    marg.uber(); 
   }//else test 
 } //while 
 delete []x; 
 delete []xx; 
 delete []y; 
 delete []yy; 
 delete []poradi; 
 delete []apor; 
 return m/Pocet+log(Pocet); 
} 
  
  
void mexFunction( 
                 int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[] 
   ) 
{ 
  double *yp; 
  double *prData,*Zdroj1,*Zdroj2,*vystup,*vystup2,*vec1,*vec2; 
  unsigned int rows,cols; 
  int i, j, k, p;
  int numRot, len1;
  double *st_d, *ct_d, angle, me; 
  double **mi, **varmi;
  

  /* Check for proper number of arguments */ 
	/*  
  if (nrhs != 3) { 
    mexErrMsgTxt("MI_rot requires three input arguments."); 
  } else if (nlhs != 2) { 
    mexErrMsgTxt("MI_rot requires two output argument."); 
  } 
	*/
  
  /* Check the dimensions of Y.  Y can be 4 X 1 or 1 X 4. */ 
  rows = mxGetM(prhs[0]); 
  cols = mxGetN(prhs[0]); 
	/*
  if (!mxIsNumeric(prhs[0]) || mxIsComplex(prhs[0]) || 
      mxIsSparse(prhs[0])  || !mxIsDouble(prhs[0]) || 
      (cols < 2)) { 
    mexErrMsgTxt("MI_rot requires the dimension of input is no less than 2."); 
  } 
	*/

  // get the number of rotations from input
  len1 = (int)(mxGetScalar(prhs[1]));
  numRot = (int)(mxGetScalar(prhs[2]));
  prData = mxGetPr(prhs[0]); 

	// output some information
  mexPrintf ("len1 = %d\n", len1);
  mexPrintf ("numRot = %d\n", numRot);
  mexPrintf ("rows = %d\n", rows);
  mexPrintf ("cols = %d\n", cols);
  
  /* Create a matrix scalar) for the return argument */ 
  plhs[0] = mxCreateDoubleMatrix(len1, cols-len1, mxREAL); 
  plhs[1] = mxCreateDoubleMatrix(len1, cols-len1, mxREAL); 
  vystup = mxGetPr(plhs[0]); 
  vystup2 = mxGetPr(plhs[1]);
  
  // allocate space
  vec1=new double[rows];
  vec2=new double[rows];

  mi=new double* [len1];
  varmi=new double* [len1];

  for (i=0;i<len1;i++) {
    mi[i]=new double[cols-len1];
    varmi[i]=new double[cols-len1];
  }

  Zdroj1=new double[rows];
  Zdroj2=new double[rows];

  st_d = new double[numRot-1];
  ct_d = new double[numRot-1];

  // pre-compute st_d and ct_d
  for (i=0;i<numRot-1;i++) {
	angle=1.0*(i+1)/numRot*M_PI/2;
	st_d[i]=sin(angle);ct_d[i]=cos(angle);
  }
  
  /* Assign pointers to the various parameters */ 
  for (i=0;i<len1;i++) {
    for (j=len1;j<cols;j++) {
      	//memcpy(vec1,prData+i*rows, rows*sizeof(double)); 
      	//memcpy(vec2,prData+j*rows, rows*sizeof(double)); 
			for (k=0;k<rows;k++) {
				vec1[k]=prData[i*rows+k];
				vec2[k]=prData[j*rows+k];
			}
      me=0;
 
      // rotations
      for (k=0;k<numRot;k++) {
				if (k>0) {
					for (p=0;p<rows;p++) {
	  				Zdroj1[p]=ct_d[k-1]*vec1[p]+st_d[k-1]*vec2[p];
	  				Zdroj2[p]=ct_d[k-1]*vec2[p]-st_d[k-1]*vec1[p];
					}
					me=me+MI1(Zdroj1,Zdroj2,rows);
				}
				else {
 					mi[i][j-len1]=MI1(vec1,vec2,rows); 
				}
			}
      varmi[i][j-len1]=me/(numRot-1);
		}
	}

  // output
  for (i=0;i<len1;i++) {
    for (j=0;j<cols-len1;j++) {
      vystup[j*len1+i] = mi[i][j];
      vystup2[j*len1+i] = varmi[i][j];
    }
  }
  mexPrintf ("output finished\n");
  for (i=0;i<len1;i++) {
    //mexPrintf("deleting %d\n", i);
    delete [] mi[i];
    delete [] varmi[i];
  }
  delete [] mi;
  delete [] varmi;
  delete [] vec1;
  delete [] vec2;
  delete [] Zdroj1;
  delete [] Zdroj2;
  return; 

}

 
    
