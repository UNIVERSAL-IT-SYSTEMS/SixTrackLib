#include<stdio.h>
#include<math.h>
#include"crlibm/crlibm.h"

#define OnePoweredToMinus38               1.0e-38
#define zero                              0.0
#define half                              0.5
#define One                               1.0
#define two                               2.0
#define three                             3.0
#define four                              4.0
#define OnePoweredTo1                     1.0e1
#define OnePoweredTo2                     1.0e2
#define OnePoweredTo3                     1.0e3
#define OnePoweredTo4                     1.0e4
#define OnePoweredTo5      	          1.0e5
#define OnePoweredTo6                     1.0e6
#define OnePoweredTo12                    1.0e12
#define OnePoweredTo13                    1.0e13
#define OnePoweredTo15                    1.0e15
#define OnePoweredTo16                    1.0e16

#define TwoPoweredTo3                     2.0e3
#define FourPoweredTo3                    4.0e3

#define OnePoweredToMinus1                1.0e-1
#define OnePoweredToMinus2                1.0e-2
#define OnePoweredToMinus3                1.0e-3
#define OnePoweredToMinus6                1.0e-6
#define OnePoweredToMinus7                1.0e-7
#define OnePoweredToMinus9                1.0e-9
#define OnePoweredToMinus10               1.0e-10
#define OnePoweredToMinus12               1.0e-12
#define OnePoweredToMinus13               1.0e-13
#define OnePoweredToMinus15               1.0e-15
#define OnePoweredToMinus18               1.0e-18
#define OnePoweredToMinus21               1.0e-21
#define OnePoweredToMinus24               1.0e-24
#define OnePoweredToMinus36               1.0e-36

#define SpeedOfLight_mps                  2.99792458e8
#define RestMastOfProton_MeV              938.271998e0 
#define ClassicalRadiusOfElectron_m       2.817940285e-15
#define RestMassofElectron_MeV            0.510998902e0 
#define Pi                                4.0*atan_rn(1.0)


double sign( double a, double b )
{
if(b >= 0) return abs(a);
else return -abs(a);
}


int cnthordipole = 0;     
extern int thin6d_map_horizontal_dipole_(double *coord, double *argf, double *argi) {
  double xp = coord[2],yp = coord[3];  
  double RatioPtoPj = coord[4]; 
 
  double PhysicalLengthOfBlock = argf[0];  
  double TiltComponentCos = argf[1], TiltComponentSin = argf[2];
                                                       
  coord[2] = xp + PhysicalLengthOfBlock * TiltComponentCos * RatioPtoPj;        
  coord[3] = yp + PhysicalLengthOfBlock * TiltComponentSin * RatioPtoPj;       
                                                                 
  if(cnthordipole++ ==0) printf("horizontal dipole called\n");   
          
  return 1;                              
}                                     

#define make_map_normal_pole(NAME,i)                                                                                       \
  int cntnorm##NAME = 0;                                                                                                   \
  extern int thin6d_map_normal_##NAME##_(double *coord, double *argf, double *argi) {                                      \
    double x = coord[0], y = coord[1];                                                                                     \
    double xp = coord[2],yp = coord[3];                                                                                    \
    double RatioPtoPj = coord[4];                                                                                          \
                                                                                                                           \
    double PhysicalLengthOfBlock = argf[0];                                                                                \
    double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                         \
    double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                       \
                                                                                                                           \
    double xlvj, zlvj;                                                                                                     \
    double crkve, cikve, crkveuk;                                                                                          \
    int k = 0;                                                                                                             \
                                                                                                                           \
    xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;	   \
    zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos + ( x - CurrentEntryDisplacementX ) * TiltComponentSin;	   \
    crkve = xlvj;                                                                                                          \
    cikve = zlvj;                                                                                                          \
    for( k = 0; k < i ;k++)                                                                                                \
    {                                                                                                                      \
      crkveuk = crkve * xlvj - cikve * zlvj;                                                                               \
      cikve = crkve * zlvj + cikve * xlvj;                                                                                 \
      crkve = crkveuk;                                                                                                     \
    }                                                                                                                      \
                                                                                                                           \
    coord[2] = xp + RatioPtoPj * ( PhysicalLengthOfBlock * TiltComponentCos * crkve + PhysicalLengthOfBlock * TiltComponentSin * cikve );                          \
    coord[3] = yp + RatioPtoPj * ( PhysicalLengthOfBlock * TiltComponentSin * crkve - PhysicalLengthOfBlock * TiltComponentCos * cikve );                          \
                                                                                                                           \
    if( cntnorm##NAME++ == 0 ) printf("normal "#NAME" called \n");                                                            \
    return 1;                                                                                                              \
  }

make_map_normal_pole( quadrupole, 0 );
make_map_normal_pole( sextupole, 1 );
make_map_normal_pole( octupole, 2 );
make_map_normal_pole( decapole, 3 );
make_map_normal_pole( dodecapole, 4 );
make_map_normal_pole( 14pole, 5 );
make_map_normal_pole( 16pole, 6 );
make_map_normal_pole( 18pole, 7 );
make_map_normal_pole( 20pole, 8 );


int cntverdip = 0;
extern int thin6d_map_vertical_dipole_(double *coord, double *argf, double *argi) {
  double xp = coord[2],yp = coord[3];
  double RatioPtoPj = coord[4];

  double PhysicalLengthOfBlock = argf[0];  
  double TiltComponentCos = argf[1], TiltComponentSin = argf[2];

  coord[2] = xp - PhysicalLengthOfBlock * TiltComponentSin * RatioPtoPj;
  coord[3] = yp + PhysicalLengthOfBlock * TiltComponentCos * RatioPtoPj;

  if(cntverdip++ ==0) printf("vertical dipole called\n");

  return 1;
}

#define make_map_skew_pole(NAME,i)                                                                                       \
  int cntskew##NAME = 0;                                                                                                   \
  extern int thin6d_map_skew_##NAME##_(double *coord, double *argf, double *argi) {                                      \
    double x = coord[0], y = coord[1];                                                                                     \
    double xp = coord[2],yp = coord[3];                                                                                    \
    double RatioPtoPj = coord[4];                                                                                          \
                                                                                                                           \
    double PhysicalLengthOfBlock = argf[0];                                                                                \
    double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                         \
    double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                       \
                                                                                                                           \
    double xlvj, zlvj;                                                                                                     \
    double crkve, cikve, crkveuk;                                                                                          \
    int k = 0;                                                                                                             \
                                                                                                                           \
    xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;	   \
    zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;	   \
    crkve = xlvj;                                                                                                          \
    cikve = zlvj;                                                                                                          \
    for( k = 0; k < i ;k++)                                                                                                \
    {                                                                                                                      \
      crkveuk = crkve * xlvj - cikve * zlvj;                                                                               \
      cikve = crkve * zlvj + cikve * xlvj;                                                                                 \
      crkve = crkveuk;                                                                                                     \
    }                                                                                                                      \
                                                                                                                           \
    coord[2] = xp + RatioPtoPj * ( PhysicalLengthOfBlock * TiltComponentCos * cikve - PhysicalLengthOfBlock * TiltComponentSin * crkve );                          \
    coord[3] = yp + RatioPtoPj * ( PhysicalLengthOfBlock * TiltComponentCos * crkve - PhysicalLengthOfBlock * TiltComponentSin * cikve );                          \
                                                                                                                           \
    if( cntskew##NAME++ == 0 ) printf("skew "#NAME" called \n");                                                            \
    return 1;                                                                                                              \
  }

make_map_skew_pole( quadrupole, 0 );
make_map_skew_pole( sextupole, 1 );
make_map_skew_pole( octupole, 2 );
make_map_skew_pole( decapole, 3 );
make_map_skew_pole( dodecapole, 4 );
make_map_skew_pole( 14pole, 5 );
make_map_skew_pole( 16pole, 6 );
make_map_skew_pole( 18pole, 7 );
make_map_skew_pole( 20pole, 8 );

