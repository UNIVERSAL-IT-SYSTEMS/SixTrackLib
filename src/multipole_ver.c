#include "hmacro.h"
#include <math.h>
#include <stdio.h>

#define ver_approx_ho_TYPE                                      28
#define purever_approx_TYPE                                     29
#define multipole_ver_float_L                                   0
#define multipole_ver_float_TiltComponentCos                    1
#define multipole_ver_float_TiltComponentSin                    2
#define multipole_ver_float_CurrentEntryDisplacementX           3
#define multipole_ver_float_CurrentEntryDisplacementY           4
#define multipole_ver_float_VerticalBendingKick                 5
#define multipole_ver_int_ApproxType                            0

inline void multipole_ver_nzapprox_calc(INT pfstart, FLOAT x, FLOAT y, FLOAT px, FLOAT py, FLOAT RatioPtoPj, FLOAT ds, FLOAT RatioDeltaPtoPj1, FLOAT RatioBetaToBetaj, FLOAT L, FLOAT TiltComponentCos, FLOAT TiltComponentSin, FLOAT CurrentEntryDisplacementX, FLOAT CurrentEntryDisplacementY, FLOAT VerticalBendingKick, FLOAT coordf[]){
      FLOAT xlvj, zlvj;
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;
      px = ( px + ((( L * zlvj ) * RatioPtoPj - RatioDeltaPtoPj1 ) * VerticalBendingKick ) * TiltComponentSin ) + (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * TiltComponentSin;
      py = ( py - ((( L * zlvj ) * RatioPtoPj - RatioDeltaPtoPj1 ) * VerticalBendingKick ) * TiltComponentCos ) - (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos);
      ds = ds - ( RatioBetaToBetaj * VerticalBendingKick ) * zlvj;

      SETCOORDF(coordf,px,px);
      SETCOORDF(coordf,py,py);
      SETCOORDF(coordf,ds,ds);
}

inline void multipole_ver_zapprox_calc(INT pfstart, FLOAT x, FLOAT y, FLOAT px, FLOAT py, FLOAT RatioPtoPj, FLOAT ds, FLOAT RatioDeltaPtoPj1, FLOAT RatioBetaToBetaj, FLOAT L, FLOAT TiltComponentCos, FLOAT TiltComponentSin, FLOAT CurrentEntryDisplacementX, FLOAT CurrentEntryDisplacementY, FLOAT VerticalBendingKick, FLOAT coordf[]){
      FLOAT xlvj, zlvj;
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;
      px = ( px - L * TiltComponentSin * RatioDeltaPtoPj1 ) + (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * TiltComponentSin;
      py = ( py + L * TiltComponentCos * RatioDeltaPtoPj1 ) - (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos);
      ds = ds - ( RatioBetaToBetaj * VerticalBendingKick ) * zlvj;

      SETCOORDF(coordf,px,px);
      SETCOORDF(coordf,py,py);
      SETCOORDF(coordf,ds,ds);
}

#define make_map_multipole_ver_approx(NAME)                                                                                                                                                                                                                     \
      INT multipole_##NAME##_map(INT elemi[], FLOAT elemf[], INT elemid, INT parti[], FLOAT partf[], INT partid, INT partn){                                                                                                                                    \
            INT cntmulverz##NAME = 0;                                                                                                                                                                                                                           \
            FLOAT RatioPtoPj, RatioDeltaPtoPj1, RatioBetaToBetaj, MomentumOfParticle, EnergyOfParticle;                                                                                                                                                         \
            ELEMINIT;                                                                                                                                                                                                                                           \
            INITPARTF;                                                                                                                                                                                                                                          \
            GETCOORDF(partf,x);                                                                                                                                                                                                                                 \
            GETCOORDF(partf,y);                                                                                                                                                                                                                                 \
            GETCOORDF(partf,px);                                                                                                                                                                                                                                \
            GETCOORDF(partf,py);                                                                                                                                                                                                                                \
            GETCOORDF(partf,ps);                                                                                                                                                                                                                                \
            GETCOORDF(partf,ds);                                                                                                                                                                                                                                \
            GETCOORDF(partf,E0);                                                                                                                                                                                                                                \
            GETCOORDF(partf,m0);                                                                                                                                                                                                                                \
            GETCOORDF(partf,p0);                                                                                                                                                                                                                                \
                                                                                                                                                                                                                                                                \
            GETATTRF(multipole_ver,L);                                                                                                                                                                                                                          \
            GETATTRF(multipole_ver,TiltComponentCos);                                                                                                                                                                                                           \
            GETATTRF(multipole_ver,TiltComponentSin);                                                                                                                                                                                                           \
            GETATTRF(multipole_ver,CurrentEntryDisplacementX);                                                                                                                                                                                                  \
            GETATTRF(multipole_ver,CurrentEntryDisplacementY);                                                                                                                                                                                                  \
            GETATTRF(multipole_ver,VerticalBendingKick);                                                                                                                                                                                                        \
            GETATTRI(multipole_ver,ApproxType);                                                                                                                                                                                                                 \
                                                                                                                                                                                                                                                                \
            RatioPtoPj = One / ( One + ps );                                                                                                                                                                                                                    \
            RatioDeltaPtoPj1 = ( ps * OnePoweredTo3 ) * RatioPtoPj;                                                                                                                                                                                             \
            MomentumOfParticle = p0 * ( One + ps );                                                                                                                                                                                                             \
            EnergyOfParticle = sqrt( MomentumOfParticle * MomentumOfParticle + m0 * m0 );                                                                                                                                                                       \
            RatioBetaToBetaj = ( EnergyOfParticle * p0 ) / ( E0 * MomentumOfParticle );                                                                                                                                                                         \
                                                                                                                                                                                                                                                                \
            switch(ApproxType){                                                                                                                                                                                                                                 \
                  case 0: multipole_ver_zapprox_calc(pfstart,x,y,px,py,RatioPtoPj,ds,RatioDeltaPtoPj1,RatioBetaToBetaj,L,TiltComponentCos,TiltComponentSin,CurrentEntryDisplacementX,CurrentEntryDisplacementY,VerticalBendingKick,partf);      \
                          if( cntmulverz##NAME++ == 0 ) printf("mulipole vericle Zero approx "#NAME" called \n");                                                                                                                                               \
                          break;                                                                                                                                                                                                                                \
                  case 1: multipole_ver_nzapprox_calc(pfstart,x,y,px,py,RatioPtoPj,ds,RatioDeltaPtoPj1,RatioBetaToBetaj,L,TiltComponentCos,TiltComponentSin,CurrentEntryDisplacementX,CurrentEntryDisplacementY,VerticalBendingKick,partf);     \
                          if( cntmulverz##NAME++ == 0 ) printf("mulipole vericle non-Zero approx "#NAME" called \n");                                                                                                                                           \
                          break;                                                                                                                                                                                                                                \
            }                                                                                                                                                                                                                                                   \
                                                                                                                                                                                                                                                                \
            return 1;                                                                                                                                                                                                                                           \
}                                                                                                                                                                                                                                                               \

make_map_multipole_ver_approx(ver_approx_ho);
make_map_multipole_ver_approx(purever_approx);