#include "hmacro.h"
#include <math.h>
#include <stdio.h>

#ifndef FLOAT
#define FLOAT double
#endif

#ifndef INT
#define INT int
#endif

// void print_var(INT [], FLOAT [], INT [], FLOAT [], INT);

inline void rf_cavity_calc(INT pfstart, FLOAT px, FLOAT py, FLOAT ps, FLOAT ds, FLOAT E0, FLOAT p0, FLOAT m0, FLOAT RatioPtoPj, FLOAT RatioDeltaPtoPj1, FLOAT MomentumOfParticle, FLOAT EnergyOfParticle, FLOAT RatioBetaToBetaj, FLOAT MomentumOfParticle0, FLOAT dppoff, FLOAT ElementType, FLOAT FirstAdditionalDatum, FLOAT FrequencyOfCavity, FLOAT LagPhaseOfCavity, FLOAT VoltageOfCavity, FLOAT RFFrequencyOfCavity, FLOAT PathLengthOffset, FLOAT partf[]){
  if( abs( dppoff ) > OnePoweredToMinus38 ) ds  = ds - PathLengthOffset;

    if( ElementType == 12 )
        EnergyOfParticle += FirstAdditionalDatum * sin( FrequencyOfCavity * ds + LagPhaseOfCavity );
    else
        EnergyOfParticle += VoltageOfCavity * sin( RFFrequencyOfCavity * ds );

    MomentumOfParticle = sqrt( EnergyOfParticle*EnergyOfParticle - m0*m0 );
    RatioBetaToBetaj = ( EnergyOfParticle * p0 ) / ( E0 * MomentumOfParticle );
    ps = ( MomentumOfParticle - p0 ) / p0;
    RatioPtoPj = 1.0 / ( 1.0 + ps );
    RatioDeltaPtoPj1 = ( ps * OnePoweredTo3 ) * RatioPtoPj;
    px = ( MomentumOfParticle0 / MomentumOfParticle ) * px;
    py = ( MomentumOfParticle0 / MomentumOfParticle ) * py;

    SETCOORDF(partf,ps,ps);
    SETCOORDF(partf,px,px);
    SETCOORDF(partf,py,py);
}

INT rf_cavity_map(INT elemi[], FLOAT elemf[], INT elemid, INT parti[], FLOAT partf[], INT partid, INT partn){
    FLOAT RatioPtoPj, RatioDeltaPtoPj1, EnergyOfParticle, MomentumOfParticle, RatioBetaToBetaj, MomentumOfParticle0;
    ELEMINIT;
    INITPARTF;

    GETATTRF(rf_cavity,dppoff);
    GETATTRF(rf_cavity,ElementType);
    GETATTRF(rf_cavity,FirstAdditionalDatum);
    GETATTRF(rf_cavity,FrequencyOfCavity);
    GETATTRF(rf_cavity,LagPhaseOfCavity);
    GETATTRF(rf_cavity,VoltageOfCavity);
    GETATTRF(rf_cavity,RFFrequencyOfCavity);
    GETATTRF(rf_cavity,PathLengthOffset);

    GETCOORDF(partf,px);
    GETCOORDF(partf,py);
    GETCOORDF(partf,ps);
    GETCOORDF(partf,ds);
    GETCOORDF(partf,E0);
    GETCOORDF(partf,p0);
    GETCOORDF(partf,m0);

    RatioPtoPj = One / ( One + ps );
    RatioDeltaPtoPj1 = ( ps * OnePoweredTo3 ) * RatioPtoPj;
    MomentumOfParticle = p0 * ( One + ps );
    EnergyOfParticle = sqrt( MomentumOfParticle * MomentumOfParticle + m0 * m0 );
    RatioBetaToBetaj = ( EnergyOfParticle * p0 ) / ( E0 * MomentumOfParticle );
    MomentumOfParticle0 = MomentumOfParticle;

    rf_cavity_calc(pfstart, px, py, ps, ds, E0, p0, m0, RatioPtoPj, RatioDeltaPtoPj1, MomentumOfParticle, EnergyOfParticle, RatioBetaToBetaj, MomentumOfParticle0, dppoff, ElementType, FirstAdditionalDatum, FrequencyOfCavity, LagPhaseOfCavity, VoltageOfCavity, RFFrequencyOfCavity, PathLengthOffset, GETPARTF(partid));

    // print_var(elemi, elemf, parti, partf, rot2d_TYPE);
    return 1;
}