int cntdrift = 0;
extern int thin6d_map_exact_drift_(double *coord, double *argf, double *argi) {
  double xp = coord[2], yp = coord[3]; 
  double RatioPtoPj = coord[4];
  double PathLengthDiff = coord[5];
  double EnergyOfParticle = coord[6], MomentumOfParticle = coord[7];
  double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];
  double RatioBetaToBetaj = coord[12];
  double MomentumOfParticle0 = coord[13]; 

  double EnergyOfReferenceParticle = argf[1], MomentumOfReferenceParticle = argf[0]; 
  double RestMassOfParticle = argf[2]; 
  double dppoff = argf[3];
  double ElementType = argf[4];
  double FirstAdditionalDatum = argf[5];
  double FrequencyOfCavity = argf[6];
  double LagPhaseOfCavity = argf[7];
  double VoltageOfCavity = argf[8];
  double RFFrequencyOfCavity = argf[9];
  double PathLengthOffset = argf[10];

  MomentumOfParticle0 = MomentumOfParticle;
  if( abs( dppoff ) > OnePoweredToMinus38 ) PathLengthDiff  = PathLengthDiff - PathLengthOffset;

  if( ElementType == 12 )
    EnergyOfParticle += FirstAdditionalDatum * sin_rn( FrequencyOfCavity * PathLengthDiff + LagPhaseOfCavity );
  else
    EnergyOfParticle += VoltageOfCavity * sin_rn( RFFrequencyOfCavity * PathLengthDiff );

  coord[7] = sqrt( EnergyOfParticle*EnergyOfParticle - RestMassOfParticle*RestMassOfParticle );
  MomentumOfParticle = coord[7];
  coord[12] = ( EnergyOfParticle * MomentumOfReferenceParticle ) / ( EnergyOfReferenceParticle * MomentumOfParticle );
  RatioBetaToBetaj = coord[12];
  coord[8] = ( MomentumOfParticle - MomentumOfReferenceParticle ) / MomentumOfReferenceParticle;
  RatioDeltaPtoPj = coord[8];
  coord[4] = 1.0 / ( 1.0 + RatioDeltaPtoPj );
  RatioPtoPj = coord[4];
  coord[9] = ( RatioDeltaPtoPj * OnePoweredTo3 ) * RatioPtoPj;
  RatioDeltaPtoPj1 = coord[9];

  coord[2] = ( MomentumOfParticle0 / MomentumOfParticle ) * xp;
  coord[3] = ( MomentumOfParticle0 / MomentumOfParticle ) * yp;

  if(cntdrift++ == 0) printf("thin6d exact drift called\n");

  return 1;
}

#define make_map_multipole_hor_zapprox(NAME)                                                                            \
    int cntmulhorz##NAME = 0;                                                                                           \
    extern int thin6d_map_multipole_##NAME##_(double *coord, double *argf, double *argi) {                              \
      double x = coord[0], y = coord[1];                                                                                \
      double xp = coord[2], yp = coord[3];                                                                              \
      double RatioPtoPj = coord[4];                                                                                     \
      double PathLengthDiff = coord[5];	                                                                                \
      double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];                                                    \
      double RatioBetaToBetaj = coord[12];	                                                                        \
                                                                                                                        \
      double PhysicalLengthOfBlock = argf[0];                                                                           \
      double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                    \
      double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                  \
      double VerticalBendingKick = argf[5];							                        \
                                                                                                                        \    
      double xlvj, zlvj;                                                                                                \
                                                                                                                         \
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;	\
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;	\
      coord[2] = ( xp - PhysicalLengthOfBlock * TiltComponentSin * RatioDeltaPtoPj1 ) + (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) *	 TiltComponentSin;                                                                                                        \
      coord[3] = ( yp + PhysicalLengthOfBlock * TiltComponentCos * RatioDeltaPtoPj1 ) - (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos);                                                                                                       \
      coord[5] = PathLengthDiff - ( RatioBetaToBetaj * VerticalBendingKick ) * zlvj;                                     \
                                                                                                                         \
      if( cntmulhorz##NAME++ == 0 ) printf("multipole hor zero approx "#NAME" called  \n");                                     \
                                                                                                                         \
      return 1;	                                                                                                         \
   }

make_map_multipole_hor_zapprox(hor_zapprox_ho);
make_map_multipole_hor_zapprox(purehor_zapprox);

