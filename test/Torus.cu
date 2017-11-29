#include "depend.h"
struct Torus
{
  int resx,resy,resz;
  int sizex,sizey,sizez;
  float dx,dy,dz;

  float* out;
};

struct Dim_info
{
  int d1,d2,d3;
};

__constant__ Torus torus;
__constant__ Dim_info dim_info;

__device__  __inline__  int 
index3d(int i, int j, int k)
{
  return (k + j*dim_info.d3 + i*dim_info.d3*dim_info.d2);
}

__global__ void Torus_Div (float* vx, float* vy, float* vz)
{

  float dx2 = torus.dx * torus.dx;
  float dy2 = torus.dy * torus.dy;
  float dz2 = torus.dz * torus.dz;

  for(int i=0; i<dim_info.d1; i++)
  {
    for(int j=0; j<dim_info.d2; j++)
    {
      for(int k=0; k<dim_info.d3; k++)
      {
        int ixm = (i - 1) % torus.resx;
        int iym = (j - 1) % torus.resy;
        int izm = (k - 1) % torus.resz;

        int normal_index = index3d(i,j,k);
        
        torus.out[normal_index] = 
          (vx[normal_index] - vx[index3d(ixm,j,k)])/dx2;
        torus.out[normal_index] +=
          (vy[normal_index] - vy[index3d(i,iym,k)])/dy2;
        torus.out[normal_index] +=
          (vz[normal_index] - vz[index3d(j,j,izm)])/dz2;

      }
    }
  }

}

