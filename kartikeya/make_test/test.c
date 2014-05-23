#include<stdio.h>

#define yv(i,j) yv[j-1][i-1]
#define stracks(i) stracks[i-1]
#define strackc(i) strackc[i-1]
#define oidpsv(j) oidpsv[j-1]

extern struct
{
int npart,i,j,nblz;
}exact_;

extern struct
{
double *stracks,*strackc;
}main4_;

extern struct
{
double *oidpsv;
}main2_;

extern struct
{
double **yv;
}main1_;

extern struct
{
int napx;
}tra1_;



extern void track_vert_dipole_()
{
int k=1;
for(k = 1; k <= tra1_.napx; ++k)
{
main1_.yv(1,exact_.j)=main1_.yv(1,exact_.j)-main4_.stracks(exact_.i)* main2_.oidpsv(exact_.j);
main1_.yv(2,exact_.j)=main1_.yv(2,exact_.j)+main4_.strackc(exact_.i)* main2_.oidpsv(exact_.j);
}
}