#define make_map_multipole_hor_nzapprox(NAME)                                                                         \
    int cntmulhornz##NAME = 0;						                                              \
    extern int thin6d_map_multipole_##NAME##_(double *coord, double *argf, double *argi) {                            \
      double x = coord[0], y = coord[1];                                                                              \
      double xp = coord[2], yp = coord[3];                                                                            \
      double RatioPtoPj = coord[4];                                                                                   \
      double PathLengthDiff = coord[5];	                                                                              \
      double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];                                                  \
      double RatioBetaToBetaj = coord[12];                                                                            \
                                                                                                                      \
      double PhysicalLengthOfBlock = argf[0];                                                                        \
      double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                  \
      double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                \
      double HorizontalBendingKick = argf[5];	                                                                      \
                                                                                                                      \
      double xlvj, zlvj;                                                                                              \
                                                                                                                      \
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;	\
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;	\
      coord[2] = ( xp - ((( PhysicalLengthOfBlock * xlvj ) * RatioPtoPj + RatioDeltaPtoPj1 ) * HorizontalBendingKick ) * TiltComponentCos ) + (( OnePoweredTo3 * HorizontalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos );	                               \
      coord[3] = ( yp - ((( PhysicalLengthOfBlock * xlvj ) * RatioPtoPj + RatioDeltaPtoPj1 ) * HorizontalBendingKick ) * TiltComponentSin ) + (( OnePoweredTo3 * HorizontalBendingKick ) * RatioPtoPj ) *  TiltComponentSin;                                         \
      coord[5] = PathLengthDiff + ( RatioBetaToBetaj * HorizontalBendingKick ) * xlvj;	                               \
                                                                                                                       \
      if( cntmulhornz##NAME++ == 0 ) printf("mulipole hor non zero approx "#NAME" called\n");                           \
                                                                                                                       \
      return 1;	                                                                                                       \
  }

make_map_multipole_hor_nzapprox(hor_nzapprox_ho);
make_map_multipole_hor_nzapprox(purehor_nzapprox);

#define make_map_multipole_ver_nzapprox(NAME)  \
    int cntmulvernz##NAME = 0;						\
    extern int thin6d_map_multipole_##NAME##_(double *coord, double *argf, double *argi) {                            \
      double x = coord[0], y = coord[1];                                                                              \
      double xp = coord[2], yp = coord[3];                                                                            \
      double RatioPtoPj = coord[4];                                                                                   \
      double PathLengthDiff = coord[5];	                                                                              \
      double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];                                                  \
      double RatioBetaToBetaj = coord[12];                                                                            \
                                                                                                                      \
      double PhysicalLengthOfBlock = argf[0];                                                                         \
      double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                  \
      double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                \
      double VerticalBendingKick = argf[5];                                                                           \
                                                                                                                      \
      double xlvj, zlvj;                                                                                              \
													\
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;	\
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;	\
      coord[2] = ( xp + ((( PhysicalLengthOfBlock * zlvj ) * RatioPtoPj - RatioDeltaPtoPj1 ) * VerticalBendingKick ) * TiltComponentSin ) + (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * TiltComponentSin;                                             \
      coord[3] = ( yp - ((( PhysicalLengthOfBlock * zlvj ) * RatioPtoPj - RatioDeltaPtoPj1 ) * VerticalBendingKick ) * TiltComponentCos ) - (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos);			                \
      coord[5] = PathLengthDiff - ( RatioBetaToBetaj * VerticalBendingKick ) * zlvj;			                \
										\
      if( cntmulvernz##NAME++ == 0 ) printf("mulipole verticle non-zero approx "#NAME" called \n");		\
                                                                                                                        \
      return 1;                                                                                                         \
}

make_map_multipole_ver_nzapprox(ver_nzapprox_ho);
make_map_multipole_ver_nzapprox(purever_nzapprox);

#define make_map_multipole_ver_zapprox(NAME)                                                                          \
    int cntmulverz##NAME = 0;                                                                                         \
    extern int thin6d_map_multipole_##NAME##_(double *coord, double *argf, double *argi) {					            	                                                                                                                  \
      double x = coord[0], y = coord[1];                                                                              \
      double xp = coord[2], yp = coord[3];                                                                            \
      double RatioPtoPj = coord[4];                                                                                   \
      double PathLengthDiff = coord[5];	                                                                              \
      double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];                                                  \
      double RatioBetaToBetaj = coord[12];                                                                            \
                                                                                                                      \
      double PhysicalLengthOfBlock = argf[0];                                                                         \
      double TiltComponentCos = argf[1], TiltComponentSin = argf[2];                                                  \
      double CurrentEntryDisplacementX = argf[3], CurrentEntryDisplacementY = argf[4];                                \
      double VerticalBendingKick = argf[5];                                                                           \
                                                                                                                      \
      double xlvj, zlvj;                                                                                              \
                                                                                                                      \
      xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;       \
      zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;       \
      coord[2] = ( xp - PhysicalLengthOfBlock * TiltComponentSin * RatioDeltaPtoPj1 ) + (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * TiltComponentSin;                                                                                                     \
      coord[3] = ( yp + PhysicalLengthOfBlock * TiltComponentCos * RatioDeltaPtoPj1 ) - (( OnePoweredTo3 * VerticalBendingKick ) * RatioPtoPj ) * ( 1.0 - TiltComponentCos);                                                                                                    \
      coord[5] = PathLengthDiff - ( RatioBetaToBetaj * VerticalBendingKick ) * zlvj;                                  \
                                                                                                                      \
      if( cntmulverz##NAME++ == 0 ) printf("mulipole vericle zero approx "#NAME" called \n");                                          \
                                                                                                                      \
      return 1;                                                                                                       \
}

make_map_multipole_ver_zapprox(ver_zapprox_ho);
make_map_multipole_ver_zapprox(purever_zapprox);

#define make_map_crab_cavity( I, C )                                                                                   \
  int cntcrabcavity##I = 0;                                                                                            \
  extern int thin6d_map_crab_cavity_##I##_(double *coord, double *argf, double *argi) {                                \
    double x = coord[0], y = coord[1];                                                                                 \
    double xp = coord[2], yp = coord[3];                                                                               \
    double RatioPtoPj = coord[4];                                                                                      \
    double PathLengthDiff = coord[5];                                                                                  \
    double EnergyOfParticle = coord[6], MomentumOfParticle = coord[7];                                                 \
    double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9];                                                      \
    double RatioBetaToBetaj = coord[12];                                                                               \
    double MomentumOfParticle0 = coord[13];                                                                            \
                                                                                                                       \
    double AmplitudeCrabCavity = argf[0], FrequencyCrabCavity = argf[1], PhaseCrabCavity = argf[2];                    \
    double FirstAdditionalDatum = argf[3];                                                                             \
    double RestMassOfParticle = argf[4];                                                                               \
    double EnergyOfReferenceParticle =argf[5], MomentumOfReferenceParticle = argf[6];                                  \
                                                                                                                       \
    AmplitudeCrabCavity = ( FirstAdditionalDatum / MomentumOfParticle ) * OnePoweredTo3;                               \
    C##p = C##p - AmplitudeCrabCavity * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity );                                                                                                                     \
    RatioDeltaPtoPj = RatioDeltaPtoPj - (((((( AmplitudeCrabCavity * FrequencyCrabCavity) * 2.0 ) * Pi ) / SpeedOfLight_mps ) * C ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity ) ) * OnePoweredToMinus3;  \
                                                                                                                       \
    MomentumOfParticle0 = MomentumOfParticle;                                                                          \
    MomentumOfParticle = RatioDeltaPtoPj * MomentumOfReferenceParticle + MomentumOfReferenceParticle;                   \
    EnergyOfParticle = sqrt( MomentumOfParticle*MomentumOfParticle + RestMassOfParticle*RestMassOfParticle );          \
    RatioPtoPj = One / ( One + RatioDeltaPtoPj );                                                                       \
    RatioDeltaPtoPj1 = ( RatioDeltaPtoPj * OnePoweredTo3 ) * RatioPtoPj;                                                 \
    xp = ( MomentumOfParticle0 / MomentumOfParticle ) * xp;                                                            \
    yp = ( MomentumOfParticle0 / MomentumOfParticle ) * yp;                                                            \
    RatioBetaToBetaj = ( EnergyOfParticle * MomentumOfReferenceParticle ) / ( EnergyOfReferenceParticle * MomentumOfParticle );  \
                                                                                                                       \
    coord[2] = xp;    coord[3] = yp;                                                                                   \
    coord[4] = RatioPtoPj;                                                                                             \
    coord[6] = EnergyOfParticle;  coord[7] = MomentumOfParticle; coord[13] = MomentumOfParticle0;                      \
    coord[8] = RatioDeltaPtoPj;    coord[9] = RatioDeltaPtoPj1;                                                          \
    coord[12] = RatioBetaToBetaj;                                                                                      \
                                                                                                                       \
   if( cntcrabcavity##I++ == 0 ) printf("crab_cavity"#I" called %d times\n",cntcrabcavity##I);                         \
                                                                                                                       \
   return 1;                                                                                                           \
}

make_map_crab_cavity(1,x);
make_map_crab_cavity(2,y);

extern int thin6d_modify_coords_for_hirata_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double PathLengthDiff = coord[5];
  double RatioDeltaPtoPj = coord[8];
  double ModifiedX = coord[25], ModifiedXp = coord[26], ModifiedY = coord[27], ModifiedYp = coord[28], ModifiedSigma = coord[29], ModifiedDelta = coord[30];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double ClosedOrbitBeamX = argf[5], ClosedOrbitBeamY = argf[6], ClosedOrbitBeamSigma = argf[7], ClosedOrbitBeamPx = argf[8], ClosedOrbitBeamPy = argf[9], ClosedOrbitBeamDelta = argf[10];
 
  ModifiedX = ( x + HorBeamBeamSeparation - ClosedOrbitBeamX ) * OnePoweredToMinus3;
  ModifiedXp = ( xp / RatioPtoPj - ClosedOrbitBeamPx ) * OnePoweredToMinus3;
  ModifiedY = ( y + VerBeamBeamSeparation - ClosedOrbitBeamY ) * OnePoweredToMinus3;
  ModifiedYp = ( yp / RatioPtoPj  - ClosedOrbitBeamPy ) * OnePoweredToMinus3;
  ModifiedSigma = ( PathLengthDiff - ClosedOrbitBeamSigma ) * OnePoweredToMinus3;
  ModifiedDelta = RatioDeltaPtoPj - ClosedOrbitBeamDelta;

  coord[25] = ModifiedX;
  coord[26] = ModifiedXp;
  coord[27] = ModifiedY;
  coord[28] = ModifiedYp;
  coord[29] = ModifiedSigma;
  coord[30] = ModifiedDelta;

  return 1;
}

int cnthirata = 0;
extern int thin6d_map_hirata_beambeam_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double PathLengthDiff = coord[5];
  double EnergyOfParticle = coord[6], MomentumOfParticle = coord[7];
  double RatioDeltaPtoPj = coord[8];
  double RatioBetaToBetaj = coord[12];
  double ModifiedX = coord[25], ModifiedXp = coord[26], ModifiedY = coord[27], ModifiedYp = coord[28], ModifiedSigma = coord[29], ModifiedDelta = coord[30];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double EnergyOfReferenceParticle = argf[2], MomentumOfReferenceParticle = argf[3];
  double RestMassOfParticle = argf[4];
  double ClosedOrbitBeamX = argf[5], ClosedOrbitBeamY = argf[6], ClosedOrbitBeamSigma = argf[7], ClosedOrbitBeamPx = argf[8], ClosedOrbitBeamPy = argf[9], ClosedOrbitBeamDelta = argf[10];
  double BeamOffsetX = argf[11], BeamOffsetY = argf[12], BeamOffsetSigma = argf[13], BeamOffsetPx = argf[14], BeamOffsetPy = argf[15], BeamOffsetDelta = argf[16];

  x = ( ModifiedX * OnePoweredTo3 + ClosedOrbitBeamX ) - BeamOffsetX;
  coord[0] = x;
  y = ( ModifiedY * OnePoweredTo3 + ClosedOrbitBeamY ) - BeamOffsetY;
  coord[1] = y;
  RatioDeltaPtoPj = ( ModifiedDelta + ClosedOrbitBeamDelta ) - BeamOffsetDelta;
  coord[8] = RatioDeltaPtoPj;
  RatioPtoPj = One / ( One + RatioDeltaPtoPj );
  coord[4] = RatioPtoPj;
  xp = (( ModifiedXp * OnePoweredTo3 + ClosedOrbitBeamPx ) - BeamOffsetPx ) * RatioPtoPj;
  coord[2] = xp;
  yp = (( ModifiedYp * OnePoweredTo3 + ClosedOrbitBeamPy ) - BeamOffsetPy ) * RatioPtoPj;
  coord[3] = yp;
  MomentumOfParticle = RatioDeltaPtoPj * MomentumOfReferenceParticle + MomentumOfReferenceParticle;
  coord[7] = MomentumOfParticle;
  EnergyOfParticle = sqrt( MomentumOfParticle*MomentumOfParticle + RestMassOfParticle*RestMassOfParticle );
  coord[6] = EnergyOfParticle;
  RatioBetaToBetaj = ( EnergyOfParticle * MomentumOfReferenceParticle ) / ( EnergyOfReferenceParticle * MomentumOfParticle );
  coord[12] = RatioBetaToBetaj;

  if( cnthirata++ == 0 ) printf("Hirata called\n");

  return 1;
}

int cntacccavity = 0;
extern int thin6d_map_accelerating_cavity_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double PathLengthDiff = coord[5];
  double RatioDeltaPtoPj = coord[8];

  int idz1 = (int)argf[0], idz2 = (int)argf[1];
  double cotr_irrtr_1 = argf[2], cotr_irrtr_2 = argf[3], cotr_irrtr_3 = argf[4], cotr_irrtr_4 = argf[5], cotr_irrtr_5 = argf[6], cotr_irrtr_6 = argf[7];
  double rrtr_irrtr_5_1 = argf[8], rrtr_irrtr_5_2 = argf[9], rrtr_irrtr_5_3 = argf[10], rrtr_irrtr_5_4 = argf[11], rrtr_irrtr_5_6 = argf[12], rrtr_irrtr_1_1 = argf[13], rrtr_irrtr_1_2 = argf[14], rrtr_irrtr_1_6 = argf[15], rrtr_irrtr_2_1 = argf[16], rrtr_irrtr_2_2 = argf[17], rrtr_irrtr_2_6 = argf[18], rrtr_irrtr_3_3 = argf[19], rrtr_irrtr_3_4 = argf[20], rrtr_irrtr_3_6 = argf[21], rrtr_irrtr_4_3 = argf[22], rrtr_irrtr_4_4 = argf[23], rrtr_irrtr_4_6 = argf[24];

  double pux,dpsv3j;

  PathLengthDiff  = ((((( PathLengthDiff + cotr_irrtr_5 ) + rrtr_irrtr_5_1 * x ) + rrtr_irrtr_5_2 * xp ) + rrtr_irrtr_5_3 * y ) + rrtr_irrtr_5_4 * yp ) + ( rrtr_irrtr_5_6 * RatioDeltaPtoPj ) * OnePoweredTo3;
  coord[5] = PathLengthDiff;
  pux = x;
  dpsv3j = RatioDeltaPtoPj * OnePoweredTo3;
  x = (( cotr_irrtr_2 + rrtr_irrtr_1_1 * pux ) + rrtr_irrtr_1_2 * xp ) + ( (double)idz1 * dpsv3j ) * rrtr_irrtr_1_6;
  coord[0] = x;
  xp = (( cotr_irrtr_2 + rrtr_irrtr_2_1 * pux ) + rrtr_irrtr_2_2 * xp ) + ( (double)idz1 * dpsv3j ) * rrtr_irrtr_2_6;
  coord[2] = xp;
  pux = y;
  y = (( cotr_irrtr_3 + rrtr_irrtr_3_3 * pux ) + rrtr_irrtr_3_4 * yp ) + ( (double)idz2 * dpsv3j ) * rrtr_irrtr_3_6;
  coord[1] = y;
  yp = (( cotr_irrtr_4 + rrtr_irrtr_4_3 * pux ) + rrtr_irrtr_4_4 * yp ) + ( (double)idz2 * dpsv3j ) * rrtr_irrtr_4_6;
  coord[3] = yp;

  if( cntacccavity++ == 0 ) printf("accelerating cavity\n");

  return 1;
}

int cntdipedge = 0;
extern int thin6d_map_dipedge_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double RatioBetaToBetaj = coord[12];

  double CurrentEntryDisplacementX = argf[0], CurrentEntryDisplacementY = argf[1];
  double TiltComponentCos = argf[2], TiltComponentSin = argf[3];
  double PhysicalLengthOfBlock = argf[4];
  double PhysicalLengthOfBlockHorComp = argf[5],  PhysicalLengthOfBlockVerComp = argf[6];

  double xlvj, zlvj, crkve, cikve;

  xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;
  zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos + ( x - CurrentEntryDisplacementX ) * TiltComponentSin;
  crkve = xlvj;
  cikve = zlvj;
  xp = xp + RatioPtoPj * ( PhysicalLengthOfBlockHorComp * crkve - PhysicalLengthOfBlock * TiltComponentCos * cikve );
  coord[2] = xp;
  yp = yp + RatioPtoPj * ( PhysicalLengthOfBlockVerComp * cikve + PhysicalLengthOfBlock * TiltComponentCos * crkve );
  coord[3] = yp;

  if( cntdipedge++ == 0 ) printf("dipedge called\n");

  return 1;
}

int cntsolenoid = 0;
extern int thin6d_map_solenoid_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double PathLengthDiff = coord[5];
  double EnergyOfParticle = coord[6], MomentumOfParticle = coord[7];
  double RatioBetaToBetaj = coord[12];
  double MomentumOfParticle0 = coord[13];

  double PhysicalLengthOfBlockHorComp = argf[0],  PhysicalLengthOfBlockVerComp = argf[1];
  double crkve, cikve, temp;

  xp = xp - y * PhysicalLengthOfBlockHorComp;
  yp = yp + x * PhysicalLengthOfBlockHorComp;
  crkve = xp - ((( x * PhysicalLengthOfBlockHorComp ) * PhysicalLengthOfBlockVerComp ) * MomentumOfParticle0 ) / MomentumOfParticle;

  cikve = yp - ((( y * PhysicalLengthOfBlockHorComp ) * PhysicalLengthOfBlockVerComp ) * MomentumOfParticle0 ) / MomentumOfParticle;

  temp = ( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle;

  xp = crkve * cos_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle ) + cikve * sin_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle );
  yp = cikve * cos_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle ) - crkve * sin_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle );

  crkve = x * cos_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle ) + y * sin_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle );
  cikve = y * cos_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle ) - x * sin_rn(( PhysicalLengthOfBlockVerComp * MomentumOfParticle0 ) / MomentumOfParticle );
  x = crkve;
  y = cikve;
  xp = xp + y * PhysicalLengthOfBlockHorComp;
  yp = yp - x * PhysicalLengthOfBlockHorComp;
  crkve = PathLengthDiff - 0.5 * ((((((( x*x + y*y ) * PhysicalLengthOfBlockHorComp ) * PhysicalLengthOfBlockVerComp ) * RatioBetaToBetaj ) *  MomentumOfParticle0 ) / MomentumOfParticle ) * MomentumOfParticle0 ) / MomentumOfParticle;
  PathLengthDiff = crkve;
  crkve = xp - ((( x * PhysicalLengthOfBlockHorComp ) * PhysicalLengthOfBlockVerComp ) * MomentumOfParticle0 ) / MomentumOfParticle;
  cikve = yp - ((( y * PhysicalLengthOfBlockHorComp ) * PhysicalLengthOfBlockVerComp ) * MomentumOfParticle0 ) / MomentumOfParticle;
  PathLengthDiff = PathLengthDiff + (((((( x * cikve - y * crkve ) * PhysicalLengthOfBlockVerComp ) * RatioBetaToBetaj ) * MomentumOfParticle0 ) / MomentumOfParticle ) * MomentumOfParticle0 ) /MomentumOfParticle;

  coord[0] = x;   coord[1] = y;
  coord[2] = xp;  coord[3]= yp;
  coord[5] = PathLengthDiff;

  if( cntsolenoid++ == 0 ) printf("solenoid called \n");

  return 1;
}

int cntacdipole = 0;
extern int thin6d_map_ac_dipole_(double *coord, double *argf, double *argi) {
  double xp = coord[2], yp = coord[3];
  double MomentumOfParticle = coord[7];

  double TiltComponentCos = argf[0], TiltComponentSin = argf[1];
  double xory = argf[2];
  double ACDipoleAmplitude = argf[3], ACDipoleAmplitudeHorComp = argf[4], ACDipoleAmplitudeVerComp = argf[5];
  int nramp1 = (int)argf[6], nramp2 = (int)argf[7], nac = (int)argf[8], nplato = (int)argf[9];
  double Qd = argf[10], ACPhase = argf[11];

  if( xory == 1 )
  {
    ACDipoleAmplitudeVerComp = ACDipoleAmplitude * TiltComponentSin;
    ACDipoleAmplitudeHorComp = ACDipoleAmplitude * TiltComponentCos;
  }
  else
  {
    ACDipoleAmplitudeVerComp = ACDipoleAmplitude * TiltComponentCos;
    ACDipoleAmplitudeHorComp = - ACDipoleAmplitude * TiltComponentSin;
  }

  if( nramp1 > nac )
  {
    xp = xp + ((( ACDipoleAmplitudeHorComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase ) ) * (double)nac ) / (double)nramp1 ) / MomentumOfParticle;
    yp = yp + ((( ACDipoleAmplitudeVerComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase )  ) * (double)nac ) / (double)nramp1 ) / MomentumOfParticle;
  }

  if( nac >= nramp1 && ( nramp1 + nplato ) > nac )
  {
    xp = xp + ( ACDipoleAmplitudeHorComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase )  ) / MomentumOfParticle;
    yp = yp + ( ACDipoleAmplitudeVerComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase )  ) / MomentumOfParticle;
  }

  if( nac >= ( nramp1 + nplato ) && ( nramp2 + nramp1 + nplato ) > nac )
  {
    xp = xp + (( ACDipoleAmplitudeHorComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase )  ) * (( -1.0 * (double)nac - nramp1 - nramp2 - nplato ) / (double)nramp2 )) / MomentumOfParticle;
    yp = yp + (( ACDipoleAmplitudeVerComp * sin_rn((( 2.0 * Pi ) * Qd ) * (double)nac + ACPhase )  ) * (( -1.0 * (double)nac - nramp1 - nramp2 - nplato ) / (double)nramp2 )) / MomentumOfParticle;
  }

  coord[2] = xp;
  coord[3] = yp;

  if( cntacdipole++ == 0 ) printf("AC Dipole called \n");

  return 1;
}

int cntwire = 0;
extern int thin6d_map_wire_(double *coord, double *argf, double *argi) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioDeltaPtoPj = coord[8];

  double embl = argf[0], tx = argf[1], ty= argf[2], lin = argf[3];
  double rx = argf[4], ry = argf[5], cur = argf[6], chi = argf[7], l = argf[8], leff = argf[9];

  double xi, yi;

  x = x * OnePoweredToMinus3;
  y = y * OnePoweredToMinus3;
  xp = xp * OnePoweredToMinus3;
  yp = yp * OnePoweredToMinus3;

  x = x - (( embl * 0.5 ) * xp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );
  y = y - (( embl * 0.5 ) * yp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );

  y = y - ((( x * sin_rn(tx) ) * yp ) / sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp )) / cos_rn(atan_rn(xp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - tx );

  x = x * ( cos_rn(tx) - sin_rn(tx) * tan_rn(atan_rn(xp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - tx ));

  xp = sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp ) * sin_rn(atan_rn(xp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - tx );

  x = x - ((( y * sin_rn(ty) ) * xp ) / sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp )) / cos_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - ty );
  y = y * ( cos_rn(ty) - sin_rn(ty) * tan_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - ty ));

  yp = sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp ) * sin_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) - ty );
 
  x = x + ( lin * xp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );
  y = y + ( lin * yp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );

  xi = x - rx;
  yi = y - ry;

  xp = xp - (((( OnePoweredToMinus7 * cur ) / chi ) * xi ) / ( xi*xi + yi*yi )) * ( sqrt((( lin + l )*( lin + l ) + xi*xi ) + yi*yi ) - sqrt((( lin -l )*( lin -l ) + xi*xi ) + yi*yi ));
  yp = yp - (((( OnePoweredToMinus7 * cur ) / chi ) * yi ) / ( xi*xi + yi*yi )) * ( sqrt((( lin + l )*( lin + l ) + xi*xi ) + yi*yi ) - sqrt((( lin -l )*( lin -l ) + xi*xi ) + yi*yi ));

  x = x + (( leff - lin ) * xp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );
  y = y + (( leff - lin ) * yp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );

  x = x - ((( y * sin_rn(-ty) ) * xp ) / sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp )) / cos_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + ty );

  y = y * ( cos_rn(-1.0 * ty) - sin_rn(-1.0 * ty) * tan_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + ty ));

  yp = sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) * sin_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + ty );

  y = y - ((( x * sin_rn(-1.0 * tx) ) * yp ) / sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp )) / cos_rn(atan_rn(yp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + tx );

  x = x * ( cos_rn(-1.0 * tx) - sin_rn(-1.0 * tx) * tan_rn(atan_rn(xp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + tx ));

  xp = sqrt(( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - yp*yp ) * sin_rn(atan_rn(xp / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp )) + tx );

  x = x + embl * tan_rn(tx);
  y = y + (embl * tan_rn(ty) ) / cos_rn(tx);

  x = x - (( embl * 0.5 ) * xp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );
  y = y - (( embl * 0.5 ) * yp ) / sqrt((( 1.0 + RatioDeltaPtoPj )*( 1.0 + RatioDeltaPtoPj ) - xp*xp ) - yp*yp );

  x = x * OnePoweredTo3;
  y = y * OnePoweredTo3;
  xp = xp * OnePoweredTo3;
  yp = yp * OnePoweredTo3;

  coord[0] = x;
  coord[1] = y;
  coord[2] = xp;
  coord[3] = yp;

  if( cntwire++ == 0 ) printf("wire called \n");

  return 1;
}

#define thin6d_map_jbgrfcc_multipoles_order2_main_assignment                                                   \
  coord[2] = xp + (( AmplitudeCrabCavity2 * crkve ) * RatioPtoPj ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi +  PhaseCrabCavity2 );                                                                              \
  coord[3] = yp - (( AmplitudeCrabCavity2 * cikve ) * RatioPtoPj ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity2 );                                                                               \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj - (((( 0.5 * ( AmplitudeCrabCavity2 * RatioPtoPj )) * ( crkve*crkve - cikve*cikve )) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus3 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity2 );                                                                    

#define thin6d_map_jbgrfcc_multipoles_order2_2_main_assignment                                                 \
  coord[3] = yp + (( AmplitudeCrabCavity2 * cikve ) * RatioPtoPj ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity2 );                                                                               \
  coord[2] = xp + (( AmplitudeCrabCavity2 * crkve ) * RatioPtoPj ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi +  PhaseCrabCavity2 );                                                                              \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj - (((( AmplitudeCrabCavity2 * RatioPtoPj ) * ( crkve*crkve )) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus3 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity2 );

#define thin6d_map_jbgrfcc_multipoles_order3_main_assignment                                                   \
  coord[2] = xp + ((( AmplitudeCrabCavity3 * RatioPtoPj ) * OnePoweredToMinus3) * ( crkve*crkve - cikve*cikve )) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );                                  \
  coord[3] = yp - (( 2.0*((( AmplitudeCrabCavity3 * crkve )* cikve ) * RatioPtoPj )) * OnePoweredToMinus3 ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );                                  \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj - (((( (1.0/3.0) * ( AmplitudeCrabCavity3 * RatioPtoPj )) * ( crkve*crkve*crkve - ( 3.0*cikve*cikve ) *crkve )) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus6 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );

#define thin6d_map_jbgrfcc_multipoles_order3_2_main_assignment                                                 \
  coord[3] = yp - ((( AmplitudeCrabCavity3 * RatioPtoPj ) * OnePoweredToMinus3 ) * ((cikve*cikve) - (crkve*crkve))) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );            \
  coord[2] = xp + (( 2.0 * ( AmplitudeCrabCavity3 * (crkve * (cikve * RatioPtoPj )))) * OnePoweredToMinus3) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );                                  \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj + (((( (1.0/3.0) * ( AmplitudeCrabCavity3 * RatioPtoPj )) * ( cikve*cikve*cikve - ( 3.0*crkve*crkve ) *cikve )) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus6 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity3 );

#define thin6d_map_jbgrfcc_multipoles_order4_main_assignment                                                   \
  coord[2] = xp + ((( AmplitudeCrabCavity4 * RatioPtoPj ) * ( crkve*crkve*crkve - ( 3.0*crkve )* cikve*cikve )) * OnePoweredToMinus6 ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );            \
  coord[3] = yp - ((( AmplitudeCrabCavity4 * RatioPtoPj ) * (( 3.0*cikve) * crkve*crkve - cikve*cikve*cikve )) * OnePoweredToMinus6 ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );            \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj - (((( 0.25 * ( AmplitudeCrabCavity4 * RatioPtoPj )) * ( crkve*crkve*crkve*crkve - ( 6.0*crkve*crkve ) *cikve*cikve + cikve*cikve*cikve*cikve )) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus9 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );

#define thin6d_map_jbgrfcc_multipoles_order4_2_main_assignment                                                 \
  coord[2] = xp + ((( AmplitudeCrabCavity4 * RatioPtoPj ) * ( cikve*cikve*cikve - ( 3.0*cikve )* crkve*crkve )) * OnePoweredToMinus6 ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );            \
  coord[3] = yp + ((( AmplitudeCrabCavity4 * RatioPtoPj ) * (( 3.0*crkve) * cikve*cikve - crkve*crkve*crkve )) * OnePoweredToMinus6 ) * cos_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );            \
  xp = coord[2];                                                                                               \
  yp = coord[3];                                                                                               \
  coord[8] = RatioDeltaPtoPj - (((( AmplitudeCrabCavity4 * RatioPtoPj ) * (( crkve*crkve*crkve * cikve ) - ( cikve*cikve*cikve * crkve ))) * ((( FrequencyCrabCavity * 2.0 ) * Pi ) / SpeedOfLight_mps )) * OnePoweredToMinus9 ) * sin_rn(((( PathLengthDiff / SpeedOfLight_mps ) * FrequencyCrabCavity ) * 2.0 ) * Pi + PhaseCrabCavity4 );


#define make_map_jbgrfcc_multipoles(NAME,i)                                                                         \
int cntjbg##NAME = 0;                                                                                               \
extern int thin6d_map_jbgrfcc_multipoles_##NAME##_(double *coord, double *argf, double *argi) {                     \
  double x = coord[0], y = coord[1];                                                                                \
  double xp = coord[2], yp = coord[3];                                                                              \
  double RatioPtoPj = coord[4];                                                                                     \
  double PathLengthDiff = coord[5];                                                                                 \
  double EnergyOfParticle = coord[6], MomentumOfParticle = coord[7];                                                \
  double RatioDeltaPtoPj = coord[8], RatioDeltaPtoPj1 = coord[9], OnePlusRatioDeltaPtoP = coord[10], SqrtRatioDeltaPtoP = coord[11];  \
  double RatioBetaToBetaj = coord[12];                                                                              \
  double MomentumOfParticle0 = coord[13];                                                                           \
                                                                                                                    \
  double CurrentEntryDisplacementX = argf[0], CurrentEntryDisplacementY = argf[1];                                  \
  double TiltComponentCos = argf[2], TiltComponentSin = argf[3];                                                    \
  double FrequencyCrabCavity = argf[4], AmplitudeCrabCavity##i = argf[5], PhaseCrabCavity##i = argf[6];             \
  double EnergyOfReferenceParticle = argf[7], MomentumOfReferenceParticle = argf[8];                                \
  double RestMassOfParticle = argf[9];                                                                              \
                                                                                                                    \
  double xlvj, zlvj;                                                                                                \
  double crkve, cikve, crkveuk;                                                                                     \
                                                                                                                    \
  xlvj = ( x - CurrentEntryDisplacementX ) * TiltComponentCos + ( y - CurrentEntryDisplacementY ) * TiltComponentSin;                \
  zlvj = ( y - CurrentEntryDisplacementY ) * TiltComponentCos - ( x - CurrentEntryDisplacementX ) * TiltComponentSin;                \
  crkve = xlvj;                                                                                                     \
  cikve = zlvj;                                                                                                     \
                                                                                                                    \
  thin6d_map_jbgrfcc_multipoles_##NAME##_main_assignment                                                            \
                                                                                                                    \
  RatioDeltaPtoPj = coord[8];                                                                                        \
  coord[13] = MomentumOfParticle;                                                                                   \
  MomentumOfParticle0 = coord[13];                                                                                  \
  coord[7] = RatioDeltaPtoPj * MomentumOfReferenceParticle + MomentumOfReferenceParticle;                            \
  MomentumOfParticle = coord[7];                                                                                    \
  coord[6] = sqrt( MomentumOfParticle*MomentumOfParticle + RestMassOfParticle*RestMassOfParticle );                 \
  EnergyOfParticle = coord[6];                                                                                      \
  coord[4] = 1.0 / ( 1.0 + RatioDeltaPtoPj );                                                                        \
  RatioPtoPj = coord[4];                                                                                            \
  coord[9] = ( RatioDeltaPtoPj * OnePoweredTo3 ) * RatioPtoPj;                                                       \
  RatioDeltaPtoPj1 = coord[9];                                                                                      \
  coord[2] = ( MomentumOfParticle0 / MomentumOfParticle ) * xp;                                                     \
  coord[3] = ( MomentumOfParticle0 / MomentumOfParticle ) * yp;                                                     \
  coord[12] = ( EnergyOfParticle * MomentumOfReferenceParticle ) / ( EnergyOfReferenceParticle * MomentumOfParticle ); \
                                                                                                                    \
  if( cntjbg##NAME++ == 0 ) printf("jbgrfcc_multipole "#NAME" called \n");                                          \
                                                                                                                    \
  return 1;                                                                                                         \
}

make_map_jbgrfcc_multipoles(order2,2);
make_map_jbgrfcc_multipoles(order2_2,2);
make_map_jbgrfcc_multipoles(order3,3);
make_map_jbgrfcc_multipoles(order3_2,3);
make_map_jbgrfcc_multipoles(order4,4);
make_map_jbgrfcc_multipoles(order4_2,4);

void errf( double *var_xx, double *var_yy, double *var_wx, double *var_wy ) {
  int n, nc, nu;
  double cc, h, q, rx[33], ry[33], saux, sx, sy, tn, tx, ty, wx, wy, x, xh, xl, xlim, xx, y, yh, ylim, yy;
  
  cc = 1.12837916709551;
  xlim = 5.33;
  ylim = 4.29;

  xx = *var_xx;
  yy = *var_yy;
  wx = *var_wx;
  wy = *var_wy;
  
  x = abs(xx);
  y = abs(yy);
  if(y < ylim && x < xlim )
  {
    q = ( 1.0 - y / ylim ) * sqrt( 1.0 - ( x / xlim )*( x / xlim ) );
    h = 1.0 / ( 3.2 * q );
    nc = 7 + (int)( 23.0 * q );
    xl = exp_rn( ( 1 - nc ) * log_rn(h) );
    xh = y + 0.5 / h;
    yh = x;
    nu = 10 + (int)( 21 * q );
    rx[nu] = 0.0;
    ry[nu] = 0.0;
    
    for( n = nu; n >= 1; n-- )
    {
      tx = xh + (double)(n) * rx[n];
      ty = yh - (double)(n) * ry[n];
      tn = tx*tx;
      rx[n-1] = ( 0.5 * tx ) / tn;
      ry[n-1] = ( 0.5 * ty ) / tn;
    }
    
    sx = 0.0;
    sy = 0.0;
    
    for( n = nc; n >= 1; n-- )
    {
      saux = sx + xl;
      sx = rx[n-1] * saux - ry[n-1] * sy;
      sy = rx[n-1] * sy + ry[n-1] * saux;
      xl = h * xl;
    }

    wx = cc * sx;
    wy = xx * sy;

    }
  else
  {
    xh = y;
    yh = x;
    rx[0] = 0.0;
    ry[0] = 0.0;
   
    for( n = 9; n >= 1; n-- )
    {
      tx = xh + (double)(n) * rx[0];
      ty = yh - (double)(n) * ry[0];
      tn = tx*tx;
      rx[0] = ( 0.5 * tx ) / tn;
      ry[0] = ( 0.5 * ty ) / tn;
    }

    wx = cc * rx[0];
    wy = cc * ry[0];
   
  }

  if( yy < 0.0 )
  {
    wx = ( 2.0 * exp_rn( y*y - x*x ) ) * cos_rn(( 2.0 * x ) * y ) - wx;
    wy = (( -1.0 * 2.0 ) * exp_rn( y*y - x*x )) * sin_rn(( 2.0 * x ) * y ) - wy;
    if( xx > 0.0 ) wy = -1.0 * wy;
  }
  else if( xx < 0.0 ) wy = -1.0 * wy;

  *var_xx = xx;
  *var_yy = yy;
  *var_wx = wx;
  *var_wy = wy;

}

int cntbb1 = 0;
extern int thin6d_map_beambeam_1_( double *coord, double *argf, double argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double crkvebj, cikvebj, rho2bj, tkbj, cccc;

  if( SwitchToLinearCoupling == 0 )
  {
    crkvebj = ( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation;
    cikvebj = ( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation;
  }
  else
  {
    crkvebj = (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu11 + (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu12;
    cikvebj = (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu11 - (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu12;
  }

  rho2bj = crkvebj*crkvebj + cikvebj*cikvebj;
  if( rho2bj <= OnePoweredToMinus38 ) return 1;

  tkbj = rho2bj / ( 2.0 * SquareOfSigmaNX );

  if( SwitchToLinearCoupling == 0 )
  {
    coord[2] = xp + RatioPtoPj * ((( PhysicalLengthOfBlock * crkvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPx );
    coord[3] = yp + RatioPtoPj * ((( PhysicalLengthOfBlock * cikvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPy );
  }
  else
  {
    cccc = ((( PhysicalLengthOfBlock * crkvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPx ) * bbcu11 - ((( PhysicalLengthOfBlock * cikvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPy ) * bbcu12;

    coord[2] = xp + RatioPtoPj * cccc;
cccc = ((( PhysicalLengthOfBlock * crkvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPx ) * bbcu12 + ((( PhysicalLengthOfBlock * cikvebj ) / rho2bj ) * ( 1.0 - exp_rn( -1.0 * tkbj )) - BeamOffsetPy ) * bbcu11;

    coord[3] = yp + RatioPtoPj * cccc;
  }
  if( cntbb1++ == 0 ) printf("beam beam 1\n");

  return 1;
}

int cntbb20 = 0;
extern int thin6d_map_beambeam_2_ibtyp_0_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double crkvebj, cikvebj, rho2bj, tkbj, cccc, r2bj, rbj, rkbj, xbbj, zbbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  r2bj = 2.0 * ( SquareOfSigmaNX - SquareOfSigmaNY );
  rbj = sqrt(r2bj);

  rkbj = ( PhysicalLengthOfBlock * SquareRootOfPi ) / rbj;

  if( SwitchToLinearCoupling == 0 )
  {
    crkvebj = ( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation;
    cikvebj = ( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation;
  }
  else
  {
    crkvebj = (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu11 + (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu12;
    cikvebj = (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu11 - (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu12;
  }

  xrbj = abs(crkvebj) / rbj;
  zrbj = abs(cikvebj) / rbj;

  errf( &xrbj, &zrbj, &crxbj, &crzbj );

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;

  xbbj = SigmaNqY * xrbj;
  zbbj = SigmaNqX * zrbj;

  errf( &xbbj, &zbbj, &cbxbj, &cbzbj );

  if( SwitchToLinearCoupling == 0 )
  {
    coord[2] = xp + RatioPtoPj * (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) *sign( 1.0, crkvebj ) - BeamOffsetPx );
    coord[3] = yp + RatioPtoPj * (( rkbj * ( crxbj - exp_rn( -1.0 * tkbj ) * cbxbj )) *sign( 1.0, cikvebj ) - BeamOffsetPy );
  }
  else
  {
    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu11 - (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu12;
    coord[2] = xp + RatioPtoPj * cccc;

    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu12 + (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu11;
    coord[3] = yp + RatioPtoPj * cccc;
  }

  if( cntbb20++ == 0 ) printf("beam beam 2 type 0\n");

  return 1;
}

int cntbb2ib11=0;
extern int thin6d_map_beambeam_2_ibtyp_1_1_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];
  double xbbj = coord[18], zbbj = coord[19]; 
  double crkvebj = coord[22], cikvebj = coord[23];
  double rkbj = coord[25];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double rho2bj, tkbj, cccc, r2bj, rbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  r2bj = 2.0 * ( SquareOfSigmaNX - SquareOfSigmaNY );
  rbj = sqrt(r2bj);

  rkbj = ( PhysicalLengthOfBlock * SquareRootOfPi ) / rbj;
  coord[25] = rkbj;

  if( SwitchToLinearCoupling == 0 )
  {
    crkvebj = ( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation;
    cikvebj = ( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation;
    coord[22] = crkvebj;
    coord[23] = cikvebj;
  }
  else
  {
    crkvebj = (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu11 + (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu12;
    cikvebj = (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu11 - (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu12;
    coord[22] = crkvebj;
    coord[23] = cikvebj;
  }

  xrbj = abs(crkvebj) / rbj;
  zrbj = abs(cikvebj) / rbj;

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;

  xbbj = SigmaNqY * xrbj;
  zbbj = SigmaNqX * zrbj;
  coord[18] = xbbj;
  coord[19] = zbbj;

  if( cntbb2ib11++ == 0 ) printf("beam beam 2 ib 1 1\n");

  return 1;
}

int cntbb2ib12=0;
extern int thin6d_map_beambeam_2_ibtyp_1_2_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];
  double xbbj = coord[18], zbbj = coord[19]; 
  double crkvebj = coord[22], cikvebj = coord[23];
  double rkbj = coord[25];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double rho2bj, tkbj, cccc, r2bj, rbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;
  if( SwitchToLinearCoupling == 0 )
  {
    coord[2] = xp + RatioPtoPj * (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) *sign( 1.0, crkvebj ) - BeamOffsetPx );
    coord[3] = yp + RatioPtoPj * (( rkbj * ( crxbj - exp_rn( -1.0 * tkbj ) * cbxbj )) *sign( 1.0, cikvebj ) - BeamOffsetPy );
  }
  else
  {
    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu11 - (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu12;
    coord[2] = xp + RatioPtoPj * cccc;

    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu12 + (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu11;
    coord[3] = yp + RatioPtoPj * cccc;
  }

  if( cntbb2ib12++==0 ) printf("beam beam 2 type 1 2\n");

  return 1;
}

int cntbb3ib0 = 0;
extern int thin6d_map_beambeam_3_ibtyp_0_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double crkvebj, cikvebj, rho2bj, tkbj, cccc, r2bj, rbj, rkbj, xbbj, zbbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  r2bj = 2.0 * ( SquareOfSigmaNY - SquareOfSigmaNX );
  rbj = sqrt(r2bj);

  rkbj = ( PhysicalLengthOfBlock * SquareRootOfPi ) / rbj;

  if( SwitchToLinearCoupling == 0 )
  {
    crkvebj = ( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation;
    cikvebj = ( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation;
  }
  else
  {
    crkvebj = (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu11 + (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu12;
    cikvebj = (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu11 + (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu12;
  }

  xrbj = abs(crkvebj) / rbj;
  zrbj = abs(cikvebj) / rbj;

  errf_( &zrbj, &xrbj, &crzbj, &crxbj );

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;

  xbbj = SigmaNqY * xrbj;
  zbbj = SigmaNqX * zrbj;

  errf_( &zbbj, &xbbj, &cbzbj, &cbxbj );

  if( SwitchToLinearCoupling == 0 )
  {
    coord[2] = xp + RatioPtoPj * (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) *sign( 1.0, crkvebj ) - BeamOffsetPx );
    coord[3] = yp + RatioPtoPj * (( rkbj * ( crxbj - exp_rn( -1.0 * tkbj ) * cbxbj )) *sign( 1.0, cikvebj ) - BeamOffsetPy );
  }
  else
  {
    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu11 - (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu12;
    coord[2] = xp + RatioPtoPj * cccc;

    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu12 + (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu11;
    coord[3] = yp + RatioPtoPj * cccc;
  }

  if( cntbb3ib0++ == 0 ) printf("beam beam 3 type 0\n");

  return 1;
}

int cntbb3ib11 = 0;
extern int thin6d_map_beambeam_3_ibtyp_1_1_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];
  double xbbj = coord[18], zbbj = coord[19]; 
  double crkvebj = coord[22], cikvebj = coord[23];
  double rkbj = coord[25];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double rho2bj, tkbj, cccc, r2bj, rbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  r2bj = 2.0 * ( SquareOfSigmaNY - SquareOfSigmaNX );
  rbj = sqrt(r2bj);

  rkbj = ( PhysicalLengthOfBlock * SquareRootOfPi ) / rbj;
  coord[25] = rkbj;

  if( SwitchToLinearCoupling == 0 )
  {
    crkvebj = ( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation;
    cikvebj = ( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation;
    coord[22] = crkvebj;
    coord[23] = cikvebj;
  }
  else
  {
    crkvebj = (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu11 + (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu12;
    cikvebj = (( y - ClosedOrbitBeamY ) + VerBeamBeamSeparation ) * bbcu11 - (( x - ClosedOrbitBeamX ) + HorBeamBeamSeparation ) * bbcu12;
    coord[22] = crkvebj;
    coord[23] = cikvebj;
  }

  xrbj = abs(crkvebj) / rbj;
  zrbj = abs(cikvebj) / rbj;

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;

  xbbj = SigmaNqY * xrbj;
  zbbj = SigmaNqX * zrbj;
  coord[18] = xbbj;
  coord[19] = zbbj;

  if( cntbb3ib11++ == 0 ) printf("beam beam 3 type1 1\n");

  return 1;
}

int cntbb3ib12 = 0;
extern int thin6d_map_beambeam_3_ibtyp_1_2_( double *coord, double *argf, double *argi ) {
  double x = coord[0], y = coord[1];
  double xp = coord[2], yp = coord[3];
  double RatioPtoPj = coord[4];
  double crxbj = coord[14], crzbj = coord[15];
  double cbxbj = coord[16], cbzbj = coord[17];
  double xbbj = coord[18], zbbj = coord[19]; 
  double crkvebj = coord[22], cikvebj = coord[23];
  double rkbj = coord[25];

  double HorBeamBeamSeparation = argf[0], VerBeamBeamSeparation = argf[1];
  double PhysicalLengthOfBlock = argf[2];
  int SwitchToLinearCoupling = (int)argf[3];
  double ClosedOrbitBeamX = argf[4], ClosedOrbitBeamY = argf[5], ClosedOrbitBeamSigma = argf[6], ClosedOrbitBeamPx = argf[7], ClosedOrbitBeamPy = argf[8], ClosedOrbitBeamDelta = argf[9];
  double SquareOfSigmaNX = argf[20], SquareOfSigmaNY = argf[21];
  double BeamOffsetX = argf[10], BeamOffsetY = argf[11], BeamOffsetSigma = argf[12], BeamOffsetPx = argf[13], BeamOffsetPy = argf[14], BeamOffsetDelta = argf[15];
  double bbcu11 = argf[16], bbcu12 = argf[17];
  double SigmaNqX = argf[18], SigmaNqY = argf[19];

  double rho2bj, tkbj, cccc, r2bj, rbj, xrbj, zrbj;
  double SquareRootOfPi = sqrt(Pi);

  tkbj = ( crkvebj*crkvebj / SquareOfSigmaNX + cikvebj*cikvebj / SquareOfSigmaNY ) * 0.5;
  if( SwitchToLinearCoupling == 0 )
  {
    coord[2] = xp + RatioPtoPj * (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) *sign( 1.0, crkvebj ) - BeamOffsetPx );
    coord[3] = yp + RatioPtoPj * (( rkbj * ( crxbj - exp_rn( -1.0 * tkbj ) * cbxbj )) *sign( 1.0, cikvebj ) - BeamOffsetPy );
  }
  else
  {
    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu11 - (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu12;
    coord[2] = xp + RatioPtoPj * cccc;

    cccc = (( rkbj * ( crzbj - exp_rn( -1.0 * tkbj ) * cbzbj )) * sign( 1.0, crkvebj ) - BeamOffsetPx ) * bbcu12 + (( rkbj * ( crxbj - exp_rn(-1.0 * tkbj ) * cbxbj )) * sign( 1.0, cikvebj ) - BeamOffsetPy ) * bbcu11;
    coord[3] = yp + RatioPtoPj * cccc;
  }

  if( cntbb3ib12++ == 0 ) printf("beam beam 3 type 1 2\n");

  return 1;
}
