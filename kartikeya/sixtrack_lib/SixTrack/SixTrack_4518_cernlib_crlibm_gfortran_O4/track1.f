      subroutine trauthin(nthinerr)
!--------------------------------------------------------------------------
!
!  TRACK THIN LENS PART
!
!
!  F. SCHMIDT
!
!
!  CHANGES FOR COLLIMATION MADE BY G. ROBERT-DEMOLAIZE, October 29th, 2004
!--------------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,ix,j,jb,jj,jx,kpz,kzz,napx0,nbeaux,nmz,nthinerr
      double precision benkcc,cbxb,cbzb,cikveb,crkveb,crxb,crzb,r0,r000,&
     &r0a,r2b,rb,rho2b,rkb,tkb,xbb,xrb,zbb,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension nbeaux(nbb)
      save
!-----------------------------------------------------------------------
      do 5 i=1,npart
        nlostp(i)=i
   5  continue
      do 10 i=1,nblz
        ktrack(i)=0
        strack(i)=zero
        strackc(i)=zero
        stracks(i)=zero
   10 continue
!--beam-beam element
      if(nbeam.ge.1) then
        do 15 i=1,nbb
          nbeaux(i)=0
   15   continue
        do i=1,iu
          ix=ic(i)
          if(ix.gt.nblo) then
            ix=ix-nblo
!hr03       if(kz(ix).eq.20.and.parbe(ix,2).eq.0) then
            if(kz(ix).eq.20.and.parbe(ix,2).eq.0d0) then                 !hr03
!--round beam
              if(sigman(1,imbb(i)).eq.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.2.or.nbeaux(imbb(i)).eq.3) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=1
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                endif
              endif
!--elliptic beam x>z
              if(sigman(1,imbb(i)).gt.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.1.or.nbeaux(imbb(i)).eq.3) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=2
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                  sigman2(2,imbb(i))=sigman(2,imbb(i))**2
                  sigmanq(1,imbb(i))=sigman(1,imbb(i))/sigman(2,imbb(i))
                  sigmanq(2,imbb(i))=sigman(2,imbb(i))/sigman(1,imbb(i))
                endif
              endif
!--elliptic beam z>x
              if(sigman(1,imbb(i)).lt.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.1.or.nbeaux(imbb(i)).eq.2) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=3
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                  sigman2(2,imbb(i))=sigman(2,imbb(i))**2
                  sigmanq(1,imbb(i))=sigman(1,imbb(i))/sigman(2,imbb(i))
                  sigmanq(2,imbb(i))=sigman(2,imbb(i))/sigman(1,imbb(i))
                endif
              endif
            endif
          endif
        enddo
      endif
      do 290 i=1,iu
        if(mout2.eq.1.and.i.eq.1) call write4
        ix=ic(i)
        if(ix.gt.nblo) goto 30
        ktrack(i)=1
        do 20 jb=1,mel(ix)
          jx=mtyp(ix,jb)
          strack(i)=strack(i)+el(jx)
   20   continue
        if(abs(strack(i)).le.pieni) ktrack(i)=31
        goto 290
   30   ix=ix-nblo
        kpz=abs(kp(ix))
        if(kpz.eq.6) then
          ktrack(i)=2
          goto 290
        endif
   40   kzz=kz(ix)
        if(kzz.eq.0) then
          ktrack(i)=31
          goto 290
        endif
!--beam-beam element
!hr08   if(kzz.eq.20.and.nbeam.ge.1.and.parbe(ix,2).eq.0) then
        if(kzz.eq.20.and.nbeam.ge.1.and.parbe(ix,2).eq.0d0) then         !hr08
          strack(i)=crad*ptnfac(ix)
          if(abs(strack(i)).le.pieni) then
            ktrack(i)=31
            goto 290
          endif
          if(nbeaux(imbb(i)).eq.1) then
            ktrack(i)=41
            if(ibeco.eq.1) then
              do 42 j=1,napx
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 42
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
!hr03           beamoff(4,imbb(i))=strack(i)*crkveb(j)/rho2b(j)*        &
!hr03           beamoff(4,imbb(i))=strack(i)*crkveb(j)/rho2b(j)*        &
!hr03&(one-exp_rn(-tkb(j)))
                beamoff(4,imbb(i))=((strack(i)*crkveb(j))/rho2b(j))*    &!hr03
     &(one-exp_rn(-1d0*tkb(j)))                                          !hr03
!hr03           beamoff(5,imbb(i))=strack(i)*cikveb(j)/rho2b(j)*        &
!hr03           beamoff(5,imbb(i))=strack(i)*cikveb(j)/rho2b(j)*        &
!hr03&(one-exp_rn(-tkb(j)))
                beamoff(5,imbb(i))=((strack(i)*cikveb(j))/rho2b(j))*    &!hr03
     &(one-exp_rn(-1d0*tkb(j)))                                          !hr03
   42         continue
            endif
          endif
          if(nbeaux(imbb(i)).eq.2) then
            ktrack(i)=42
            if(ibeco.eq.1) then
            if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            endif
            endif
          endif
          if(nbeaux(imbb(i)).eq.3) then
            ktrack(i)=43
            if(ibeco.eq.1) then
            if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            endif
            endif
          endif
          goto 290
!--Hirata's 6D beam-beam kick
!hr03   else if(kzz.eq.20.and.parbe(ix,2).gt.0) then
        else if(kzz.eq.20.and.parbe(ix,2).gt.0d0) then                   !hr03
          ktrack(i)=44
!hr03     parbe(ix,4)=-crad*ptnfac(ix)*half*c1m6
          parbe(ix,4)=(((-1d0*crad)*ptnfac(ix))*half)*c1m6               !hr03
          if(ibeco.eq.1) then
            track6d(1,1)=ed(ix)*c1m3
            track6d(2,1)=zero
            track6d(3,1)=ek(ix)*c1m3
            track6d(4,1)=zero
            track6d(5,1)=zero
            track6d(6,1)=zero
            napx0=napx
            napx=1
            call beamint(napx,track6d,parbe,sigz,bbcu,imbb(i),ix,ibtyp, &
     &ibbc)
            beamoff(1,imbb(i))=track6d(1,1)*c1e3
            beamoff(2,imbb(i))=track6d(3,1)*c1e3
            beamoff(4,imbb(i))=track6d(2,1)*c1e3
            beamoff(5,imbb(i))=track6d(4,1)*c1e3
            beamoff(6,imbb(i))=track6d(6,1)
            napx=napx0
          endif
          goto 290
        endif
        if(kzz.eq.15) then
          ktrack(i)=45
          goto 290
        endif
        if(kzz.eq.16) then
          ktrack(i)=51
          goto 290
        else if(kzz.eq.-16) then
          ktrack(i)=52
          goto 290
        endif
        if(kzz.eq.23) then
          ktrack(i)=53
          goto 290
        else if(kzz.eq.-23) then
          ktrack(i)=54
          goto 290
        endif
! JBG RF CC Multipoles
        if(kzz.eq.26) then
          ktrack(i)=57
          goto 290
        else if(kzz.eq.-26) then
          ktrack(i)=58
          goto 290
        endif
        if(kzz.eq.27) then
          ktrack(i)=59
          goto 290
        else if(kzz.eq.-27) then
          ktrack(i)=60
          goto 290
        endif
        if(kzz.eq.28) then
          ktrack(i)=61
          goto 290
        else if(kzz.eq.-28) then
          ktrack(i)=62
          goto 290
        endif
        if(kzz.eq.22) then
          ktrack(i)=3
          goto 290
        endif
        if(mout2.eq.1.and.icextal(i).ne.0) then
          write(27,'(a16,2x,1p,2d14.6,d17.9)') bez(ix),extalign(i,1),   &
     &extalign(i,2),extalign(i,3)
        endif
        if(kzz.lt.0) goto 180
        goto(50,60,70,80,90,100,110,120,130,140,150,290,290,290,        &
     &       290,290,290,290,290,290,290,290,290,145,146),kzz
        ktrack(i)=31
        goto 290
   50   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=11
        strack(i)=smiv(1,i)*c1e3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   60   if(abs(smiv(1,i)).le.pieni.and.abs(ramp(ix)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=12
        strack(i)=smiv(1,i)
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   70   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=13
        strack(i)=smiv(1,i)*c1m3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   80   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=14
        strack(i)=smiv(1,i)*c1m6
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   90   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=15
        strack(i)=smiv(1,i)*c1m9
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  100   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=16
        strack(i)=smiv(1,i)*c1m12
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  110   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=17
        strack(i)=smiv(1,i)*c1m15
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  120   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=18
        strack(i)=smiv(1,i)*c1m18
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  130   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=19
        strack(i)=smiv(1,i)*c1m21
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  140   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=20
        strack(i)=smiv(1,i)*c1m24
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
!--DIPEDGE ELEMENT
  145   continue
        strack(i)=zero
        strackx(i)=ed(IX)*tiltc(i)
        stracks(i)=ed(IX)*tilts(i)
        strackz(i)=ek(IX)*tiltc(i)
        strackc(i)=ek(IX)*tilts(i)
        ktrack(i)=55
        goto 290
!--solenoid
  146   continue
        strack(i)=zero
        strackx(i)=ed(IX)
        strackz(i)=ek(IX)
        ktrack(i)=56
        goto 290
  150   r0=ek(ix)
        nmz=nmu(ix)
        if(abs(r0).le.pieni.or.nmz.eq.0) then
          if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).le.pieni) then
            ktrack(i)=31
          else if(abs(dki(ix,1)).gt.pieni.and.abs(dki(ix,2)).le.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=33
              strack(i)=dki(ix,1)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=35
              strack(i)=dki(ix,1)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          else if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).gt.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=37
              strack(i)=dki(ix,2)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=39
              strack(i)=dki(ix,2)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          endif
        else
          if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).le.pieni) then
            ktrack(i)=32
          else if(abs(dki(ix,1)).gt.pieni.and.abs(dki(ix,2)).le.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=34
              strack(i)=dki(ix,1)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=36
              strack(i)=dki(ix,1)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          else if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).gt.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=38
              strack(i)=dki(ix,2)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=40
              strack(i)=dki(ix,2)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          endif
        endif
        if(abs(r0).le.pieni.or.nmz.eq.0) goto 290
        if(mout2.eq.1) then
          benkcc=ed(ix)*benkc(irm(ix))
          r0a=one
          r000=r0*r00(irm(ix))
          do 160 j=1,mmul
!hr01       fake(1,j)=bbiv(j,1,i)*r0a/benkcc
            fake(1,j)=(bbiv(j,1,i)*r0a)/benkcc                           !hr01
!hr01       fake(2,j)=aaiv(j,1,i)*r0a/benkcc
            fake(2,j)=(aaiv(j,1,i)*r0a)/benkcc                           !hr01
  160     r0a=r0a*r000
          write(9,'(a16)') bez(ix)
          write(9,'(1p,3d23.15)') (fake(1,j), j=1,3)
          write(9,'(1p,3d23.15)') (fake(1,j), j=4,6)
          write(9,'(1p,3d23.15)') (fake(1,j), j=7,9)
          write(9,'(1p,3d23.15)') (fake(1,j), j=10,12)
          write(9,'(1p,3d23.15)') (fake(1,j), j=13,15)
          write(9,'(1p,3d23.15)') (fake(1,j), j=16,18)
          write(9,'(1p,2d23.15)') (fake(1,j), j=19,20)
          write(9,'(1p,3d23.15)') (fake(2,j), j=1,3)
          write(9,'(1p,3d23.15)') (fake(2,j), j=4,6)
          write(9,'(1p,3d23.15)') (fake(2,j), j=7,9)
          write(9,'(1p,3d23.15)') (fake(2,j), j=10,12)
          write(9,'(1p,3d23.15)') (fake(2,j), j=13,15)
          write(9,'(1p,3d23.15)') (fake(2,j), j=16,18)
          write(9,'(1p,2d23.15)') (fake(2,j), j=19,20)
          do 170 j=1,20
            fake(1,j)=zero
  170     fake(2,j)=zero
        endif
        goto 290
  180   kzz=-kzz
        goto(190,200,210,220,230,240,250,260,270,280),kzz
        ktrack(i)=31
        goto 290
  190   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=21
        strack(i)=smiv(1,i)*c1e3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  200   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=22
        strack(i)=smiv(1,i)
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  210   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=23
        strack(i)=smiv(1,i)*c1m3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  220   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=24
        strack(i)=smiv(1,i)*c1m6
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  230   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=25
        strack(i)=smiv(1,i)*c1m9
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  240   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=26
        strack(i)=smiv(1,i)*c1m12
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  250   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=27
        strack(i)=smiv(1,i)*c1m15
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  260   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=28
        strack(i)=smiv(1,i)*c1m18
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  270   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=29
        strack(i)=smiv(1,i)*c1m21
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  280   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=30
        strack(i)=smiv(1,i)*c1m24
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
  290 continue
      do 300 j=1,napx
!hr01   dpsv1(j)=dpsv(j)*c1e3/(one+dpsv(j))
        dpsv1(j)=(dpsv(j)*c1e3)/(one+dpsv(j))                            !hr01
  300 continue
      nwri=nwr(3)
!hr01 if(nwri.eq.0) nwri=numl+numlr+1
      if(nwri.eq.0) nwri=(numl+numlr)+1                                  !hr01
      if(idp.eq.0.or.ition.eq.0) then
        call thin4d(nthinerr)
      else
!hr01   hsy(3)=c1m3*hsy(3)*ition
        hsy(3)=(c1m3*hsy(3))*dble(ition)                                 !hr01
        do 310 jj=1,nele
!hr01     if(kz(jj).eq.12) hsyc(jj)=c1m3*hsyc(jj)*itionc(jj)
          if(kz(jj).eq.12) hsyc(jj)=(c1m3*hsyc(jj))*dble(itionc(jj))     !hr01
  310   continue
        if(abs(phas).ge.pieni) then
          call thin6dua(nthinerr)
        else
          call thin6d(nthinerr)
        endif
      endif
      return
      end
      subroutine thin4d(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THIN LENS 4D
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
!-----------------------------------------------------------------------
!  EXACT DRIFT
!-----------------------------------------------------------------------
      double precision pz
!-----------------------------------------------------------------------
!  COMMON FOR EXACT VERSION
!-----------------------------------------------------------------------
      integer iexact
      common/exact/iexact
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,irrtr,ix,j,k,kpz,n,nmz,nthinerr
      double precision cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,crkveuk,&
     &crxb,crzb,dpsv3,pux,r0,r2b,rb,rho2b,rkb,stracki,tkb,xbb,xlvj,xrb, &
     &yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision e0fo,e0o,xv1j,xv2j
      double precision acdipamp, qd, acphase, acdipamp2,                &
     &acdipamp1, crabamp, crabfreq
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f,coord(1000),argf(1000),argi(1000)
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
!-----------------------------------------------------------------------
      nthinerr=0
      do 640 n=1,numl
        numx=n-1
        if(irip.eq.1) call ripple(n)
        if(mod(numx,nwri).eq.0) call writebin(nthinerr)
        if(nthinerr.ne.0) return
        do 630 i=1,iu
          ix=ic(i)-nblo
!---------count:43
          goto(10,630,740,630,630,630,630,630,630,630,30,50,70,90,110,  &
     &130,150,170,190,210,420,440,460,480,500,520,540,560,580,600,      &
     &620,390,230,250,270,290,310,330,350,370,680,700,720,630,748,      &
     &630,630,630,630,630,745,746,751,752,753,754),ktrack(i)
          goto 630
   10     stracki=strack(i)
          if(iexact.eq.0) then
            do j=1,napx
              xv(1,j)=xv(1,j)+stracki*yv(1,j)
              xv(2,j)=xv(2,j)+stracki*yv(2,j)
            enddo
          else
            do j=1,napx
              xv(1,j)=xv(1,j)*c1m3
              xv(2,j)=xv(2,j)*c1m3
              yv(1,j)=yv(1,j)*c1m3
              yv(2,j)=yv(2,j)*c1m3
              pz=sqrt(one-(yv(1,j)**2+yv(2,j)**2))
              xv(1,j)=xv(1,j)+stracki*(yv(1,j)/pz)
              xv(2,j)=xv(2,j)+stracki*(yv(2,j)/pz)
              xv(1,j)=xv(1,j)*c1e3
              xv(2,j)=xv(2,j)*c1e3
              yv(1,j)=yv(1,j)*c1e3
              yv(2,j)=yv(2,j)*c1e3
            enddo
          endif
          goto 630
!--HORIZONTAL DIPOLE
   30     do 40 j=1,napx
            yv(1,j)=yv(1,j)+strackc(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+stracks(i)*oidpsv(j)
   40     continue
          goto 620
!--NORMAL QUADRUPOLE
   50     do 60 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   60     continue
          goto 620
!--NORMAL SEXTUPOLE
   70     do 80 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   80     continue
          goto 620
!--NORMAL OCTUPOLE
   90     do 100 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  100     continue
          goto 620
!--NORMAL DECAPOLE
  110     do 120 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  120     continue
          goto 620
!--NORMAL DODECAPOLE
  130     do 140 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  140     continue
          goto 620
!--NORMAL 14-POLE
  150     do 160 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  160     continue
          goto 620
!--NORMAL 16-POLE
  170     do 180 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  180     continue
          goto 620
!--NORMAL 18-POLE
  190     do 200 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  200     continue
          goto 620
!--NORMAL 20-POLE
  210     do 220 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  220     continue
          goto 620
  230     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,1)
          do 240 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_purehor_nzapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  240     continue
          goto 620
  250     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,1)
          do 260 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_hor_nzapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  260     continue
          goto 390
  270     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=dki(ix,2)
          do 280 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_purehor_zapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  280     continue
          goto 620
  290     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=dki(ix,2)
          do 300 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_hor_zapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  300     continue
          goto 390
  310     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 320 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_purever_nzapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  320     continue
          goto 620
  330     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 340 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_ver_nzapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  340     continue
          goto 390
  350     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=dki(ix,2)
          do 360 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_purever_zapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  360     continue
          goto 620
  370     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=dki(ix,2)
          do 380 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin4d_map_multipole_ver_zapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  380     continue
  390     r0=ek(ix)
          nmz=nmu(ix)
          if(nmz.ge.2) then
            do 410 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 400 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  400           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  410       continue
          else
            do 415 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  415       continue
          endif
          goto 620
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  420     do 430 j=1,napx
            yv(1,j)=yv(1,j)-stracks(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+strackc(i)*oidpsv(j)
  430     continue
          goto 620
!--SKEW QUADRUPOLE
  440     do 450 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  450     continue
          goto 620
!--SKEW SEXTUPOLE
  460     do 470 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  470     continue
          goto 620
!--SKEW OCTUPOLE
  480     do 490 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  490     continue
          goto 620
!--SKEW DECAPOLE
  500     do 510 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  510     continue
          goto 620
!--SKEW DODECAPOLE
  520     do 530 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  530     continue
          goto 620
!--SKEW 14-POLE
  540     do 550 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  550     continue
          goto 620
!--SKEW 16-POLE
  560     do 570 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  570     continue
          goto 620
!--SKEW 18-POLE
  580     do 590 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  590     continue
          goto 620
!--SKEW 20-POLE
  600     do 610 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  610     continue
          goto 620
  680     continue
          do 690 j=1,napx
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 690
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
            if(ibbc.eq.0) then
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))
          yv(1,j)=yv(1,j)+oidpsv(j)*(((strack(i)*crkveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))                      !hr03
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))
          yv(2,j)=yv(2,j)+oidpsv(j)*(((strack(i)*cikveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))                      !hr03
            else
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
              yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
              yv(2,j)=yv(2,j)+oidpsv(j)*cccc
            endif
  690     continue
          goto 620
  700     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 620
  720     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 620
  740     continue
          irrtr=imtr(ix)
          irrtr=imtr(ix)
          argf(1)=idz(1)
          argf(2)=idz(2)
          argf(3)=cotr(irrtr,1)
          argf(4)=cotr(irrtr,2)
          argf(5)=cotr(irrtr,3)
          argf(6)=cotr(irrtr,4)
          argf(7)=cotr(irrtr,5)
          argf(8)=cotr(irrtr,6)
          argf(9)=rrtr(irrtr,5,1)
          argf(10)=rrtr(irrtr,5,2)
          argf(11)=rrtr(irrtr,5,3)
          argf(12)=rrtr(irrtr,5,4)
          argf(13)=rrtr(irrtr,5,6)
          argf(14)=rrtr(irrtr,1,1)
          argf(15)=rrtr(irrtr,1,2)
          argf(16)=rrtr(irrtr,1,6)
          argf(17)=rrtr(irrtr,2,1)
          argf(18)=rrtr(irrtr,2,2)
          argf(19)=rrtr(irrtr,2,6)
          argf(20)=rrtr(irrtr,3,3)
          argf(21)=rrtr(irrtr,3,4)
          argf(22)=rrtr(irrtr,3,6)
          argf(23)=rrtr(irrtr,4,3)
          argf(24)=rrtr(irrtr,4,4)
          argf(25)=rrtr(irrtr,4,6)          
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(9)=dpsv(j)
            call thin4d_map_accelerating_cavity2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 620
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 620
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 620
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 620
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 620
!--DIPEDGE ELEMENT
  753      continue
         do j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackx(i)*crkve-                &
     &stracks(i)*cikve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackz(i)*cikve+                &
     &strackc(i)*crkve)
         enddo
          goto 620
!--solenoid
  754      continue
          argf(1)=strackx(i)
          argf(2)=strackz(i)
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin4d_map_solenoid(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
         enddo
          goto 620
 
 
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      do 750 j=1, napx
 
      xv(1,j) = xv(1,j) * c1m3
      xv(2,j) = xv(2,j) * c1m3
      yv(1,j) = yv(1,j) * c1m3
      yv(2,j) = yv(2,j) * c1m3
 
!      write(*,*) 'Start: ',j,xv(1,j),xv(2,j),yv(1,j),
!     &yv(2,j)
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) -                                               &!hr03
     &((embl*0.5d0)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) -                                               &!hr03
     &((embl*0.5d0)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
 
!     call tilt(tx,ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(tx)*yv(2,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(tx))*yv(2,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(1,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-tx)                                                   !hr03
!+if crlibm
!hhr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
      xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(1,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(ty)*yv(1,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(ty))*yv(1,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
      xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
 
!     call drift(lin)
 
!hr03 xv(1,j) = xv(1,j) + lin*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) + (lin*yv(1,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) + lin*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) + (lin*yv(2,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
!      call kick(l,cur,lin,rx,ry,chi)
 
      xi = xv(1,j)-rx
      yi = xv(2,j)-ry
!hr03 yv(1,j) = yv(1,j)-c1m7*cur/chi*xi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(1,j) = yv(1,j)-((((c1m7*cur)/chi)*xi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
!GRD FOR CONSISTENSY
!hr03 yv(2,j) = yv(2,j)-c1m7*cur/chi*yi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(2,j) = yv(2,j)-((((c1m7*cur)/chi)*yi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
 
!     call drift(leff-lin)
 
!hr03 xv(1,j) = xv(1,j) + (leff-lin)*yv(1,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(1,j) = xv(1,j) + ((leff-lin)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
!hr03 xv(2,j) = xv(2,j) + (leff-lin)*yv(2,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(2,j) = xv(2,j) + ((leff-lin)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
 
!     call invtilt(tx,ty)
 
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(-ty)*yv(1,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(-ty))*yv(1,j))/               &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))+ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(-ty)-sin_rn(-ty)*tan_rn(atan_rn(yv(2,j)/&
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
      xv(2,j) = xv(2,j)*                                                &!hr03
     &(cos_rn(-1d0*ty)-sin_rn(-1d0*ty)*tan_rn(atan_rn(yv(2,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(-tx)*yv(2,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(-1d0*tx))*yv(2,j))/           &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/cos_rn(atan_rn(yv(1,j)/        &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!+if crlibm
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(-tx)-sin_rn(-tx)*tan_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
      xv(1,j) = xv(1,j)*                                                &!hr03
     &(cos_rn(-1d0*tx)-sin_rn(-1d0*tx)*tan_rn(atan_rn(yv(1,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                       !hr03
     &sin_rn(atan_rn(yv(1,j)/                                            !hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
 
!     call shift(-embl*tan(tx),-embl*tan(ty)/cos(tx))
 
      xv(1,j) = xv(1,j) + embl*tan_rn(tx)
!hr03 xv(2,j) = xv(2,j) + embl*tan_rn(ty)/cos_rn(tx)
      xv(2,j) = xv(2,j) + (embl*tan_rn(ty))/cos_rn(tx)                   !hr03
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) - ((embl*0.5d0)*yv(1,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) - ((embl*0.5d0)*yv(2,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
      xv(1,j) = xv(1,j) * c1e3
      xv(2,j) = xv(2,j) * c1e3
      yv(1,j) = yv(1,j) * c1e3
      yv(2,j) = yv(2,j) * c1e3
 
!      write(*,*) 'End: ',j,xv(1,j),xv(2,j),yv(1,j),                       &
!     &yv(2,j)
 
!-----------------------------------------------------------------------
 
  750     continue
          goto 620
 
!----------------------------
 
  620     continue
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  630   continue
        call lostpart(nthinerr)
        if(nthinerr.ne.0) return
        if(ntwin.ne.2) call dist1
        if(mod(n,nwr(4)).eq.0) call write6(n)
  640 continue
      return
      end
      subroutine thin6d(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THIN LENS 6D
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
!-----------------------------------------------------------------------
!  EXACT DRIFT
!-----------------------------------------------------------------------
      double precision pz
!-----------------------------------------------------------------------
!  COMMON FOR EXACT VERSION
!-----------------------------------------------------------------------
      integer iexact
      common/exact/iexact
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,irrtr,ix,j,k,kpz,n,nmz,nthinerr
      double precision c5m4,cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,   &
     &crkveuk,crxb,crzb,dpsv3,pux,r0,r2b,rb,rho2b,rkb,stracki,tkb,xbb,  &
     &xlvj,xrb,yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision e0fo,e0o,xv1j,xv2j
      double precision acdipamp, qd, acphase,acdipamp2,acdipamp1,       &
     &crabamp,crabfreq,                                                 &
     &crabamp2,crabamp3,crabamp4
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      double precision coord(1000),argf(1000),argi(1000)
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
!-----------------------------------------------------------------------
      c5m4=5.0d-4
      nthinerr=0
      do 660 n=1,numl
       numx=n-1
        if(irip.eq.1) call ripple(n)
        if(mod(numx,nwri).eq.0) call writebin(nthinerr)
        if(nthinerr.ne.0) return
      do 650 i=1,iu
          ix=ic(i)-nblo
!---------count:44
! JBG RF CC Multipoles
! JBG adding CC multipoles elements in tracking. ONLY in thin6d!!!
! JBG 755 -RF quad, 756 RF Sext, 757 RF Oct
          goto(10,30,740,650,650,650,650,650,650,650,50,70,90,110,130,  &
     &150,170,190,210,230,440,460,480,500,520,540,560,580,600,620,      &
     &640,410,250,270,290,310,330,350,370,390,680,700,720,730,748,      &
     &650,650,650,650,650,745,746,751,752,753,754,755,758,756,759,757,  &
     &760),ktrack(i)
          goto 650
   10     stracki=strack(i)
          if(iexact.eq.0) then
            do j=1,napx
              xv(1,j)=xv(1,j)+stracki*yv(1,j)
              xv(2,j)=xv(2,j)+stracki*yv(2,j)
!hr03       sigmv(j)=sigmv(j)+stracki*(c1e3-rvv(j)*(c1e3+(yv(1,j)       &
!hr03&*yv(1,j)+yv(2,j)*yv(2,j))*c5m4))
            sigmv(j)=sigmv(j)+stracki*(c1e3-rvv(j)*(c1e3+(yv(1,j)       &!hr03
     &**2+yv(2,j)**2)*c5m4))                                             !hr03
            enddo
          else
!-----------------------------------------------------------------------
!  EXACT DRIFT
!-----------------------------------------------------------------------
          argf(1)=strack(i)
            do j=1,napx
              coord(1)=xv(1,j)
              coord(2)=xv(2,j)
              coord(3)=yv(1,j)
              coord(4)=yv(2,j)
              coord(6)=sigmv(j)
              coord(13)=rvv(j)
              call thin6d_map_exact_drift(coord,argf,argi)
              xv(1,j)=coord(1)
              xv(2,j)=coord(2)
              yv(1,j)=coord(3)
              yv(2,j)=coord(4)
              sigmv(j)=coord(6)
            enddo
          endif
          goto 650
   30     argf(1)=e0
          argf(2)=e0f
          argf(3)=pma
          argf(4)=dppoff
          argf(5)=kz(ix)
          argf(6)=ed(ix)
          argf(7)=hsyc(ix)
          argf(8)=phasc(ix)
          argf(9)=hsy(1)
          argf(10)=hsy(3)
          argf(11)=sigmoff(i)
          do 40 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_accelarating_cavity(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
 40       continue
          if(n.eq.1) write(98,'(1p,6(2x,e25.18))')                      &
     &(xv(1,j),yv(1,j),xv(2,j),yv(2,j),sigmv(j),dpsv(j),j=1,napx)
          goto 640
!--HORIZONTAL DIPOLE
   50     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          do 60 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_horizontal_dipole(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
   60     continue
          goto 640
!--NORMAL QUADRUPOLE
   70     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 80 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_quadrupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                                  !hr02
   80     continue
          goto 640
  755     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles
          pi=4d0*atan_rn(1d0)
          crabamp2 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
!          write(*,*) ''
!          write(*,*) '-------------------'
!	  write(*,*) 'CRAB AMP 2', crabamp2
!	  write(*,*) 'FREQ',  crabfreq
!	  write(*,*) 'PHASE', crabph2(ix)
!          write(*,*) '-------------------'

          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp2
          argf(7)=crabph2(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
  758     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles 2
          pi=4d0*atan_rn(1d0)
          crabamp2 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp2
          argf(7)=crabph2(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order2_2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
!--NORMAL SEXTUPOLE
   90     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 100 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_sextupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                              
  100     continue
          goto 640
  756     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles
          pi=4d0*atan_rn(1d0)
          crabamp3 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
!          write(*,*) ''
!          write(*,*) '-------------------'
!	  write(*,*) 'CRAB AMP 3', crabamp3
!	  write(*,*) 'FREQ',  crabfreq
!	  write(*,*) 'PHASE', crabph3(ix)
!          write(*,*) '-------------------'
          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp3
          argf(7)=crabph3(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order3(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
  759     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles 2
          pi=4d0*atan_rn(1d0)
          crabamp3 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp3
          argf(7)=crabph3(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order3_2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
!--NORMAL OCTUPOLE
  110     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 120 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_octupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                   
  120     continue
          goto 640
  757     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles
          pi=4d0*atan_rn(1d0)
          crabamp4 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
          ! Sixtrack uses mm and mrad, input m^{-n+1}
!          write(*,*) ''
!          write(*,*) '-------------------'
!	  write(*,*) 'CRAB AMP 4', crabamp4
!	  write(*,*) 'FREQ',  crabfreq
!	  write(*,*) 'PHASE', crabph4(ix)
!          write(*,*) '-------------------'
          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp4
          argf(7)=crabph4(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order4(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
  760     continue
          xory=1
! JBG RF CC Multipoles
! JBG RF CC Multipoles
          pi=4d0*atan_rn(1d0)
          crabamp4 = ed(ix)!/(1+dpsv(j))
          crabfreq=ek(ix)*c1e3
          ! Sixtrack uses mm and mrad, input m^{-n+1}
          argf(1)=xsiv(1,i)
          argf(2)=zsiv(1,i)
          argf(3)=tiltc(i)
          argf(4)=tilts(i)
          argf(5)=crabfreq
          argf(6)=crabamp4
          argf(7)=crabph4(ix)
          argf(8)=e0
          argf(9)=e0f
          argf(10)=pma
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(11)=dpd(j)
            coord(12)=dpsq(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_jbgrfcc_multipoles_order4_2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            dpd(j)=coord(11)
            dpsq(j)=coord(12)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
                enddo
          goto 640
!--NORMAL DECAPOLE
  130     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 140 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_decapole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                       
  140     continue
          goto 640
!--NORMAL DODECAPOLE
  150     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 160 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_dodecapole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                    
  160     continue
          goto 640
!--NORMAL 14-POLE
  170     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 180 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_14pole(coord,argf,argi)
            yv(1,j)=coord(3)                       
            yv(2,j)=coord(4)                         
  180     continue
          goto 640
!--NORMAL 16-POLE
  190     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 200 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_16pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                                 
  200     continue
          goto 640
!--NORMAL 18-POLE
  210     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 220 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_18pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                                  
  220     continue
          goto 640
!--NORMAL 20-POLE
  230     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 240 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_normal_20pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)                                                 
  240     continue
          goto 640
  250     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,1)
          do 260 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_purehor_nzapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  260     continue
          goto 640
  270     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,1)
          do 280 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_hor_nzapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  280     continue
          goto 410
  290     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 300 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_purehor_zapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  300     continue
          goto 640
  310     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 320 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_hor_zapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  320     continue
          goto 410
  330     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 340 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_purever_nzapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  340     continue
          goto 640
  350     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 360 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_ver_nzapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  360     continue
          goto 410
  370     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 380 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_purever_zapprox(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  380     continue
          goto 640
  390     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=dki(ix,2)
          do 400 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            call thin6d_map_multipole_ver_zapprox_ho(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
  400     continue
  410     r0=ek(ix)
          nmz=nmu(ix)
          if(nmz.ge.2) then
            do 430 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 420 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  420           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  430       continue
          else
            do 435 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  435       continue
          endif
          goto 640
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  440     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          do 450 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_vertical_dipole(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
  450     continue
          goto 640
!--SKEW QUADRUPOLE
  460     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 470 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_quadrupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)  
  470     continue
          goto 640
!--SKEW SEXTUPOLE
  480     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 490 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_sextupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4) 
  490     continue
          goto 640
!--SKEW OCTUPOLE
  500     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 510 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_octupole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4) 
  510     continue
          goto 640
!--SKEW DECAPOLE
  520     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 530 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_decapole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)
  530     continue
          goto 640
!--SKEW DODECAPOLE
  540     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 550 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_dodecapole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4)
  550     continue
          goto 640
!--SKEW 14-POLE
  560     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 570 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_14pole(coord,argf,argi)
            yv(1,j)=coord(3)                       
            yv(2,j)=coord(4)
  570     continue
          goto 640
!--SKEW 16-POLE
  580     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 590 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_16pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4) 
  590     continue
          goto 640
!--SKEW 18-POLE
  600     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 610 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_18pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4) 
  610     continue
          goto 640
!--SKEW 20-POLE
  620     argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          do 630 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)        
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_skew_20pole(coord,argf,argi)
            yv(1,j)=coord(3)                          
            yv(2,j)=coord(4) 
  630     continue
  680     continue
          argf(1)=ed(ix)
          argf(2)=ek(ix)
          argf(3)=strack(i)
          argf(4)=ibbc
          argf(5)=clobeam(1,imbb(i))
          argf(6)=clobeam(2,imbb(i))
          argf(7)=clobeam(3,imbb(i))
          argf(8)=clobeam(4,imbb(i))
          argf(9)=clobeam(5,imbb(i))
          argf(10)=clobeam(6,imbb(i))
          argf(11)=beamoff(1,imbb(i))
          argf(12)=beamoff(2,imbb(i))
          argf(13)=beamoff(3,imbb(i))
          argf(14)=beamoff(4,imbb(i))
          argf(15)=beamoff(5,imbb(i))
          argf(16)=beamoff(6,imbb(i))
          argf(17)=bbcu(imbb(i),11)
          argf(18)=bbcu(imbb(i),12)
          argf(19)=sigmanq(1,imbb(i))
          argf(20)=sigmanq(2,imbb(i))
          argf(21)=sigman2(1,imbb(i))
          argf(22)=sigman2(2,imbb(i))
          do 690 j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_beambeam_type1(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4) 
  690     continue
          goto 640
  700     continue
          argf(1)=ed(ix)
          argf(2)=ek(ix)
          argf(3)=strack(i)
          argf(4)=ibbc
          argf(5)=clobeam(1,imbb(i))
          argf(6)=clobeam(2,imbb(i))
          argf(7)=clobeam(3,imbb(i))
          argf(8)=clobeam(4,imbb(i))
          argf(9)=clobeam(5,imbb(i))
          argf(10)=clobeam(6,imbb(i))
          argf(11)=beamoff(1,imbb(i))
          argf(12)=beamoff(2,imbb(i))
          argf(13)=beamoff(3,imbb(i))
          argf(14)=beamoff(4,imbb(i))
          argf(15)=beamoff(5,imbb(i))
          argf(16)=beamoff(6,imbb(i))
          argf(17)=bbcu(imbb(i),11)
          argf(18)=bbcu(imbb(i),12)
          argf(19)=sigmanq(1,imbb(i))
          argf(20)=sigmanq(2,imbb(i))
          argf(21)=sigman2(1,imbb(i))
          argf(22)=sigman2(2,imbb(i))
          argf(23)=napx
          argf(24)=ibtyp
            do j=1,napx
              coord(1)=xv(1,j)
              coord(2)=xv(2,j)
              coord(3)=yv(1,j)
              coord(4)=yv(2,j)
              coord(5)=oidpsv(j)
              coord(15)=crxb(j)
              coord(16)=crzb(j)
              coord(17)=cbxb(j)
              coord(18)=cbzb(j)
              call thin6d_map_beambeam_type2(coord,argf,argi)
              yv(1,j)=coord(3)
              yv(2,j)=coord(4) 
            enddo
          goto 640
  720     continue
          argf(1)=ed(ix)
          argf(2)=ek(ix)
          argf(3)=strack(i)
          argf(4)=ibbc
          argf(5)=clobeam(1,imbb(i))
          argf(6)=clobeam(2,imbb(i))
          argf(7)=clobeam(3,imbb(i))
          argf(8)=clobeam(4,imbb(i))
          argf(9)=clobeam(5,imbb(i))
          argf(10)=clobeam(6,imbb(i))
          argf(11)=beamoff(1,imbb(i))
          argf(12)=beamoff(2,imbb(i))
          argf(13)=beamoff(3,imbb(i))
          argf(14)=beamoff(4,imbb(i))
          argf(15)=beamoff(5,imbb(i))
          argf(16)=beamoff(6,imbb(i))
          argf(17)=bbcu(imbb(i),11)
          argf(18)=bbcu(imbb(i),12)
          argf(19)=sigmanq(1,imbb(i))
          argf(20)=sigmanq(2,imbb(i))
          argf(21)=sigman2(1,imbb(i))
          argf(22)=sigman2(2,imbb(i))
          argf(23)=napx
          argf(24)=ibtyp
            do j=1,napx
              coord(1)=xv(1,j)
              coord(2)=xv(2,j)
              coord(3)=yv(1,j)
              coord(4)=yv(2,j)
              coord(5)=oidpsv(j)
              coord(15)=crxb(j)
              coord(16)=crzb(j)
              coord(17)=cbxb(j)
              coord(18)=cbzb(j)
              call thin6d_map_beambeam_type3(coord,argf,argi)
              yv(1,j)=coord(3)
              yv(2,j)=coord(4) 
            enddo
          goto 640
  730     continue
!--Hirata's 6D beam-beam kick
            argf(1)=ed(ix)
            argf(2)=ek(ix)   
            argf(3)=e0 
            argf(4)=e0f
            argf(5)=pma
            argf(6)=clobeam(1,imbb(i))
            argf(7)=clobeam(2,imbb(i))
            argf(8)=clobeam(3,imbb(i))
            argf(9)=clobeam(4,imbb(i))
            argf(10)=clobeam(5,imbb(i))
            argf(11)=clobeam(6,imbb(i))
            argf(12)=beamoff(1,imbb(i))
            argf(13)=beamoff(2,imbb(i))
            argf(14)=beamoff(3,imbb(i))
            argf(15)=beamoff(4,imbb(i))
            argf(16)=beamoff(5,imbb(i))
            argf(17)=beamoff(6,imbb(i))
            argf(18)=parbe(ix,1)
            argf(19)=parbe(ix,2)
            argf(20)=parbe(ix,3)
            argf(21)=parbe(ix,4)
            argf(22)=parbe(ix,5)      
            argf(23)=ibtyp
            argf(24)=ibbc   
            argf(25)=sigz
            argf(26)=imbb(i)
            argf(27)=ithick
            do j=1,12
              argf(26+j)=bbcu(imbb(i),j)
            enddo
            do j=1,napx
              coord(1)=xv(1,j)
              coord(2)=xv(2,j)
              coord(3)=yv(1,j)
              coord(4)=yv(2,j)
              coord(5)=oidpsv(j)
              coord(6)=sigmv(j)
              coord(7)=ejv(j)
              coord(8)=ejfv(j)
              coord(9)=dpsv(j)
              coord(13)=rvv(j)
              call thin6d_map_hirata_beambeam(coord,argf,argi)
              xv(1,j)=coord(1)
              xv(2,j)=coord(2)
              yv(1,j)=coord(3)
              yv(2,j)=coord(4)
              oidpsv(j)=coord(5)
              sigmv(j)=coord(6)
              ejv(j)=coord(7)
              ejfv(j)=coord(8)
              dpsv(j)=coord(9)
              rvv(j)=coord(13)
              if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
            enddo
          goto 640
  740     continue
          irrtr=imtr(ix)
          argf(1)=idz(1)
          argf(2)=idz(2)
          argf(3)=cotr(irrtr,1)
          argf(4)=cotr(irrtr,2)
          argf(5)=cotr(irrtr,3)
          argf(6)=cotr(irrtr,4)
          argf(7)=cotr(irrtr,5)
          argf(8)=cotr(irrtr,6)
          argf(9)=rrtr(irrtr,5,1)
          argf(10)=rrtr(irrtr,5,2)
          argf(11)=rrtr(irrtr,5,3)
          argf(12)=rrtr(irrtr,5,4)
          argf(13)=rrtr(irrtr,5,6)
          argf(14)=rrtr(irrtr,1,1)
          argf(15)=rrtr(irrtr,1,2)
          argf(16)=rrtr(irrtr,1,6)
          argf(17)=rrtr(irrtr,2,1)
          argf(18)=rrtr(irrtr,2,2)
          argf(19)=rrtr(irrtr,2,6)
          argf(20)=rrtr(irrtr,3,3)
          argf(21)=rrtr(irrtr,3,4)
          argf(22)=rrtr(irrtr,3,6)
          argf(23)=rrtr(irrtr,4,3)
          argf(24)=rrtr(irrtr,4,4)
          argf(25)=rrtr(irrtr,4,6)          
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(6)=sigmv(j)
            coord(9)=dpsv(j)
            call thin6d_map_accelerating_cavity2(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 640
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          argf(1)=tiltc(i)
          argf(2)=tilts(i)
          argf(3)=xory
          argf(4)=acdipamp
          argf(5)=acdipamp1
          argf(6)=acdipamp2
          argf(7)=nramp1
          argf(8)=nramp2
          argf(9)=nac
          argf(10)=nplato
          argf(11)=qd
          argf(12)=acphase
          do j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(8)=ejfv(j)
            call thin6d_map_ac_dipole(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
      enddo
      endif
          goto 640
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 640
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
          argf(1)=crabamp
          argf(2)=crabfreq
          argf(3)=crabph(ix)
          argf(4)=ed(ix)
          argf(5)=pma
          argf(6)=e0
          argf(7)=e0f
          argf(8)=ithick
        do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin6d_map_crab_cavity_1(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 640
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3

          argf(1)=crabamp
          argf(2)=crabfreq
          argf(3)=crabph(ix)
          argf(4)=ed(ix)
          argf(5)=pma
          argf(6)=e0
          argf(7)=e0f
        do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin6d_map_crab_cavity_2(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 640
!--DIPEDGE ELEMENT
  753     continue
          argf(1)=strack(i)
          argf(2)=tiltc(i)
          argf(3)=tilts(i)
          argf(4)=xsiv(1,i)
          argf(5)=zsiv(1,i)
          argf(6)=strackx(i)
          argf(7)=strackz(i)
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            call thin6d_map_dipedge(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
          enddo
          goto 640
!--solenoid
  754     continue
          argf(1)=strackx(i)
          argf(2)=strackz(i)
          do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6d_map_solenoid(coord,argf,argi)
            xv(1,j)=coord(1)
            xv(2,j)=coord(2)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            sigmv(j)=coord(6)
          enddo
          goto 640
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      argf(1)=embl
      argf(2)=tx
      argf(3)=ty
      argf(4)=lin
      argf(5)=rx
      argf(6)=ry
      argf(7)=cur
      argf(8)=chi
      argf(9)=l
      argf(10)=leff
      do 750 j=1, napx
        coord(1)=xv(1,j)
        coord(2)=xv(2,j)
        coord(3)=yv(1,j)
        coord(4)=yv(2,j)
        coord(9)=dpsv(j)
        call thin6d_map_wire(coord,argf,argi)
        xv(1,j)=coord(1)
        xv(2,j)=coord(2)
        yv(1,j)=coord(3)
        yv(2,j)=coord(4)
 
!-----------------------------------------------------------------------
 
  750     continue
          goto 640
 
!----------------------------
 
  640     continue
!GRD
!GRD UPGRADE JANUARY 2005
!GRD
!GRD
!GRD END OF UPGRADE
!GRD
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  650   continue
!GRD
!UPGRADE JANUARY 2005
!GRD
!GRD END OF UPGRADE
!GRD
        call lostpart(nthinerr)
        if(nthinerr.ne.0) return
        if(ntwin.ne.2) call dist1
        if(mod(n,nwr(4)).eq.0) call write6(n)
  660 continue
      return
      end
!
!==============================================================================
!
      subroutine thin6dua(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THIN LENS 6D WITH ACCELERATION
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
!-----------------------------------------------------------------------
!  EXACT DRIFT
!-----------------------------------------------------------------------
      double precision pz
!-----------------------------------------------------------------------
!  COMMON FOR EXACT VERSION
!-----------------------------------------------------------------------
      integer iexact
      common/exact/iexact
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,irrtr,ix,j,k,kpz,n,nmz,nthinerr
      double precision c5m4,cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,   &
     &crkveuk,crxb,crzb,dpsv3,pux,e0fo,e0o,r0,r2b,rb,rho2b,rkb,stracki, &
     &tkb,xbb,xlvj,xrb,yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision xv1j,xv2j
      double precision acdipamp, qd, acphase,acdipamp2,                 &
     &acdipamp1, crabamp, crabfreq
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f,coord(1000),argf(1000),argi(1000)
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
!-----------------------------------------------------------------------
      c5m4=5.0d-4
      nthinerr=0
      do 660 n=1,numl
        numx=n-1
        if(irip.eq.1) call ripple(n)
        if(n.le.nde(1)) nwri=nwr(1)
        if(n.gt.nde(1).and.n.le.nde(2)) nwri=nwr(2)
        if(n.gt.nde(2)) nwri=nwr(3)
        if(nwri.eq.0) nwri=numl+numlr+1
        if(mod(numx,nwri).eq.0) call writebin(nthinerr)
        if(nthinerr.ne.0) return
        do 650 i=1,iu
          ix=ic(i)-nblo
!--------count44
          goto(10,30,740,650,650,650,650,650,650,650,50,70,90,110,130,  &
     &150,170,190,210,230,440,460,480,500,520,540,560,580,600,620,      &
     &640,410,250,270,290,310,330,350,370,390,680,700,720,730,748,      &
     &650,650,650,650,650,745,746,751,752,753,754),ktrack(i)
          goto 650
   10     stracki=strack(i)
          if(iexact.eq.0) then
            do j=1,napx
              xv(1,j)=xv(1,j)+stracki*yv(1,j)
              xv(2,j)=xv(2,j)+stracki*yv(2,j)
!hr03       sigmv(j)=sigmv(j)+stracki*(c1e3-rvv(j)*(c1e3+(yv(1,j)       &
!hr03&*yv(1,j)+yv(2,j)*yv(2,j))*c5m4))
            sigmv(j)=sigmv(j)+stracki*(c1e3-rvv(j)*(c1e3+(yv(1,j)       &!hr03
     &**2+yv(2,j)**2)*c5m4))                                             !hr03
            enddo
          else
!-----------------------------------------------------------------------
!  EXACT DRIFT
!-----------------------------------------------------------------------
            do j=1,napx
              xv(1,j)=xv(1,j)*c1m3
              xv(2,j)=xv(2,j)*c1m3
              yv(1,j)=yv(1,j)*c1m3
              yv(2,j)=yv(2,j)*c1m3
              sigmv(j)=sigmv(j)*c1m3
              pz=sqrt(one-(yv(1,j)**2+yv(2,j)**2))
              xv(1,j)=xv(1,j)+stracki*(yv(1,j)/pz)
              xv(2,j)=xv(2,j)+stracki*(yv(2,j)/pz)
              sigmv(j)=sigmv(j)+stracki*(one-(rvv(j)/pz))
              xv(1,j)=xv(1,j)*c1e3
              xv(2,j)=xv(2,j)*c1e3
              yv(1,j)=yv(1,j)*c1e3
              yv(2,j)=yv(2,j)*c1e3
              sigmv(j)=sigmv(j)*c1e3
            enddo
          endif
          goto 650
   30     e0o=e0
          e0fo=e0f
          call adia(n,e0f)
          argf(1)=pma
          argf(2)=dppoff
          argf(3)=kz(ix)
          argf(4)=hsyc(ix)
          argf(5)=phasc(ix)
          argf(6)=hsy(1)
          argf(7)=hsy(3)
          argf(8)=sigmoff(i)
          argf(9)=e0
          argf(10)=e0f
          argf(11)=phas
          argf(12)=ed(ix)
          do 40 j=1,napx
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            coord(13)=rvv(j)
            coord(14)=ejf0v(j)
            call thin6dua_map_accelarating_cavity(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            sigmv(j)=coord(6)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
   40     continue
          if(n.eq.1) write(98,'(1p,6(2x,e25.18))')                      &
     &(xv(1,j),yv(1,j),xv(2,j),yv(2,j),sigmv(j),dpsv(j),j=1,napx)
          goto 640
!--HORIZONTAL DIPOLE
   50     do 60 j=1,napx
            yv(1,j)=yv(1,j)+strackc(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+stracks(i)*oidpsv(j)
   60     continue
          goto 640
!--NORMAL QUADRUPOLE
   70     do 80 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   80     continue
          goto 640
!--NORMAL SEXTUPOLE
   90     do 100 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  100     continue
          goto 640
!--NORMAL OCTUPOLE
  110     do 120 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  120     continue
          goto 640
!--NORMAL DECAPOLE
  130     do 140 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  140     continue
          goto 640
!--NORMAL DODECAPOLE
  150     do 160 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  160     continue
          goto 640
!--NORMAL 14-POLE
  170     do 180 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  180     continue
          goto 640
!--NORMAL 16-POLE
  190     do 200 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  200     continue
          goto 640
!--NORMAL 18-POLE
  210     do 220 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  220     continue
          goto 640
!--NORMAL 20-POLE
  230     do 240 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  240     continue
          goto 640
  250     continue
          do 260 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  260     continue
          goto 640
  270     continue
          do 280 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  280     continue
          goto 410
  290     continue
          do 300 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  300     continue
          goto 640
  310     continue
          do 320 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  320     continue
          goto 410
  330     continue
          do 340 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  340     continue
          goto 640
  350     continue
          do 360 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  360     continue
          goto 410
  370     continue
          do 380 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  380     continue
          goto 640
  390     continue
          do 400 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  400     continue
  410     r0=ek(ix)
          nmz=nmu(ix)
          if(nmz.ge.2) then
            do 430 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 420 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  420           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  430       continue
          else
            do 435 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  435       continue
          endif
          goto 640
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  440     do 450 j=1,napx
            yv(1,j)=yv(1,j)-stracks(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+strackc(i)*oidpsv(j)
  450     continue
          goto 640
!--SKEW QUADRUPOLE
  460     do 470 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  470     continue
          goto 640
!--SKEW SEXTUPOLE
  480     do 490 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  490     continue
          goto 640
!--SKEW OCTUPOLE
  500     do 510 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  510     continue
          goto 640
!--SKEW DECAPOLE
  520     do 530 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  530     continue
          goto 640
!--SKEW DODECAPOLE
  540     do 550 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  550     continue
          goto 640
!--SKEW 14-POLE
  560     do 570 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  570     continue
          goto 640
!--SKEW 16-POLE
  580     do 590 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  590     continue
          goto 640
!--SKEW 18-POLE
  600     do 610 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  610     continue
          goto 640
!--SKEW 20-POLE
  620     do 630 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  630     continue
          goto 640
  680     continue
          do 690 j=1,napx
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 690
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
            if(ibbc.eq.0) then
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))
          yv(1,j)=yv(1,j)+oidpsv(j)*(((strack(i)*crkveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))                      !hr03
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))
          yv(2,j)=yv(2,j)+oidpsv(j)*(((strack(i)*cikveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))                      !hr03
            else
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
              yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
              yv(2,j)=yv(2,j)+oidpsv(j)*cccc
            endif
  690     continue
          goto 640
  700     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 640
  720     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 640
  730     continue
!--Hirata's 6D beam-beam kick
            do j=1,napx
!hr03         track6d(1,j)=(xv(1,j)+ed(ix)-clobeam(1,imbb(i)))*c1m3
              track6d(1,j)=((xv(1,j)+ed(ix))-clobeam(1,imbb(i)))*c1m3    !hr03
              track6d(2,j)=(yv(1,j)/oidpsv(j)-clobeam(4,imbb(i)))*c1m3
!hr03         track6d(3,j)=(xv(2,j)+ek(ix)-clobeam(2,imbb(i)))*c1m3
              track6d(3,j)=((xv(2,j)+ek(ix))-clobeam(2,imbb(i)))*c1m3    !hr03
              track6d(4,j)=(yv(2,j)/oidpsv(j)-clobeam(5,imbb(i)))*c1m3
              track6d(5,j)=(sigmv(j)-clobeam(3,imbb(i)))*c1m3
              track6d(6,j)=dpsv(j)-clobeam(6,imbb(i))
            enddo
            call beamint(napx,track6d,parbe,sigz,bbcu,imbb(i),ix,ibtyp, &
     &ibbc)
            do j=1,napx
!hr03         xv(1,j)=track6d(1,j)*c1e3+clobeam(1,imbb(i))-             &
              xv(1,j)=(track6d(1,j)*c1e3+clobeam(1,imbb(i)))-           &!hr03
     &beamoff(1,imbb(i))
!hr03         xv(2,j)=track6d(3,j)*c1e3+clobeam(2,imbb(i))-             &
              xv(2,j)=(track6d(3,j)*c1e3+clobeam(2,imbb(i)))-           &!hr03
     &beamoff(2,imbb(i))
!hr03         dpsv(j)=track6d(6,j)+clobeam(6,imbb(i))-beamoff(6,imbb(i))
              dpsv(j)=(track6d(6,j)+clobeam(6,imbb(i)))-                &!hr03
     &beamoff(6,imbb(i))                                                 !hr03
              oidpsv(j)=one/(one+dpsv(j))
!hr03         yv(1,j)=(track6d(2,j)*c1e3+clobeam(4,imbb(i))-            &
              yv(1,j)=((track6d(2,j)*c1e3+clobeam(4,imbb(i)))-          &!hr03
     &beamoff(4,imbb(i)))*oidpsv(j)
!hr03         yv(2,j)=(track6d(4,j)*c1e3+clobeam(5,imbb(i))-            &
              yv(2,j)=((track6d(4,j)*c1e3+clobeam(5,imbb(i)))-          &!hr03
     &beamoff(5,imbb(i)))*oidpsv(j)
              ejfv(j)=dpsv(j)*e0f+e0f
!hr03         ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
              ejv(j)=sqrt(ejfv(j)**2+pma**2)
              rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
              if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
            enddo
          goto 640
  740     continue
          irrtr=imtr(ix)
          do j=1,napx
!hr03       sigmv(j)=sigmv(j)+cotr(irrtr,5)+rrtr(irrtr,5,1)*xv(1,j)+    &
!hr03&rrtr(irrtr,5,2)*yv(1,j)+rrtr(irrtr,5,3)*xv(2,j)+                  &
!hr03&rrtr(irrtr,5,4)*yv(2,j)+rrtr(irrtr,5,6)*dpsv(j)*c1e3
      sigmv(j)=(((((sigmv(j)+cotr(irrtr,5))+rrtr(irrtr,5,1)*xv(1,j))+   &!hr03
     &rrtr(irrtr,5,2)*yv(1,j))+rrtr(irrtr,5,3)*xv(2,j))+                &!hr03
!BNL-NOV08
!     &rrtr(irrtr,5,4)*yv(2,j)
     &rrtr(irrtr,5,4)*yv(2,j))+(rrtr(irrtr,5,6)*dpsv(j))*c1e3            !hr03
!BNL-NOV08
            pux=xv(1,j)
            dpsv3(j)=dpsv(j)*c1e3
!hr03       xv(1,j)=cotr(irrtr,1)+rrtr(irrtr,1,1)*pux+                  &
!hr03&rrtr(irrtr,1,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,1,6)
            xv(1,j)=((cotr(irrtr,1)+rrtr(irrtr,1,1)*pux)+               &!hr03
     &rrtr(irrtr,1,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,1,6)   !hr03
!hr03       yv(1,j)=cotr(irrtr,2)+rrtr(irrtr,2,1)*pux+                  &
!hr03&rrtr(irrtr,2,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,2,6)
            yv(1,j)=((cotr(irrtr,2)+rrtr(irrtr,2,1)*pux)+               &!hr03
     &rrtr(irrtr,2,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,2,6)   !hr03
            pux=xv(2,j)
!hr03       xv(2,j)=cotr(irrtr,3)+rrtr(irrtr,3,3)*pux+                  &
!hr03&rrtr(irrtr,3,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,3,6)
            xv(2,j)=((cotr(irrtr,3)+rrtr(irrtr,3,3)*pux)+               &!hr03
     &rrtr(irrtr,3,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,3,6)   !hr03
!hr03       yv(2,j)=cotr(irrtr,4)+rrtr(irrtr,4,3)*pux+                  &
!hr03&rrtr(irrtr,4,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,4,6)
            yv(2,j)=((cotr(irrtr,4)+rrtr(irrtr,4,3)*pux)+               &!hr03
     &rrtr(irrtr,4,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,4,6)   !hr03
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 640
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 640
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 640
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 640
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 640
!--DIPEDGE ELEMENT
  753     continue
          do j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackx(i)*crkve-                &
     &stracks(i)*cikve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackz(i)*cikve+                &
     &strackc(i)*crkve)
          enddo
          goto 640
!--solenoid
  754     continue
          do j=1,napx
            yv(1,j)=yv(1,j)-xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)+xv(1,j)*strackx(i)
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       yv(1,j)=crkve*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&cikve*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       yv(2,j)=-crkve*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&cikve*cos(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       crkve=xv(1,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&xv(2,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       cikve=-xv(1,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&xv(2,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))
            yv(1,j)=crkve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &cikve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            yv(2,j)=cikve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &crkve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            crkve=xv(1,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &xv(2,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            cikve=xv(2,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &xv(1,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            xv(1,j)=crkve
            xv(2,j)=cikve
            yv(1,j)=yv(1,j)+xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)-xv(1,j)*strackx(i)
!hr02       crkve=sigmv(j)-0.5*(xv(1,j)*xv(1,j)+xv(2,j)*xv(2,j))*       &
!hr02&strackx(i)*strackz(i)*rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
        crkve=sigmv(j)-0.5d0*(((((((xv(1,j)**2+xv(2,j)**2)*strackx(i))* &!hr02
     &strackz(i))*rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)           !hr02
            sigmv(j)=crkve
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       sigmv(j)=sigmv(j)+(xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i)* &
!hr02&rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
      sigmv(j)=sigmv(j)+((((((xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i))* &!hr02
     &rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)                       !hr02
          enddo
          goto 640
 
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      do 750 j=1, napx
 
      xv(1,j) = xv(1,j) * c1m3
      xv(2,j) = xv(2,j) * c1m3
      yv(1,j) = yv(1,j) * c1m3
      yv(2,j) = yv(2,j) * c1m3
 
!      write(*,*) 'Start: ',j,xv(1,j),xv(2,j),yv(1,j),
!     &yv(2,j)
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) -                                               &!hr03
     &((embl*0.5d0)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) -                                               &!hr03
     &((embl*0.5d0)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
 
!     call tilt(tx,ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(tx)*yv(2,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(tx))*yv(2,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(1,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-tx)                                                   !hr03
!+if crlibm
!hhr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
      xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(1,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(ty)*yv(1,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(ty))*yv(1,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
      xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
 
!     call drift(lin)
 
!hr03 xv(1,j) = xv(1,j) + lin*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) + (lin*yv(1,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) + lin*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) + (lin*yv(2,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
!      call kick(l,cur,lin,rx,ry,chi)
 
      xi = xv(1,j)-rx
      yi = xv(2,j)-ry
!hr03 yv(1,j) = yv(1,j)-c1m7*cur/chi*xi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(1,j) = yv(1,j)-((((c1m7*cur)/chi)*xi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
!GRD FOR CONSISTENSY
!hr03 yv(2,j) = yv(2,j)-c1m7*cur/chi*yi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(2,j) = yv(2,j)-((((c1m7*cur)/chi)*yi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
 
!     call drift(leff-lin)
 
!hr03 xv(1,j) = xv(1,j) + (leff-lin)*yv(1,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(1,j) = xv(1,j) + ((leff-lin)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
!hr03 xv(2,j) = xv(2,j) + (leff-lin)*yv(2,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(2,j) = xv(2,j) + ((leff-lin)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
 
!     call invtilt(tx,ty)
 
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(-ty)*yv(1,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(-ty))*yv(1,j))/               &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))+ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(-ty)-sin_rn(-ty)*tan_rn(atan_rn(yv(2,j)/&
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
      xv(2,j) = xv(2,j)*                                                &!hr03
     &(cos_rn(-1d0*ty)-sin_rn(-1d0*ty)*tan_rn(atan_rn(yv(2,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(-tx)*yv(2,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(-1d0*tx))*yv(2,j))/           &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/cos_rn(atan_rn(yv(1,j)/        &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!+if crlibm
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(-tx)-sin_rn(-tx)*tan_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
      xv(1,j) = xv(1,j)*                                                &!hr03
     &(cos_rn(-1d0*tx)-sin_rn(-1d0*tx)*tan_rn(atan_rn(yv(1,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                       !hr03
     &sin_rn(atan_rn(yv(1,j)/                                            !hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
 
!     call shift(-embl*tan(tx),-embl*tan(ty)/cos(tx))
 
      xv(1,j) = xv(1,j) + embl*tan_rn(tx)
!hr03 xv(2,j) = xv(2,j) + embl*tan_rn(ty)/cos_rn(tx)
      xv(2,j) = xv(2,j) + (embl*tan_rn(ty))/cos_rn(tx)                   !hr03
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) - ((embl*0.5d0)*yv(1,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) - ((embl*0.5d0)*yv(2,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
      xv(1,j) = xv(1,j) * c1e3
      xv(2,j) = xv(2,j) * c1e3
      yv(1,j) = yv(1,j) * c1e3
      yv(2,j) = yv(2,j) * c1e3
 
!      write(*,*) 'End: ',j,xv(1,j),xv(2,j),yv(1,j),                       &
!     &yv(2,j)
 
!-----------------------------------------------------------------------
 
  750     continue
          goto 640
 
!----------------------------
 
  640     continue
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  650   continue
        call lostpart(nthinerr)
        if(nthinerr.ne.0) return
        if(ntwin.ne.2) call dist1
        if(mod(n,nwr(4)).eq.0) call write6(n)
  660 continue
      return
      end
      subroutine ripple(n)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,n,nripple
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      nripple=nrturn+n
      do 20 i=1,iu
        if(abs(rsmi(i)).gt.pieni) then
!hr01     smiv(1,i)=rsmi(i)*cos_rn(two*pi*(nripple-1)/rfres(i)+rzphs(i))
          smiv(1,i)=rsmi(i)*cos_rn(((two*pi)*dble(nripple-1))/rfres(i)  &!hr01
     &     +rzphs(i))                                                    !hr01
        strack(i)=smiv(1,i)
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        endif
   20 continue
      return
      end
      subroutine writebin(nthinerr)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      integer ia,ia2,ie,nthinerr
      save
!-----------------------------------------------------------------------
        do 10 ia=1,napx-1
!GRD
          if(.not.pstop(nlostp(ia)).and..not.pstop(nlostp(ia)+1).and.   &
     &(mod(nlostp(ia),2).ne.0)) then
            ia2=(nlostp(ia)+1)/2
            ie=ia+1
            if(ntwin.ne.2) then
              write(91-ia2,iostat=ierro)                                &
     &numx,nlostp(ia),dam(ia),                                          &
     &xv(1,ia),yv(1,ia),xv(2,ia),yv(2,ia),sigmv(ia),dpsv(ia),e0
              endfile 91-ia2
              backspace 91-ia2
            else
              write(91-ia2,iostat=ierro)                                &
     &numx,nlostp(ia),dam(ia),                                          &
     &xv(1,ia),yv(1,ia),xv(2,ia),yv(2,ia),sigmv(ia),dpsv(ia),e0,        &
     &nlostp(ia)+1,dam(ia),                                             &
     &xv(1,ie),yv(1,ie),xv(2,ie),yv(2,ie),sigmv(ie),dpsv(ie),e0
              endfile 91-ia2
              backspace 91-ia2
            endif
            if(ierro.ne.0) then
              write(*,*)
              write(*,*) '*** ERROR ***,PROBLEMS WRITING TO FILE# : ',  &
     &91-ia2
              write(*,*) 'ERROR CODE : ',ierro
              write(*,*)
              endfile 12
              backspace 12
              nthinerr=3000
              return
            endif
          endif
   10 continue
      return
      end
      subroutine callcrp()
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      integer ia,ia2,ie,nthinerr
      save
!-----------------------------------------------------------------------
      return
      end
      subroutine lostpart(nthinerr)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
!      logical isnan
      logical myisnan
      integer ib2,ib3,ilostch,j,jj,jj1,lnapx,nthinerr
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      ilostch=0
      do 10 j=1,napx
        if(abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2).or.       &
!     &isnan(xv(1,j),xv(1,j)).or.isnan(xv(2,j),xv(2,j))) then
     &myisnan(xv(1,j),xv(1,j)).or.myisnan(xv(2,j),xv(2,j))) then
          ilostch=1
          pstop(nlostp(j))=.true.
        endif
  10  continue
      do 20 j=1,napx
        if(pstop(nlostp(j))) then
          aperv(nlostp(j),1)=aper(1)
          aperv(nlostp(j),2)=aper(2)
          xvl(1,nlostp(j))=xv(1,j)
          xvl(2,nlostp(j))=xv(2,j)
          yvl(1,nlostp(j))=yv(1,j)
          yvl(2,nlostp(j))=yv(2,j)
          dpsvl(nlostp(j))=dpsv(j)
          ejvl(nlostp(j))=ejv(j)
          sigmvl(nlostp(j))=sigmv(j)
          numxv(nlostp(j))=numx
          nnumxv(nlostp(j))=numx
          if(mod(nlostp(j),2).eq.one) then
            write(*,10000) nlostp(j),nms(nlostp(j))*izu0,               &
     &dp0v(nlostp(j)),numxv(nlostp(j)),abs(xvl(1,nlostp(j))),           &
     &aperv(nlostp(j),1),abs(xvl(2,nlostp(j))),                         &
     &aperv(nlostp(j),2)
          else
            write(*,10000) nlostp(j),nms(nlostp(j)-1)*izu0,             &
     &dp0v(nlostp(j)-1),numxv(nlostp(j)),abs(xvl(1,nlostp(j))),         &
     &aperv(nlostp(j),1),abs(xvl(2,nlostp(j))),                         &
     &aperv(nlostp(j),2)
          endif
        endif
   20 continue
      lnapx=napx
      do 30 j=napx,1,-1
        if(pstop(nlostp(j))) then
          if(j.ne.lnapx) then
            do 35 jj=j,lnapx-1
              jj1=jj+1
              nlostp(jj)=nlostp(jj1)
              xv(1,jj)=xv(1,jj1)
              xv(2,jj)=xv(2,jj1)
              yv(1,jj)=yv(1,jj1)
              yv(2,jj)=yv(2,jj1)
              dpsv(jj)=dpsv(jj1)
              sigmv(jj)=sigmv(jj1)
              ejfv(jj)=ejfv(jj1)
              ejv(jj)=ejv(jj1)
              rvv(jj)=rvv(jj1)
              oidpsv(jj)=oidpsv(jj1)
              dpsv1(jj)=dpsv1(jj1)
              clo6v(1,jj)=clo6v(1,jj1)
              clo6v(2,jj)=clo6v(2,jj1)
              clo6v(3,jj)=clo6v(3,jj1)
              clop6v(1,jj)=clop6v(1,jj1)
              clop6v(2,jj)=clop6v(2,jj1)
              clop6v(3,jj)=clop6v(3,jj1)
!--beam-beam element
              di0xs(jj)=di0xs(jj1)
              dip0xs(jj)=dip0xs(jj1)
              di0zs(jj)=di0zs(jj1)
              dip0zs(jj)=dip0zs(jj1)
              do 210 ib2=1,6
                do 210 ib3=1,6
                  tasau(jj,ib2,ib3)=tasau(jj1,ib2,ib3)
  210         continue
   35       continue
          endif
          lnapx=lnapx-1
        endif
   30 continue
      if(lnapx.eq.0) then
        write(*,*)
        write(*,*)
        write(*,*) '***********************'
        write(*,*) '** ALL PARTICLE LOST **'
        write(*,*) '**   PROGRAM STOPS   **'
        write(*,*) '***********************'
        write(*,*)
        write(*,*)
        nthinerr=3001
        nnuml=numl
        return
      endif
      if(ithick.eq.1.and.ilostch.eq.1) then
        call synuthck
      endif
      napx=lnapx
      return
10000 format(t10,'TRACKING ENDED ABNORMALLY'/t10, 'PARTICLE ',i3,       &
     &' RANDOM SEED ',i8,/ t10,' MOMENTUM DEVIATION ',g12.5,            &
     &' LOST IN REVOLUTION ',i8,/ t10,'HORIZ:  AMPLITUDE = ',f15.3,     &
     &'   APERTURE = ',f15.3/ t10,'VERT:   AMPLITUDE = ',f15.3,         &
     &'   APERTURE = ',f15.3/)
      end
      subroutine lostpar2(i,ix,nthinerr)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
!      logical isnan
      logical myisnan
      integer i,ib2,ib3,ilostch,ix,j,jj,jj1,lnapx,nthinerr
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      ilostch=0
      do 10 j=1,napx
        if(abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2).or.       &
!     &isnan(xv(1,j),xv(1,j)).or.isnan(xv(2,j),xv(2,j))) then
     &myisnan(xv(1,j),xv(1,j)).or.myisnan(xv(2,j),xv(2,j))) then
          ilostch=1
          pstop(nlostp(j))=.true.
        endif
  10  continue
      do 20 j=1,napx
        if(pstop(nlostp(j))) then
          aperv(nlostp(j),1)=aper(1)
          aperv(nlostp(j),2)=aper(2)
          iv(nlostp(j))=i
          ixv(nlostp(j))=ix
          xvl(1,nlostp(j))=xv(1,j)
          xvl(2,nlostp(j))=xv(2,j)
          yvl(1,nlostp(j))=yv(1,j)
          yvl(2,nlostp(j))=yv(2,j)
          dpsvl(nlostp(j))=dpsv(j)
          ejvl(nlostp(j))=ejv(j)
          sigmvl(nlostp(j))=sigmv(j)
          numxv(nlostp(j))=numx
          nnumxv(nlostp(j))=numx
          if(mod(nlostp(j),2).eq.one) then
            write(*,10000) nlostp(j),nms(nlostp(j))*izu0,               &
     &dp0v(nlostp(j)),numxv(nlostp(j)),iv(nlostp(j)),                   &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          else
            write(*,10000) nlostp(j),nms(nlostp(j)-1)*izu0,             &
     &dp0v(nlostp(j)-1),numxv(nlostp(j)),iv(nlostp(j)),                 &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          endif
        endif
   20 continue
      lnapx=napx
      do 30 j=napx,1,-1
        if(pstop(nlostp(j))) then
          if(j.ne.lnapx) then
            do 35 jj=j,lnapx-1
              jj1=jj+1
              nlostp(jj)=nlostp(jj1)
              xv(1,jj)=xv(1,jj1)
              xv(2,jj)=xv(2,jj1)
              yv(1,jj)=yv(1,jj1)
              yv(2,jj)=yv(2,jj1)
              dpsv(jj)=dpsv(jj1)
              sigmv(jj)=sigmv(jj1)
              ejfv(jj)=ejfv(jj1)
              ejv(jj)=ejv(jj1)
              rvv(jj)=rvv(jj1)
              oidpsv(jj)=oidpsv(jj1)
              dpsv1(jj)=dpsv1(jj1)
              clo6v(1,jj)=clo6v(1,jj1)
              clo6v(2,jj)=clo6v(2,jj1)
              clo6v(3,jj)=clo6v(3,jj1)
              clop6v(1,jj)=clop6v(1,jj1)
              clop6v(2,jj)=clop6v(2,jj1)
              clop6v(3,jj)=clop6v(3,jj1)
!--beam-beam element
              di0xs(jj)=di0xs(jj1)
              dip0xs(jj)=dip0xs(jj1)
              di0zs(jj)=di0zs(jj1)
              dip0zs(jj)=dip0zs(jj1)
              do 210 ib2=1,6
                do 210 ib3=1,6
                  tasau(jj,ib2,ib3)=tasau(jj1,ib2,ib3)
  210         continue
   35       continue
          endif
          lnapx=lnapx-1
        endif
   30 continue
      if(lnapx.eq.0) then
        write(*,*)
        write(*,*)
        write(*,*) '***********************'
        write(*,*) '** ALL PARTICLE LOST **'
        write(*,*) '**   PROGRAM STOPS   **'
        write(*,*) '***********************'
        write(*,*)
        write(*,*)
        nthinerr=3001
        nnuml=numl
        return
      endif
      if(ithick.eq.1.and.ilostch.eq.1) then
        call synuthck
      endif
      napx=lnapx
      return
10000 format(t10,'TRACKING ENDED ABNORMALLY'/t10, 'PARTICLE ',i3,       &
     &' RANDOM SEED ',i8, ' MOMENTUM DEVIATION ',g12.5/ t10,            &
     &' LOST IN REVOLUTION ',i8,' AT ELEMENT ',i4/ t10,                 &
     &'HORIZ:  AMPLITUDE = ',f15.3,'RE-APERTURE = ',f15.3/ t10,         &
     &'VERT:   AMPLITUDE = ',f15.3,'RE-APERTURE = ',f15.3/ t10,         &
     &'ELEMENT - LIST NUMBER ',i4,' TYP NUMBER ',i4,' NAME ',a16/)
      end
      subroutine lostpar3(i,ix,nthinerr)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
!      logical isnan
      logical myisnan
      integer i,ib2,ib3,ilostch,ix,j,jj,jj1,lnapx,nthinerr
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      ilostch=0
      do 10 j=1,napx
        if(abs(xv(1,j)).gt.apx(ix).or.abs(xv(2,j)).gt.apz(ix).or.       &
!     &isnan(xv(1,j),xv(1,j)).or.isnan(xv(2,j),xv(2,j))) then
     &myisnan(xv(1,j),xv(1,j)).or.myisnan(xv(2,j),xv(2,j))) then
          ilostch=1
          pstop(nlostp(j))=.true.
        endif
  10  continue
      do 20 j=1,napx
        if(pstop(nlostp(j))) then
          aperv(nlostp(j),1)=apx(ix)
          aperv(nlostp(j),2)=apz(ix)
          iv(nlostp(j))=i
          ixv(nlostp(j))=ix
          xvl(1,nlostp(j))=xv(1,j)
          xvl(2,nlostp(j))=xv(2,j)
          yvl(1,nlostp(j))=yv(1,j)
          yvl(2,nlostp(j))=yv(2,j)
          dpsvl(nlostp(j))=dpsv(j)
          ejvl(nlostp(j))=ejv(j)
          sigmvl(nlostp(j))=sigmv(j)
          numxv(nlostp(j))=numx
          nnumxv(nlostp(j))=numx
          if(mod(nlostp(j),2).eq.one) then
            write(*,10000) nlostp(j),nms(nlostp(j))*izu0,               &
     &dp0v(nlostp(j)),numxv(nlostp(j)),iv(nlostp(j)),                   &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          else
            write(*,10000) nlostp(j),nms(nlostp(j)-1)*izu0,             &
     &dp0v(nlostp(j)-1),numxv(nlostp(j)),iv(nlostp(j)),                 &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          endif
        endif
   20 continue
      lnapx=napx
      do 30 j=napx,1,-1
        if(pstop(nlostp(j))) then
          if(j.ne.lnapx) then
            do 35 jj=j,lnapx-1
              jj1=jj+1
              nlostp(jj)=nlostp(jj1)
              xv(1,jj)=xv(1,jj1)
              xv(2,jj)=xv(2,jj1)
              yv(1,jj)=yv(1,jj1)
              yv(2,jj)=yv(2,jj1)
              dpsv(jj)=dpsv(jj1)
              sigmv(jj)=sigmv(jj1)
              ejfv(jj)=ejfv(jj1)
              ejv(jj)=ejv(jj1)
              rvv(jj)=rvv(jj1)
              oidpsv(jj)=oidpsv(jj1)
              dpsv1(jj)=dpsv1(jj1)
              clo6v(1,jj)=clo6v(1,jj1)
              clo6v(2,jj)=clo6v(2,jj1)
              clo6v(3,jj)=clo6v(3,jj1)
              clop6v(1,jj)=clop6v(1,jj1)
              clop6v(2,jj)=clop6v(2,jj1)
              clop6v(3,jj)=clop6v(3,jj1)
!--beam-beam element
              di0xs(jj)=di0xs(jj1)
              dip0xs(jj)=dip0xs(jj1)
              di0zs(jj)=di0zs(jj1)
              dip0zs(jj)=dip0zs(jj1)
              do 210 ib2=1,6
                do 210 ib3=1,6
                  tasau(jj,ib2,ib3)=tasau(jj1,ib2,ib3)
  210         continue
   35       continue
          endif
          lnapx=lnapx-1
        endif
   30 continue
      if(lnapx.eq.0) then
        write(*,*)
        write(*,*)
        write(*,*) '***********************'
        write(*,*) '** ALL PARTICLE LOST **'
        write(*,*) '**   PROGRAM STOPS   **'
        write(*,*) '***********************'
        write(*,*)
        write(*,*)
        nthinerr=3001
        nnuml=numl
        return
      endif
      if(ithick.eq.1.and.ilostch.eq.1) then
        call synuthck
      endif
      napx=lnapx
      return
10000 format(t10,'TRACKING ENDED ABNORMALLY'/t10, 'PARTICLE ',i3,       &
     &' RANDOM SEED ',i8, ' MOMENTUM DEVIATION ',g12.5/ t10,            &
     &' LOST IN REVOLUTION ',i8,' AT ELEMENT ',i4/ t10,                 &
     &'HORIZ:  AMPLITUDE = ',f15.3,'RE-APERTURE = ',f15.3/ t10,         &
     &'VERT:   AMPLITUDE = ',f15.3,'RE-APERTURE = ',f15.3/ t10,         &
     &'ELEMENT - LIST NUMBER ',i4,' TYP NUMBER ',i4,' NAME ',a16/)
      end
      subroutine lostpar4(i,ix,nthinerr)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
!      logical isnan
      logical myisnan
      integer i,ib2,ib3,ilostch,ix,j,jj,jj1,lnapx,nthinerr
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      ilostch=0
      do 10 j=1,napx
!hr03   if(xv(1,j)*xv(1,j)*ape(1,ix)+xv(2,j)*xv(2,j)*ape(2,ix).gt.      &
        if(xv(1,j)**2*ape(1,ix)+xv(2,j)**2*ape(2,ix).gt.                &!hr03
     &ape(3,ix).or.                                                     &
!     &isnan(xv(1,j),xv(1,j)).or.isnan(xv(2,j),xv(2,j))) then
     &myisnan(xv(1,j),xv(1,j)).or.myisnan(xv(2,j),xv(2,j))) then
          ilostch=1
          pstop(nlostp(j))=.true.
        endif
  10  continue
      do 20 j=1,napx
        if(pstop(nlostp(j))) then
          aperv(nlostp(j),1)=apx(ix)
          aperv(nlostp(j),2)=apz(ix)
          iv(nlostp(j))=i
          ixv(nlostp(j))=ix
          xvl(1,nlostp(j))=xv(1,j)
          xvl(2,nlostp(j))=xv(2,j)
          yvl(1,nlostp(j))=yv(1,j)
          yvl(2,nlostp(j))=yv(2,j)
          dpsvl(nlostp(j))=dpsv(j)
          ejvl(nlostp(j))=ejv(j)
          sigmvl(nlostp(j))=sigmv(j)
          numxv(nlostp(j))=numx
          nnumxv(nlostp(j))=numx
          if(mod(nlostp(j),2).eq.one) then
            write(*,10000) nlostp(j),nms(nlostp(j))*izu0,               &
     &dp0v(nlostp(j)),numxv(nlostp(j)),iv(nlostp(j)),                   &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          else
            write(*,10000) nlostp(j),nms(nlostp(j)-1)*izu0,             &
     &dp0v(nlostp(j)-1),numxv(nlostp(j)),iv(nlostp(j)),                 &
     &abs(xvl(1,nlostp(j))),aperv(nlostp(j),1),                         &
     &abs(xvl(2,nlostp(j))),aperv(nlostp(j),2),                         &
     &ixv(nlostp(j)),kz(ixv(nlostp(j))),bez(ixv(nlostp(j)))
          endif
        endif
   20 continue
      lnapx=napx
      do 30 j=napx,1,-1
        if(pstop(nlostp(j))) then
          if(j.ne.lnapx) then
            do 35 jj=j,lnapx-1
              jj1=jj+1
              nlostp(jj)=nlostp(jj1)
              xv(1,jj)=xv(1,jj1)
              xv(2,jj)=xv(2,jj1)
              yv(1,jj)=yv(1,jj1)
              yv(2,jj)=yv(2,jj1)
              dpsv(jj)=dpsv(jj1)
              sigmv(jj)=sigmv(jj1)
              ejfv(jj)=ejfv(jj1)
              ejv(jj)=ejv(jj1)
              rvv(jj)=rvv(jj1)
              oidpsv(jj)=oidpsv(jj1)
              dpsv1(jj)=dpsv1(jj1)
              clo6v(1,jj)=clo6v(1,jj1)
              clo6v(2,jj)=clo6v(2,jj1)
              clo6v(3,jj)=clo6v(3,jj1)
              clop6v(1,jj)=clop6v(1,jj1)
              clop6v(2,jj)=clop6v(2,jj1)
              clop6v(3,jj)=clop6v(3,jj1)
!--beam-beam element
              di0xs(jj)=di0xs(jj1)
              dip0xs(jj)=dip0xs(jj1)
              di0zs(jj)=di0zs(jj1)
              dip0zs(jj)=dip0zs(jj1)
              do 210 ib2=1,6
                do 210 ib3=1,6
                  tasau(jj,ib2,ib3)=tasau(jj1,ib2,ib3)
  210         continue
   35       continue
          endif
          lnapx=lnapx-1
        endif
   30 continue
      if(lnapx.eq.0) then
        write(*,*)
        write(*,*)
        write(*,*) '***********************'
        write(*,*) '** ALL PARTICLE LOST **'
        write(*,*) '**   PROGRAM STOPS   **'
        write(*,*) '***********************'
        write(*,*)
        write(*,*)
        nthinerr=3001
        nnuml=numl
        return
      endif
      if(ithick.eq.1.and.ilostch.eq.1) then
        call synuthck
      endif
      napx=lnapx
      return
10000 format(t10,'TRACKING ENDED ABNORMALLY'/t10, 'PARTICLE ',i3,       &
     &' RANDOM SEED ',i8, ' MOMENTUM DEVIATION ',g12.5/ t10,            &
     &' LOST IN REVOLUTION ',i8,' AT ELEMENT ',i4/ t10,                 &
     &'HORIZ:  AMPLITUDE = ',f15.3,'EL-APERTURE = ',f15.3/ t10,         &
     &'VERT:   AMPLITUDE = ',f15.3,'EL-APERTURE = ',f15.3/ t10,         &
     &'ELEMENT - LIST NUMBER ',i4,' TYP NUMBER ',i4,' NAME ',a16/)
      end
      subroutine dist1
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer ia,ib2,ib3,ie
      double precision dam1
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      do 20 ia=1,napx,2
        if(.not.pstop(nlostp(ia)).and..not.pstop(nlostp(ia)+1).and.     &
     &(mod(nlostp(ia),2).ne.0)) then
          ie=ia+1
          dam(ia)=zero
          dam(ie)=zero
          xau(1,1)= xv(1,ia)
          xau(1,2)= yv(1,ia)
          xau(1,3)= xv(2,ia)
          xau(1,4)= yv(2,ia)
          xau(1,5)=sigmv(ia)
          xau(1,6)= dpsv(ia)
          xau(2,1)= xv(1,ie)
          xau(2,2)= yv(1,ie)
          xau(2,3)= xv(2,ie)
          xau(2,4)= yv(2,ie)
          xau(2,5)=sigmv(ie)
          xau(2,6)= dpsv(ie)
          cloau(1)= clo6v(1,ia)
          cloau(2)=clop6v(1,ia)
          cloau(3)= clo6v(2,ia)
          cloau(4)=clop6v(2,ia)
          cloau(5)= clo6v(3,ia)
          cloau(6)=clop6v(3,ia)
          di0au(1)= di0xs(ia)
          di0au(2)=dip0xs(ia)
          di0au(3)= di0zs(ia)
          di0au(4)=dip0zs(ia)
          do 10 ib2=1,6
            do 10 ib3=1,6
              tau(ib2,ib3)=tasau(ia,ib2,ib3)
   10     continue
          call distance(xau,cloau,di0au,tau,dam1)
          dam(ia)=dam1
          dam(ie)=dam1
        endif
   20 continue
      return
      end
      subroutine write6(n)
!-----------------------------------------------------------------------
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer ia,ia2,id,ie,ig,n
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!-----------------------------------------------------------------------
      id=0
      do 10 ia=1,napxo,2
        ig=ia+1
        ia2=ig/2
        endfile 91-ia2
        backspace 91-ia2
!-- PARTICLES STABLE
        if(.not.pstop(ia).and..not.pstop(ig)) then
          write(*,10000) ia,nms(ia)*izu0,dp0v(ia),n
          id=id+1
          ie=id+1
          write(*,10010)                                                &
     &xv(1,id),yv(1,id),xv(2,id),yv(2,id),sigmv(id),dpsv(id),           &
     &xv(1,ie),yv(1,ie),xv(2,ie),yv(2,ie),sigmv(ie),dpsv(ie),           &
     &e0,ejv(id),ejv(ie)
          write(12,10010,iostat=ierro)                                  &
     &xv(1,id),yv(1,id),xv(2,id),yv(2,id),sigmv(id),dpsv(id),           &
     &xv(1,ie),yv(1,ie),xv(2,ie),yv(2,ie),sigmv(ie),dpsv(ie),           &
     &e0,ejv(id),ejv(ie)
          id=id+1
!-- FIRST PARTICLES LOST
        else if(pstop(ia).and..not.pstop(ig)) then
          id=id+1
          write(12,10010,iostat=ierro)                                  &
     &xvl(1,ia),yvl(1,ia),xvl(2,ia),yvl(2,ia),sigmvl(ia),dpsvl(ia),     &
     &xv(1,id),yv(1,id),xv(2,id),yv(2,id),sigmv(id),dpsv(id),           &
     &e0,ejvl(ia),ejv(id)
!-- SECOND PARTICLES LOST
        else if(.not.pstop(ia).and.pstop(ig)) then
          id=id+1
          write(12,10010,iostat=ierro)                                  &
     &xv(1,id),yv(1,id),xv(2,id),yv(2,id),sigmv(id),dpsv(id),           &
     &xvl(1,ig),yvl(1,ig),xvl(2,ig),yvl(2,ig),sigmvl(ig),dpsvl(ig),     &
     &e0,ejv(id),ejvl(ig)
!-- BOTH PARTICLES LOST
        else if(pstop(ia).and.pstop(ig)) then
          write(12,10010,iostat=ierro)                                  &
     &xvl(1,ia),yvl(1,ia),xvl(2,ia),yvl(2,ia),sigmvl(ia),dpsvl(ia),     &
     &xvl(1,ig),yvl(1,ig),xvl(2,ig),yvl(2,ig),sigmvl(ig),dpsvl(ig),     &
     &e0,ejvl(ia),ejvl(ig)
        endif
   10 continue
      if(ierro.ne.0) write(*,*) 'Warning from write6: fort.12 has ',    &
     &'corrupted output probably due to lost particles'
      if(ierro.ne.0) then                                                !hr09
        call abend(' abend in write6                                  ') !hr09
      endif                                                              !hr09
      endfile 12
      backspace 12
      return
10000 format(1x/5x,'PARTICLE ',i3,' RANDOM SEED ',i8,                   &
     &' MOMENTUM DEVIATION ',g12.5 /5x,'REVOLUTION ',i8/)
10010 format(10x,f47.33)
      end
      subroutine trauthck(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THICK LENS PART
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,ix,j,jb,jj,jx,kpz,kzz,napx0,nbeaux,nmz,nthinerr
      double precision benkcc,cbxb,cbzb,cikveb,crkveb,crxb,crzb,r0,r000,&
     &r0a,r2b,rb,rho2b,rkb,tkb,xbb,xrb,zbb,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension nbeaux(nbb)
      save
!-----------------------------------------------------------------------
      do 5 i=1,npart
        nlostp(i)=i
   5  continue
      do 10 i=1,nblz
        ktrack(i)=0
        strack(i)=zero
        strackc(i)=zero
        stracks(i)=zero
   10 continue
!--beam-beam element
      if(nbeam.ge.1) then
        do 15 i=1,nbb
          nbeaux(i)=0
   15   continue
        do i=1,iu
          ix=ic(i)
          if(ix.gt.nblo) then
            ix=ix-nblo
!hr03       if(kz(ix).eq.20.and.parbe(ix,2).eq.0) then
            if(kz(ix).eq.20.and.parbe(ix,2).eq.0d0) then                 !hr03
!--round beam
              if(sigman(1,imbb(i)).eq.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.2.or.nbeaux(imbb(i)).eq.3) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=1
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                endif
              endif
!--elliptic beam x>z
              if(sigman(1,imbb(i)).gt.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.1.or.nbeaux(imbb(i)).eq.3) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=2
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                  sigman2(2,imbb(i))=sigman(2,imbb(i))**2
                  sigmanq(1,imbb(i))=sigman(1,imbb(i))/sigman(2,imbb(i))
                  sigmanq(2,imbb(i))=sigman(2,imbb(i))/sigman(1,imbb(i))
                endif
              endif
!--elliptic beam z>x
              if(sigman(1,imbb(i)).lt.sigman(2,imbb(i))) then
                if(nbeaux(imbb(i)).eq.1.or.nbeaux(imbb(i)).eq.2) then
                  call prror(89)
                else
                  nbeaux(imbb(i))=3
                  sigman2(1,imbb(i))=sigman(1,imbb(i))**2
                  sigman2(2,imbb(i))=sigman(2,imbb(i))**2
                  sigmanq(1,imbb(i))=sigman(1,imbb(i))/sigman(2,imbb(i))
                  sigmanq(2,imbb(i))=sigman(2,imbb(i))/sigman(1,imbb(i))
                endif
              endif
            endif
          endif
        enddo
      endif
      do 290 i=1,iu
        if(mout2.eq.1.and.i.eq.1) call write4
        ix=ic(i)
        if(ix.gt.nblo) goto 30
        ktrack(i)=1
        do 20 jb=1,mel(ix)
          jx=mtyp(ix,jb)
          strack(i)=strack(i)+el(jx)
   20   continue
        if(abs(strack(i)).le.pieni) ktrack(i)=31
        goto 290
   30   ix=ix-nblo
        kpz=abs(kp(ix))
        if(kpz.eq.6) then
          ktrack(i)=2
          goto 290
        endif
   40   kzz=kz(ix)
        if(kzz.eq.0) then
          ktrack(i)=31
          goto 290
        endif
!--beam-beam element
!hr08   if(kzz.eq.20.and.nbeam.ge.1.and.parbe(ix,2).eq.0) then
        if(kzz.eq.20.and.nbeam.ge.1.and.parbe(ix,2).eq.0d0) then         !hr08
          strack(i)=crad*ptnfac(ix)
          if(abs(strack(i)).le.pieni) then
            ktrack(i)=31
            goto 290
          endif
          if(nbeaux(imbb(i)).eq.1) then
            ktrack(i)=41
            if(ibeco.eq.1) then
              do 42 j=1,napx
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 42
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
!hr03           beamoff(4,imbb(i))=strack(i)*crkveb(j)/rho2b(j)*        &
!hr03           beamoff(4,imbb(i))=strack(i)*crkveb(j)/rho2b(j)*        &
!hr03&(one-exp_rn(-tkb(j)))
                beamoff(4,imbb(i))=((strack(i)*crkveb(j))/rho2b(j))*    &!hr03
     &(one-exp_rn(-1d0*tkb(j)))                                          !hr03
!hr03           beamoff(5,imbb(i))=strack(i)*cikveb(j)/rho2b(j)*        &
!hr03           beamoff(5,imbb(i))=strack(i)*cikveb(j)/rho2b(j)*        &
!hr03&(one-exp_rn(-tkb(j)))
                beamoff(5,imbb(i))=((strack(i)*cikveb(j))/rho2b(j))*    &!hr03
     &(one-exp_rn(-1d0*tkb(j)))                                          !hr03
   42         continue
            endif
          endif
          if(nbeaux(imbb(i)).eq.2) then
            ktrack(i)=42
            if(ibeco.eq.1) then
            if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            endif
            endif
          endif
          if(nbeaux(imbb(i)).eq.3) then
            ktrack(i)=43
            if(ibeco.eq.1) then
            if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
                crkveb(j)=ed(ix)
                cikveb(j)=ek(ix)
              else
                crkveb(j)=ed(ix)*bbcu(imbb(i),11)+                      &
     &ek(ix)*bbcu(imbb(i),12)
!hr03           cikveb(j)=-ed(ix)*bbcu(imbb(i),12)+                     &
!hr03&ek(ix)*bbcu(imbb(i),11)
                cikveb(j)=ek(ix)*bbcu(imbb(i),11)-                      &!hr03
     &ed(ix)*bbcu(imbb(i),12)                                            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
!hr03         beamoff(4,imbb(i))=rkb(j)*(crzb(j)-exp_rn(-tkb(j))*       &
!hr03&cbzb(j))*
!hr03&sign(one,crkveb(j))
              beamoff(4,imbb(i))=(rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbzb(j)))*                                                        &!hr03
     &sign(one,crkveb(j))                                                !hr03
!hr03&sign(one,crkveb(j))
!hr03         beamoff(5,imbb(i))=rkb(j)*(crxb(j)-exp_rn(-tkb(j))*       &
!hr03&cbxb(j))*
!hr03&sign(one,cikveb(j))
              beamoff(5,imbb(i))=(rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*  &!hr03
     &cbxb(j)))*                                                        &!hr03
     &sign(one,cikveb(j))                                                !hr03
!hr03&sign(one,cikveb(j))
            enddo
            endif
            endif
          endif
          goto 290
!--Hirata's 6D beam-beam kick
!hr03   else if(kzz.eq.20.and.parbe(ix,2).gt.0) then
        else if(kzz.eq.20.and.parbe(ix,2).gt.0d0) then                   !hr03
          ktrack(i)=44
!hr03     parbe(ix,4)=-crad*ptnfac(ix)*half*c1m6
          parbe(ix,4)=(((-1d0*crad)*ptnfac(ix))*half)*c1m6               !hr03
          if(ibeco.eq.1) then
            track6d(1,1)=ed(ix)*c1m3
            track6d(2,1)=zero
            track6d(3,1)=ek(ix)*c1m3
            track6d(4,1)=zero
            track6d(5,1)=zero
            track6d(6,1)=zero
            napx0=napx
            napx=1
            call beamint(napx,track6d,parbe,sigz,bbcu,imbb(i),ix,ibtyp, &
     &ibbc)
            beamoff(1,imbb(i))=track6d(1,1)*c1e3
            beamoff(2,imbb(i))=track6d(3,1)*c1e3
            beamoff(4,imbb(i))=track6d(2,1)*c1e3
            beamoff(5,imbb(i))=track6d(4,1)*c1e3
            beamoff(6,imbb(i))=track6d(6,1)
            napx=napx0
          endif
          goto 290
        endif
        if(kzz.eq.15) then
          ktrack(i)=45
          goto 290
        endif
        if(kzz.eq.16) then
          ktrack(i)=51
          goto 290
        else if(kzz.eq.-16) then
          ktrack(i)=52
          goto 290
        endif
        if(kzz.eq.23) then
          ktrack(i)=53
          goto 290
        else if(kzz.eq.-23) then
          ktrack(i)=54
          goto 290
        endif
! JBG RF CC Multipoles
        if(kzz.eq.26) then
          ktrack(i)=57
          goto 290
        else if(kzz.eq.-26) then
          ktrack(i)=58
          goto 290
        endif
        if(kzz.eq.27) then
          ktrack(i)=59
          goto 290
        else if(kzz.eq.-27) then
          ktrack(i)=60
          goto 290
        endif
        if(kzz.eq.28) then
          ktrack(i)=61
          goto 290
        else if(kzz.eq.-28) then
          ktrack(i)=62
          goto 290
        endif
        if(kzz.eq.22) then
          ktrack(i)=3
          goto 290
        endif
        if(mout2.eq.1.and.icextal(i).ne.0) then
          write(27,'(a16,2x,1p,2d14.6,d17.9)') bez(ix),extalign(i,1),   &
     &extalign(i,2),extalign(i,3)
        endif
        if(kzz.lt.0) goto 180
        goto(50,60,70,80,90,100,110,120,130,140,150,290,290,290,        &
     &       290,290,290,290,290,290,290,290,290,145,146),kzz
        ktrack(i)=31
        goto 290
   50   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=11
        strack(i)=smiv(1,i)*c1e3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   60   if(abs(smiv(1,i)).le.pieni.and.abs(ramp(ix)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=12
        strack(i)=smiv(1,i)
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   70   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=13
        strack(i)=smiv(1,i)*c1m3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   80   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=14
        strack(i)=smiv(1,i)*c1m6
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
   90   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=15
        strack(i)=smiv(1,i)*c1m9
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  100   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=16
        strack(i)=smiv(1,i)*c1m12
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  110   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=17
        strack(i)=smiv(1,i)*c1m15
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  120   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=18
        strack(i)=smiv(1,i)*c1m18
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  130   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=19
        strack(i)=smiv(1,i)*c1m21
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  140   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=20
        strack(i)=smiv(1,i)*c1m24
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
!--DIPEDGE ELEMENT
  145   continue
        strack(i)=zero
        strackx(i)=ed(IX)*tiltc(i)
        stracks(i)=ed(IX)*tilts(i)
        strackz(i)=ek(IX)*tiltc(i)
        strackc(i)=ek(IX)*tilts(i)
        ktrack(i)=55
        goto 290
!--solenoid
  146   continue
        strack(i)=zero
        strackx(i)=ed(IX)
        strackz(i)=ek(IX)
        ktrack(i)=56
        goto 290
  150   r0=ek(ix)
        nmz=nmu(ix)
        if(abs(r0).le.pieni.or.nmz.eq.0) then
          if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).le.pieni) then
            ktrack(i)=31
          else if(abs(dki(ix,1)).gt.pieni.and.abs(dki(ix,2)).le.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=33
              strack(i)=dki(ix,1)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=35
              strack(i)=dki(ix,1)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          else if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).gt.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=37
              strack(i)=dki(ix,2)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=39
              strack(i)=dki(ix,2)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          endif
        else
          if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).le.pieni) then
            ktrack(i)=32
          else if(abs(dki(ix,1)).gt.pieni.and.abs(dki(ix,2)).le.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=34
              strack(i)=dki(ix,1)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=36
              strack(i)=dki(ix,1)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          else if(abs(dki(ix,1)).le.pieni.and.abs(dki(ix,2)).gt.pieni)  &
     &then
            if(abs(dki(ix,3)).gt.pieni) then
              ktrack(i)=38
              strack(i)=dki(ix,2)/dki(ix,3)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            else
              ktrack(i)=40
              strack(i)=dki(ix,2)
              strackc(i)=strack(i)*tiltc(i)
              stracks(i)=strack(i)*tilts(i)
            endif
          endif
        endif
        if(abs(r0).le.pieni.or.nmz.eq.0) goto 290
        if(mout2.eq.1) then
          benkcc=ed(ix)*benkc(irm(ix))
          r0a=one
          r000=r0*r00(irm(ix))
          do 160 j=1,mmul
!hr01       fake(1,j)=bbiv(j,1,i)*r0a/benkcc
            fake(1,j)=(bbiv(j,1,i)*r0a)/benkcc                           !hr01
!hr01       fake(2,j)=aaiv(j,1,i)*r0a/benkcc
            fake(2,j)=(aaiv(j,1,i)*r0a)/benkcc                           !hr01
  160     r0a=r0a*r000
          write(9,'(a16)') bez(ix)
          write(9,'(1p,3d23.15)') (fake(1,j), j=1,3)
          write(9,'(1p,3d23.15)') (fake(1,j), j=4,6)
          write(9,'(1p,3d23.15)') (fake(1,j), j=7,9)
          write(9,'(1p,3d23.15)') (fake(1,j), j=10,12)
          write(9,'(1p,3d23.15)') (fake(1,j), j=13,15)
          write(9,'(1p,3d23.15)') (fake(1,j), j=16,18)
          write(9,'(1p,2d23.15)') (fake(1,j), j=19,20)
          write(9,'(1p,3d23.15)') (fake(2,j), j=1,3)
          write(9,'(1p,3d23.15)') (fake(2,j), j=4,6)
          write(9,'(1p,3d23.15)') (fake(2,j), j=7,9)
          write(9,'(1p,3d23.15)') (fake(2,j), j=10,12)
          write(9,'(1p,3d23.15)') (fake(2,j), j=13,15)
          write(9,'(1p,3d23.15)') (fake(2,j), j=16,18)
          write(9,'(1p,2d23.15)') (fake(2,j), j=19,20)
          do 170 j=1,20
            fake(1,j)=zero
  170     fake(2,j)=zero
        endif
        goto 290
  180   kzz=-kzz
        goto(190,200,210,220,230,240,250,260,270,280),kzz
        ktrack(i)=31
        goto 290
  190   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=21
        strack(i)=smiv(1,i)*c1e3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  200   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=22
        strack(i)=smiv(1,i)
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  210   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=23
        strack(i)=smiv(1,i)*c1m3
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  220   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=24
        strack(i)=smiv(1,i)*c1m6
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  230   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=25
        strack(i)=smiv(1,i)*c1m9
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  240   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=26
        strack(i)=smiv(1,i)*c1m12
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  250   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=27
        strack(i)=smiv(1,i)*c1m15
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  260   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=28
        strack(i)=smiv(1,i)*c1m18
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  270   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=29
        strack(i)=smiv(1,i)*c1m21
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
        goto 290
  280   if(abs(smiv(1,i)).le.pieni) then
          ktrack(i)=31
          goto 290
        endif
        ktrack(i)=30
        strack(i)=smiv(1,i)*c1m24
        strackc(i)=strack(i)*tiltc(i)
        stracks(i)=strack(i)*tilts(i)
  290 continue
      do 300 j=1,napx
!hr01   dpsv1(j)=dpsv(j)*c1e3/(one+dpsv(j))
        dpsv1(j)=(dpsv(j)*c1e3)/(one+dpsv(j))                            !hr01
  300 continue
      nwri=nwr(3)
      if(nwri.eq.0) nwri=numl+numlr+1
      if(idp.eq.0.or.ition.eq.0) then
        call thck4d(nthinerr)
      else
!hr01   hsy(3)=c1m3*hsy(3)*ition
        hsy(3)=(c1m3*hsy(3))*dble(ition)                                 !hr01
        do 310 jj=1,nele
!hr01     if(kz(jj).eq.12) hsyc(jj)=c1m3*hsyc(jj)*itionc(jj)
          if(kz(jj).eq.12) hsyc(jj)=(c1m3*hsyc(jj))*dble(itionc(jj))     !hr01
  310   continue
        if(abs(phas).ge.pieni) then
          call thck6dua(nthinerr)
        else
          call thck6d(nthinerr)
        endif
      endif
      return
      end
      subroutine thck4d(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THICK LENS 4D
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,idz1,idz2,irrtr,ix,j,k,kpz,n,nmz,nthinerr
      double precision cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,crkveuk,&
     &crxb,crzb,dpsv3,pux,puxve,puzve,r0,r2b,rb,rho2b,rkb,tkb,xbb,xlvj, &
     &xrb,yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision e0fo,e0o,xv1j,xv2j
      double precision acdipamp, qd, acphase, acdipamp2,                &
     &acdipamp1,crabamp,crabfreq
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f,coord(1000),argf(1000),argi(1000)
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
!-----------------------------------------------------------------------
      nthinerr=0
      idz1=idz(1)
      idz2=idz(2)
      do 490 n=1,numl
          numx=n-1
          if(irip.eq.1) call ripple(n)
          if(mod(numx,nwri).eq.0) call writebin(nthinerr)
          if(nthinerr.ne.0) return
          do 480 i=1,iu
            if(ktrack(i).eq.1) then
              ix=ic(i)
            else
              ix=ic(i)-nblo
            endif
          if(i.eq.1103) then
          endif
!----------count=43
            goto(20,480,740,480,480,480,480,480,480,480,40,60,80,100,   &
     &120,140,160,180,200,220,270,290,310,330,350,370,390,410,          &
     &430,450,470,240,500,520,540,560,580,600,620,640,680,700,720,      &
     &480,748,480,480,480,480,480,745,746,751,752,753,754),ktrack(i)
            goto 480
   20       argf(1)=idz1
            argf(2)=idz2
            do 30 j=1,napx
              coord(1)=xv(1,j)
              coord(2)=xv(2,j)
              coord(3)=yv(1,j)
              coord(4)=yv(2,j)    
              coord(9)=dpsv(j)
              coord(19)=bl1v(1,1,j,ix)
              coord(20)=bl1v(2,1,j,ix)
              coord(21)=bl1v(3,1,j,ix)
              coord(22)=bl1v(4,1,j,ix)
              coord(23)=bl1v(5,1,j,ix)
              coord(24)=bl1v(6,1,j,ix)
              coord(49)=bl1v(1,2,j,ix)
              coord(50)=bl1v(2,2,j,ix)
              coord(51)=bl1v(3,2,j,ix)
              coord(52)=bl1v(4,2,j,ix)
              coord(53)=bl1v(5,2,j,ix)
              coord(54)=bl1v(6,2,j,ix)
              call thck4d_map_goto_index20(coord,argf,argi)
              xv(1,j)=coord(1)
              xv(2,j)=coord(2)
              yv(1,j)=coord(3)
              yv(2,j)=coord(4)
   30       continue
            goto 480
!--HORIZONTAL DIPOLE
   40       do 50 j=1,napx
            yv(1,j)=yv(1,j)+strackc(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+stracks(i)*oidpsv(j)
   50       continue
            goto 470
!--NORMAL QUADRUPOLE
   60       do 70 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   70       continue
            goto 470
!--NORMAL SEXTUPOLE
   80       do 90 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   90       continue
            goto 470
!--NORMAL OCTUPOLE
  100       do 110 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  110       continue
            goto 470
!--NORMAL DECAPOLE
  120       do 130 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  130       continue
            goto 470
!--NORMAL DODECAPOLE
  140       do 150 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  150       continue
            goto 470
!--NORMAL 14-POLE
  160       do 170 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  170       continue
            goto 470
!--NORMAL 16-POLE
  180       do 190 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  190       continue
            goto 470
!--NORMAL 18-POLE
  200       do 210 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  210       continue
            goto 470
!--NORMAL 20-POLE
  220       do 230 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  230       continue
            goto 470
  500     continue
          do 510 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
  510     continue
          goto 470
  520     continue
          do 530 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
  530     continue
          goto 240
  540     continue
          do 550 j=1,napx
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
  550     continue
          goto 470
  560     continue
          do 570 j=1,napx
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
  570     continue
          goto 240
  580     continue
          do 590 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
  590     continue
          goto 470
  600     continue
          do 610 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
  610     continue
          goto 240
  620     continue
          do 630 j=1,napx
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
  630     continue
          goto 470
  640     continue
          do 650 j=1,napx
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
  650     continue
  240       r0=ek(ix)
            nmz=nmu(ix)
          if(nmz.ge.2) then
            do 260 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 250 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  250           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  260       continue
          else
            do 265 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  265       continue
          endif
            goto 470
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  270       do 280 j=1,napx
            yv(1,j)=yv(1,j)-stracks(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+strackc(i)*oidpsv(j)
  280       continue
            goto 470
!--SKEW QUADRUPOLE
  290       do 300 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  300       continue
            goto 470
!--SKEW SEXTUPOLE
  310       do 320 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  320       continue
            goto 470
!--SKEW OCTUPOLE
  330       do 340 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  340       continue
            goto 470
!--SKEW DECAPOLE
  350       do 360 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  360       continue
            goto 470
!--SKEW DODECAPOLE
  370       do 380 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  380       continue
            goto 470
!--SKEW 14-POLE
  390       do 400 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  400       continue
            goto 470
!--SKEW 16-POLE
  410       do 420 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  420       continue
            goto 470
!--SKEW 18-POLE
  430       do 440 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  440       continue
            goto 470
!--SKEW 20-POLE
  450       do 460 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  460       continue
          goto 470
  680     continue
          do 690 j=1,napx
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 690
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
            if(ibbc.eq.0) then
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))
          yv(1,j)=yv(1,j)+oidpsv(j)*(((strack(i)*crkveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))                      !hr03
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))
          yv(2,j)=yv(2,j)+oidpsv(j)*(((strack(i)*cikveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))                      !hr03
            else
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
              yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
              yv(2,j)=yv(2,j)+oidpsv(j)*cccc
            endif
  690     continue
          goto 470
  700     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 470
  720     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 470
  740     continue
          irrtr=imtr(ix)
          do j=1,napx
            pux=xv(1,j)
            dpsv3(j)=dpsv(j)*c1e3
!hr03       xv(1,j)=cotr(irrtr,1)+rrtr(irrtr,1,1)*pux+                  &
!hr03&rrtr(irrtr,1,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,1,6)
            xv(1,j)=((cotr(irrtr,1)+rrtr(irrtr,1,1)*pux)+               &!hr03
     &rrtr(irrtr,1,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,1,6)   !hr03
!hr03       yv(1,j)=cotr(irrtr,2)+rrtr(irrtr,2,1)*pux+                  &
!hr03&rrtr(irrtr,2,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,2,6)
            yv(1,j)=((cotr(irrtr,2)+rrtr(irrtr,2,1)*pux)+               &!hr03
     &rrtr(irrtr,2,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,2,6)   !hr03
            pux=xv(2,j)
!hr03       xv(2,j)=cotr(irrtr,3)+rrtr(irrtr,3,3)*pux+                  &
!hr03&rrtr(irrtr,3,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,3,6)
            xv(2,j)=((cotr(irrtr,3)+rrtr(irrtr,3,3)*pux)+               &!hr03
     &rrtr(irrtr,3,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,3,6)   !hr03
!hr03       yv(2,j)=cotr(irrtr,4)+rrtr(irrtr,4,3)*pux+                  &
!hr03&rrtr(irrtr,4,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,4,6)
            yv(2,j)=((cotr(irrtr,4)+rrtr(irrtr,4,3)*pux)+               &!hr03
     &rrtr(irrtr,4,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,4,6)   !hr03
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 470
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 470
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 470
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
          argf(1)=crabamp
          argf(2)=crabfreq
          argf(3)=crabph(ix)
          argf(4)=ed(ix)
          argf(5)=pma
          argf(6)=e0
          argf(7)=e0f
          argf(8)=ithick
        do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin6d_map_crab_cavity_1(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 470
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
          argf(1)=crabamp
          argf(2)=crabfreq
          argf(3)=crabph(ix)
          argf(4)=ed(ix)
          argf(5)=pma
          argf(6)=e0
          argf(7)=e0f
          argf(8)=ithick
        do j=1,napx
            coord(1)=xv(1,j)
            coord(2)=xv(2,j)
            coord(3)=yv(1,j)
            coord(4)=yv(2,j)
            coord(5)=oidpsv(j)
            coord(6)=sigmv(j)
            coord(7)=ejv(j)
            coord(8)=ejfv(j)
            coord(9)=dpsv(j)
            coord(10)=dpsv1(j)
            call thin6d_map_crab_cavity_2(coord,argf,argi)
            yv(1,j)=coord(3)
            yv(2,j)=coord(4)
            oidpsv(j)=coord(5)
            ejv(j)=coord(7)
            ejfv(j)=coord(8)
            dpsv(j)=coord(9)
            dpsv1(j)=coord(10)
            rvv(j)=coord(13)
            ejf0v(j)=coord(14)
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 470
!--DIPEDGE ELEMENT
  753     continue
          do j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackx(i)*crkve-                &
     &stracks(i)*cikve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackz(i)*cikve+                &
     &strackc(i)*crkve)
          enddo
          goto 470
!--solenoid
  754     continue
          do j=1,napx
            yv(1,j)=yv(1,j)-xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)+xv(1,j)*strackx(i)
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       yv(1,j)=crkve*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&cikve*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       yv(2,j)=-crkve*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&cikve*cos(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       crkve=xv(1,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&xv(2,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       cikve=-xv(1,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&xv(2,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))
            yv(1,j)=crkve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &cikve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            yv(2,j)=cikve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &crkve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            crkve=xv(1,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &xv(2,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            cikve=xv(2,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &xv(1,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            xv(1,j)=crkve
            xv(2,j)=cikve
            yv(1,j)=yv(1,j)+xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)-xv(1,j)*strackx(i)
          enddo
          goto 470
 
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      do 750 j=1, napx
 
      xv(1,j) = xv(1,j) * c1m3
      xv(2,j) = xv(2,j) * c1m3
      yv(1,j) = yv(1,j) * c1m3
      yv(2,j) = yv(2,j) * c1m3
 
!      write(*,*) 'Start: ',j,xv(1,j),xv(2,j),yv(1,j),
!     &yv(2,j)
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) -                                               &!hr03
     &((embl*0.5d0)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) -                                               &!hr03
     &((embl*0.5d0)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
 
!     call tilt(tx,ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(tx)*yv(2,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(tx))*yv(2,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(1,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-tx)                                                   !hr03
!+if crlibm
!hhr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
      xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(1,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(ty)*yv(1,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(ty))*yv(1,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
      xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
 
!     call drift(lin)
 
!hr03 xv(1,j) = xv(1,j) + lin*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) + (lin*yv(1,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) + lin*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) + (lin*yv(2,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
!      call kick(l,cur,lin,rx,ry,chi)
 
      xi = xv(1,j)-rx
      yi = xv(2,j)-ry
!hr03 yv(1,j) = yv(1,j)-c1m7*cur/chi*xi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(1,j) = yv(1,j)-((((c1m7*cur)/chi)*xi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
!GRD FOR CONSISTENSY
!hr03 yv(2,j) = yv(2,j)-c1m7*cur/chi*yi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(2,j) = yv(2,j)-((((c1m7*cur)/chi)*yi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
 
!     call drift(leff-lin)
 
!hr03 xv(1,j) = xv(1,j) + (leff-lin)*yv(1,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(1,j) = xv(1,j) + ((leff-lin)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
!hr03 xv(2,j) = xv(2,j) + (leff-lin)*yv(2,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(2,j) = xv(2,j) + ((leff-lin)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
 
!     call invtilt(tx,ty)
 
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(-ty)*yv(1,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(-ty))*yv(1,j))/               &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))+ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(-ty)-sin_rn(-ty)*tan_rn(atan_rn(yv(2,j)/&
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
      xv(2,j) = xv(2,j)*                                                &!hr03
     &(cos_rn(-1d0*ty)-sin_rn(-1d0*ty)*tan_rn(atan_rn(yv(2,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(-tx)*yv(2,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(-1d0*tx))*yv(2,j))/           &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/cos_rn(atan_rn(yv(1,j)/        &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!+if crlibm
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(-tx)-sin_rn(-tx)*tan_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
      xv(1,j) = xv(1,j)*                                                &!hr03
     &(cos_rn(-1d0*tx)-sin_rn(-1d0*tx)*tan_rn(atan_rn(yv(1,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                       !hr03
     &sin_rn(atan_rn(yv(1,j)/                                            !hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
 
!     call shift(-embl*tan(tx),-embl*tan(ty)/cos(tx))
 
      xv(1,j) = xv(1,j) + embl*tan_rn(tx)
!hr03 xv(2,j) = xv(2,j) + embl*tan_rn(ty)/cos_rn(tx)
      xv(2,j) = xv(2,j) + (embl*tan_rn(ty))/cos_rn(tx)                   !hr03
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) - ((embl*0.5d0)*yv(1,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) - ((embl*0.5d0)*yv(2,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
      xv(1,j) = xv(1,j) * c1e3
      xv(2,j) = xv(2,j) * c1e3
      yv(1,j) = yv(1,j) * c1e3
      yv(2,j) = yv(2,j) * c1e3
 
!      write(*,*) 'End: ',j,xv(1,j),xv(2,j),yv(1,j),                       &
!     &yv(2,j)
 
!-----------------------------------------------------------------------
 
  750     continue
          goto 470
 
!----------------------------
 
  470       continue
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  480     continue
          call lostpart(nthinerr)
          if(nthinerr.ne.0) return
          if(ntwin.ne.2) call dist1
          if(mod(n,nwr(4)).eq.0) call write6(n)
  490 continue
      return
      end
      subroutine thck6d(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THICK LENS 6D
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,idz1,idz2,irrtr,ix,j,jb,jmel,jx,k,kpz,n,nmz,nthinerr
      double precision cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,crkveuk,&
     &crxb,crzb,dpsv3,pux,puxve1,puxve2,puzve1,puzve2,r0,r2b,rb,rho2b,  &
     &rkb,tkb,xbb,xlvj,xrb,yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision e0fo,e0o,xv1j,xv2j
      double precision acdipamp, qd, acphase,acdipamp2,                 &
     &acdipamp1, crabamp, crabfreq
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f,coord(1000),argf(1000),argi(1000)
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
      nthinerr=0
      idz1=idz(1)
      idz2=idz(2)
! Now the outer loop over turns
      do 510 n=1,numl
! To do a dump and abend
          numx=n-1
          if(irip.eq.1) call ripple(n)
          if(mod(numx,nwri).eq.0) call writebin(nthinerr)
          if(nthinerr.ne.0) return
          do 500 i=1,iu
            if(ktrack(i).eq.1) then
              ix=ic(i)
            else
              ix=ic(i)-nblo
            endif
!----------count 44
!----------count 54! Eric
            goto(20,40,740,500,500,500,500,500,500,500,60,80,100,120,   &
     &140,160,180,200,220,240,290,310,330,350,370,390,410,430,          &
     &450,470,490,260,520,540,560,580,600,620,640,660,680,700,720       &
     &,730,748,500,500,500,500,500,745,746,751,752,753,754),ktrack(i)
            goto 500
   20       jmel=mel(ix)
            do 30 jb=1,jmel
              jx=mtyp(ix,jb)
              do 30 j=1,napx
                coord(1)=xv(1,j)
                coord(2)=xv(2,j)
                coord(3)=yv(1,j)
                coord(4)=yv(2,j)
                coord(6)=sigmv(j)
                coord(25)=as(1,1,j,jx)
                coord(26)=as(2,1,j,jx)
                coord(27)=as(3,1,j,jx)
                coord(28)=as(4,1,j,jx)
                coord(29)=as(5,1,j,jx)
                coord(30)=as(6,1,j,jx)
                coord(31)=as(1,2,j,jx)
                coord(32)=as(2,2,j,jx)
                coord(33)=as(3,2,j,jx)
                coord(34)=as(4,2,j,jx)
                coord(35)=as(5,2,j,jx)
                coord(36)=as(6,2,j,jx)
                coord(37)=al(1,1,j,jx)
                coord(38)=al(2,1,j,jx)
                coord(39)=al(3,1,j,jx)
                coord(40)=al(4,1,j,jx)
                coord(41)=al(5,1,j,jx)
                coord(42)=al(6,1,j,jx)
                coord(43)=al(1,2,j,jx)
                coord(44)=al(2,2,j,jx)
                coord(45)=al(3,2,j,jx)
                coord(46)=al(4,2,j,jx)
                coord(47)=al(5,2,j,jx)
                coord(48)=al(6,2,j,jx)
                call thck6d_map_goto_index20(coord,argf,argi)
                xv(1,j)=coord(1)
                xv(2,j)=coord(2)
                yv(1,j)=coord(3)
                yv(2,j)=coord(4)
   30       continue
            goto 500
   40       do 50 j=1,napx
              ejf0v(j)=ejfv(j)
              if(abs(dppoff).gt.pieni) sigmv(j)=sigmv(j)-sigmoff(i)
              if(kz(ix).eq.12) then
                ejv(j)=ejv(j)+ed(ix)*sin_rn(hsyc(ix)*sigmv(j)+
     &phasc(ix))
              else
                ejv(j)=ejv(j)+hsy(1)*sin_rn(hsy(3)*sigmv(j))
              endif
!hr01         ejfv(j)=sqrt(ejv(j)*ejv(j)-pma*pma)
              ejfv(j)=sqrt(ejv(j)**2-pma**2)                             !hr01
              rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
              dpsv(j)=(ejfv(j)-e0f)/e0f
              oidpsv(j)=one/(one+dpsv(j))
!hr01         dpsv1(j)=dpsv(j)*c1e3*oidpsv(j)
              dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)                          !hr01
!hr01         yv(1,j)=ejf0v(j)/ejfv(j)*yv(1,j)
              yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)                         !hr01
!hr01   50       yv(2,j)=ejf0v(j)/ejfv(j)*yv(2,j)
   50       yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)                           !hr01
            if(n.eq.1) write(98,'(1p,6(2x,e25.18))')                    &
     &(xv(1,j),yv(1,j),xv(2,j),yv(2,j),sigmv(j),dpsv(j),                &
     &j=1,napx)
            call synuthck
            goto 490
!--HORIZONTAL DIPOLE
   60       do 70 j=1,napx
            yv(1,j)=yv(1,j)+strackc(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+stracks(i)*oidpsv(j)
   70       continue
            goto 490
!--NORMAL QUADRUPOLE
   80       do 90 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   90       continue
            goto 490
!--NORMAL SEXTUPOLE
  100       do 110 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  110       continue
            goto 490
!--NORMAL OCTUPOLE
  120       do 130 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  130       continue
            goto 490
!--NORMAL DECAPOLE
  140       do 150 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  150       continue
            goto 490
!--NORMAL DODECAPOLE
  160       do 170 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  170       continue
            goto 490
!--NORMAL 14-POLE
  180       do 190 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  190       continue
            goto 490
!--NORMAL 16-POLE
  200       do 210 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  210       continue
            goto 490
!--NORMAL 18-POLE
  220       do 230 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  230       continue
            goto 490
!--NORMAL 20-POLE
  240       do 250 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  250       continue
            goto 490
  520       continue
            do 530 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  530       continue
            goto 490
  540       continue
            do 550 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  550       continue
            goto 260
  560       continue
            do 570 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  570       continue
            goto 490
  580       continue
            do 590 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  590       continue
            goto 260
  600       continue
            do 610 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  610       continue
            goto 490
  620       continue
            do 630 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  630       continue
            goto 260
  640       continue
            do 650 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  650       continue
            goto 490
  660       continue
            do 670 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  670       continue
  260       r0=ek(ix)
            nmz=nmu(ix)
          if(nmz.ge.2) then
            do 280 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 270 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  270           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  280       continue
          else
            do 275 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  275       continue
          endif
            goto 490
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  290       do 300 j=1,napx
            yv(1,j)=yv(1,j)-stracks(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+strackc(i)*oidpsv(j)
  300       continue
            goto 490
!--SKEW QUADRUPOLE
  310       do 320 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  320       continue
            goto 490
!--SKEW SEXTUPOLE
  330       do 340 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  340       continue
            goto 490
!--SKEW OCTUPOLE
  350       do 360 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  360       continue
            goto 490
!--SKEW DECAPOLE
  370       do 380 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  380       continue
            goto 490
!--SKEW DODECAPOLE
  390       do 400 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  400       continue
            goto 490
!--SKEW 14-POLE
  410       do 420 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  420       continue
            goto 490
!--SKEW 16-POLE
  430       do 440 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  440       continue
            goto 490
!--SKEW 18-POLE
  450       do 460 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  460       continue
            goto 490
!--SKEW 20-POLE
  470       do 480 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  480       continue
          goto 490
  680     continue
          do 690 j=1,napx
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 690
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
            if(ibbc.eq.0) then
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))
          yv(1,j)=yv(1,j)+oidpsv(j)*(((strack(i)*crkveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))                      !hr03
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))
          yv(2,j)=yv(2,j)+oidpsv(j)*(((strack(i)*cikveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))                      !hr03
            else
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
              yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
              yv(2,j)=yv(2,j)+oidpsv(j)*cccc
            endif
  690     continue
          goto 490
  700     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 490
  720     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 490
  730     continue
!--Hirata's 6D beam-beam kick
            do j=1,napx
!hr03         track6d(1,j)=(xv(1,j)+ed(ix)-clobeam(1,imbb(i)))*c1m3
              track6d(1,j)=((xv(1,j)+ed(ix))-clobeam(1,imbb(i)))*c1m3    !hr03
              track6d(2,j)=(yv(1,j)/oidpsv(j)-clobeam(4,imbb(i)))*c1m3
!hr03         track6d(3,j)=(xv(2,j)+ek(ix)-clobeam(2,imbb(i)))*c1m3
              track6d(3,j)=((xv(2,j)+ek(ix))-clobeam(2,imbb(i)))*c1m3    !hr03
              track6d(4,j)=(yv(2,j)/oidpsv(j)-clobeam(5,imbb(i)))*c1m3
              track6d(5,j)=(sigmv(j)-clobeam(3,imbb(i)))*c1m3
              track6d(6,j)=dpsv(j)-clobeam(6,imbb(i))
            enddo
            call beamint(napx,track6d,parbe,sigz,bbcu,imbb(i),ix,ibtyp, &
     &ibbc)
            do j=1,napx
!hr03         xv(1,j)=track6d(1,j)*c1e3+clobeam(1,imbb(i))-             &
              xv(1,j)=(track6d(1,j)*c1e3+clobeam(1,imbb(i)))-           &!hr03
     &beamoff(1,imbb(i))
!hr03         xv(2,j)=track6d(3,j)*c1e3+clobeam(2,imbb(i))-             &
              xv(2,j)=(track6d(3,j)*c1e3+clobeam(2,imbb(i)))-           &!hr03
     &beamoff(2,imbb(i))
!hr03         dpsv(j)=track6d(6,j)+clobeam(6,imbb(i))-beamoff(6,imbb(i))
              dpsv(j)=(track6d(6,j)+clobeam(6,imbb(i)))-                &!hr03
     &beamoff(6,imbb(i))                                                 !hr03
              oidpsv(j)=one/(one+dpsv(j))
!hr03         yv(1,j)=(track6d(2,j)*c1e3+clobeam(4,imbb(i))-            &
              yv(1,j)=((track6d(2,j)*c1e3+clobeam(4,imbb(i)))-          &!hr03
     &beamoff(4,imbb(i)))*oidpsv(j)
!hr03         yv(2,j)=(track6d(4,j)*c1e3+clobeam(5,imbb(i))-            &
              yv(2,j)=((track6d(4,j)*c1e3+clobeam(5,imbb(i)))-          &!hr03
     &beamoff(5,imbb(i)))*oidpsv(j)
              ejfv(j)=dpsv(j)*e0f+e0f
!hr03         ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
              ejv(j)=sqrt(ejfv(j)**2+pma**2)
              rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
              if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
            enddo
          goto 490
  740     continue
          irrtr=imtr(ix)
          do j=1,napx
!hr03       sigmv(j)=sigmv(j)+cotr(irrtr,5)+rrtr(irrtr,5,1)*xv(1,j)+    &
!hr03&rrtr(irrtr,5,2)*yv(1,j)+rrtr(irrtr,5,3)*xv(2,j)+                  &
!hr03&rrtr(irrtr,5,4)*yv(2,j)+rrtr(irrtr,5,6)*dpsv(j)*c1e3
      sigmv(j)=(((((sigmv(j)+cotr(irrtr,5))+rrtr(irrtr,5,1)*xv(1,j))+   &!hr03
     &rrtr(irrtr,5,2)*yv(1,j))+rrtr(irrtr,5,3)*xv(2,j))+                &!hr03
!BNL-NOV08
!     &rrtr(irrtr,5,4)*yv(2,j)
     &rrtr(irrtr,5,4)*yv(2,j))+(rrtr(irrtr,5,6)*dpsv(j))*c1e3            !hr03
!BNL-NOV08
            pux=xv(1,j)
            dpsv3(j)=dpsv(j)*c1e3
!hr03       xv(1,j)=cotr(irrtr,1)+rrtr(irrtr,1,1)*pux+                  &
!hr03&rrtr(irrtr,1,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,1,6)
            xv(1,j)=((cotr(irrtr,1)+rrtr(irrtr,1,1)*pux)+               &!hr03
     &rrtr(irrtr,1,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,1,6)   !hr03
!hr03       yv(1,j)=cotr(irrtr,2)+rrtr(irrtr,2,1)*pux+                  &
!hr03&rrtr(irrtr,2,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,2,6)
            yv(1,j)=((cotr(irrtr,2)+rrtr(irrtr,2,1)*pux)+               &!hr03
     &rrtr(irrtr,2,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,2,6)   !hr03
            pux=xv(2,j)
!hr03       xv(2,j)=cotr(irrtr,3)+rrtr(irrtr,3,3)*pux+                  &
!hr03&rrtr(irrtr,3,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,3,6)
            xv(2,j)=((cotr(irrtr,3)+rrtr(irrtr,3,3)*pux)+               &!hr03
     &rrtr(irrtr,3,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,3,6)   !hr03
!hr03       yv(2,j)=cotr(irrtr,4)+rrtr(irrtr,4,3)*pux+                  &
!hr03&rrtr(irrtr,4,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,4,6)
            yv(2,j)=((cotr(irrtr,4)+rrtr(irrtr,4,3)*pux)+               &!hr03
     &rrtr(irrtr,4,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,4,6)   !hr03
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 490
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 490
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 490
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 490
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 490
!--DIPEDGE ELEMENT
  753     continue
          do j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackx(i)*crkve-                &
     &stracks(i)*cikve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackz(i)*cikve+                &
     &strackc(i)*crkve)
          enddo
          goto 490
!--solenoid
  754     continue
          do j=1,napx
            yv(1,j)=yv(1,j)-xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)+xv(1,j)*strackx(i)
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       yv(1,j)=crkve*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&cikve*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       yv(2,j)=-crkve*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&cikve*cos(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       crkve=xv(1,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&xv(2,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       cikve=-xv(1,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&xv(2,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))
            yv(1,j)=crkve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &cikve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            yv(2,j)=cikve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &crkve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            crkve=xv(1,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &xv(2,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            cikve=xv(2,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &xv(1,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            xv(1,j)=crkve
            xv(2,j)=cikve
            yv(1,j)=yv(1,j)+xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)-xv(1,j)*strackx(i)
!hr02       crkve=sigmv(j)-0.5*(xv(1,j)*xv(1,j)+xv(2,j)*xv(2,j))*       &
!hr02&strackx(i)*strackz(i)*rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
        crkve=sigmv(j)-0.5d0*(((((((xv(1,j)**2+xv(2,j)**2)*strackx(i))* &!hr02
     &strackz(i))*rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)           !hr02
            sigmv(j)=crkve
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       sigmv(j)=sigmv(j)+(xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i)* &
!hr02&rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
      sigmv(j)=sigmv(j)+((((((xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i))* &!hr02
     &rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)                       !hr02
          enddo
          goto 490
 
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      do 750 j=1, napx
 
      xv(1,j) = xv(1,j) * c1m3
      xv(2,j) = xv(2,j) * c1m3
      yv(1,j) = yv(1,j) * c1m3
      yv(2,j) = yv(2,j) * c1m3
 
!      write(*,*) 'Start: ',j,xv(1,j),xv(2,j),yv(1,j),
!     &yv(2,j)
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) -                                               &!hr03
     &((embl*0.5d0)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) -                                               &!hr03
     &((embl*0.5d0)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
 
!     call tilt(tx,ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(tx)*yv(2,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(tx))*yv(2,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(1,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-tx)                                                   !hr03
!+if crlibm
!hhr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
      xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(1,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(ty)*yv(1,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(ty))*yv(1,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
      xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
 
!     call drift(lin)
 
!hr03 xv(1,j) = xv(1,j) + lin*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) + (lin*yv(1,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) + lin*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) + (lin*yv(2,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
!      call kick(l,cur,lin,rx,ry,chi)
 
      xi = xv(1,j)-rx
      yi = xv(2,j)-ry
!hr03 yv(1,j) = yv(1,j)-c1m7*cur/chi*xi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(1,j) = yv(1,j)-((((c1m7*cur)/chi)*xi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
!GRD FOR CONSISTENSY
!hr03 yv(2,j) = yv(2,j)-c1m7*cur/chi*yi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(2,j) = yv(2,j)-((((c1m7*cur)/chi)*yi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
 
!     call drift(leff-lin)
 
!hr03 xv(1,j) = xv(1,j) + (leff-lin)*yv(1,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(1,j) = xv(1,j) + ((leff-lin)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
!hr03 xv(2,j) = xv(2,j) + (leff-lin)*yv(2,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(2,j) = xv(2,j) + ((leff-lin)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
 
!     call invtilt(tx,ty)
 
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(-ty)*yv(1,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(-ty))*yv(1,j))/               &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))+ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(-ty)-sin_rn(-ty)*tan_rn(atan_rn(yv(2,j)/&
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
      xv(2,j) = xv(2,j)*                                                &!hr03
     &(cos_rn(-1d0*ty)-sin_rn(-1d0*ty)*tan_rn(atan_rn(yv(2,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(-tx)*yv(2,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(-1d0*tx))*yv(2,j))/           &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/cos_rn(atan_rn(yv(1,j)/        &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!+if crlibm
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(-tx)-sin_rn(-tx)*tan_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
      xv(1,j) = xv(1,j)*                                                &!hr03
     &(cos_rn(-1d0*tx)-sin_rn(-1d0*tx)*tan_rn(atan_rn(yv(1,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                       !hr03
     &sin_rn(atan_rn(yv(1,j)/                                            !hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
 
!     call shift(-embl*tan(tx),-embl*tan(ty)/cos(tx))
 
      xv(1,j) = xv(1,j) + embl*tan_rn(tx)
!hr03 xv(2,j) = xv(2,j) + embl*tan_rn(ty)/cos_rn(tx)
      xv(2,j) = xv(2,j) + (embl*tan_rn(ty))/cos_rn(tx)                   !hr03
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) - ((embl*0.5d0)*yv(1,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) - ((embl*0.5d0)*yv(2,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
      xv(1,j) = xv(1,j) * c1e3
      xv(2,j) = xv(2,j) * c1e3
      yv(1,j) = yv(1,j) * c1e3
      yv(2,j) = yv(2,j) * c1e3
 
!      write(*,*) 'End: ',j,xv(1,j),xv(2,j),yv(1,j),                       &
!     &yv(2,j)
 
!-----------------------------------------------------------------------
 
  750     continue
          goto 490
 
!----------------------------
 
  490       continue
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  500     continue
          call lostpart(nthinerr)
          if(nthinerr.ne.0) return
          if(ntwin.ne.2) call dist1
          if(mod(n,nwr(4)).eq.0) call write6(n)
  510 continue
      return
      end
      subroutine thck6dua(nthinerr)
!-----------------------------------------------------------------------
!
!  TRACK THICK LENS  6D WITH ACCELERATION
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer i,idz1,idz2,irrtr,ix,j,jb,jmel,jx,k,kpz,n,nmz,nthinerr
      double precision cbxb,cbzb,cccc,cikve,cikveb,crkve,crkveb,crkveuk,&
     &crxb,crzb,dpsv3,e0fo,e0o,pux,puxve1,puxve2,puzve1,puzve2,r0,r2b,  &
     &rb,rho2b,rkb,tkb,xbb,xlvj,xrb,yv1j,yv2j,zbb,zlvj,zrb
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      integer ireturn, xory, nac, nfree, nramp1,nplato, nramp2
      double precision xv1j,xv2j
      double precision acdipamp, qd, acphase,acdipamp2,                 &
     &acdipamp1, crabamp, crabfreq
      double precision l,cur,dx,dy,tx,ty,embl,leff,rx,ry,lin,chi,xi,yi
      logical llost
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer nnumxv
      common/postr2/nnumxv(npart)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      double precision cc,xlim,ylim
      parameter(cc = 1.12837916709551d0)
      parameter(xlim = 5.33d0)
      parameter(ylim = 4.29d0)
      dimension crkveb(npart),cikveb(npart),rho2b(npart),tkb(npart),    &
     &r2b(npart),rb(npart),rkb(npart),                                  &
     &xrb(npart),zrb(npart),xbb(npart),zbb(npart),crxb(npart),          &
     &crzb(npart),cbxb(npart),cbzb(npart)
      dimension dpsv3(npart)
      save
!-----------------------------------------------------------------------
      nthinerr=0
      idz1=idz(1)
      idz2=idz(2)
      do 510 n=1,numl
          numx=n-1
          if(irip.eq.1) call ripple(n)
          if(n.le.nde(1)) nwri=nwr(1)
          if(n.gt.nde(1).and.n.le.nde(2)) nwri=nwr(2)
          if(n.gt.nde(2)) nwri=nwr(3)
          if(nwri.eq.0) nwri=numl+numlr+1
          if(mod(numx,nwri).eq.0) call writebin(nthinerr)
          if(nthinerr.ne.0) return
          do 500 i=1,iu
            if(ktrack(i).eq.1) then
              ix=ic(i)
            else
              ix=ic(i)-nblo
            endif
!----------count 44
            goto(20,40,740,500,500,500,500,500,500,500,60,80,100,120,   &
     &140,160,180,200,220,240,290,310,330,350,370,390,410,430,          &
     &450,470,490,260,520,540,560,580,600,620,640,660,680,700,720       &
     &,730,748,500,500,500,500,500,745,746,751,752,753,754),ktrack(i)
            goto 500
   20       jmel=mel(ix)
            do 30 jb=1,jmel
              jx=mtyp(ix,jb)
              do 30 j=1,napx
                puxve1=xv(1,j)
                puzve1=yv(1,j)
                puxve2=xv(2,j)
                puzve2=yv(2,j)

         sigmv(j)=(((((sigmv(j)+as(1,1,j,jx))+puxve1*((as(2,1,j,jx)+ as &!hr03
     &(4,1,j,jx)*puzve1)+as(5,1,j,jx)*puxve1))+ puzve1*(as              &!hr03
     &(3,1,j,jx)+as(6,1,j,jx)*puzve1))                                  &!hr03
     &+as(1,2,j,jx))+puxve2*(as(2,2,j,jx)+ as                           &!hr03
     &(4,2,j,jx)*puzve2+as(5,2,j,jx)*puxve2))+ puzve2*(as               &!hr03
     &(3,2,j,jx)+as(6,2,j,jx)*puzve2)                                    !hr03

        xv(1,j)=(al(1,1,j,jx)*puxve1+ al(2,1,j,jx)*puzve1)+dble(idz1)*al&!hr03
     &(5,1,j,jx)                                                         !hr03

        xv(2,j)=(al(1,2,j,jx)*puxve2+ al(2,2,j,jx)*puzve2)+dble(idz2)*al&!hr03
     &(5,2,j,jx)                                                         !hr03

        yv(1,j)=(al(3,1,j,jx)*puxve1+ al(4,1,j,jx)*puzve1)+dble(idz1)*al&!hr03
     &(6,1,j,jx)                                                         !hr03

        yv(2,j)=(al(3,2,j,jx)*puxve2+ al(4,2,j,jx)*puzve2)+dble(idz2)*al&!hr03
     &(6,2,j,jx)                                                         !hr03
   30       continue
            goto 500
   40       e0o=e0
            e0fo=e0f
            call adia(n,e0f)
            do 50 j=1,napx
              ejf0v(j)=ejfv(j)
              if(abs(dppoff).gt.pieni) sigmv(j)=sigmv(j)-sigmoff(i)
!hr01         if(sigmv(j).lt.zero) sigmv(j)=e0f*e0o/(e0fo*e0)*sigmv(j)
            if(sigmv(j).lt.zero) sigmv(j)=((e0f*e0o)/(e0fo*e0))*sigmv(j) !hr01
              if(kz(ix).eq.12) then
!hr01           ejv(j)=ejv(j)+ed(ix)*sin_rn(hsyc(ix)*sigmv(j)+phas+
                ejv(j)=ejv(j)+ed(ix)*sin_rn((hsyc(ix)*sigmv(j)+phas)+   &!hr01
     &phasc(ix))
              else
                ejv(j)=ejv(j)+hsy(1)*sin_rn(hsy(3)*sigmv(j)+phas)
              endif
!hr01         ejfv(j)=sqrt(ejv(j)*ejv(j)-pma*pma)
              ejfv(j)=sqrt(ejv(j)**2-pma**2)                             !hr01
              rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
              dpsv(j)=(ejfv(j)-e0f)/e0f
              oidpsv(j)=one/(one+dpsv(j))
!hr01         dpsv1(j)=dpsv(j)*c1e3*oidpsv(j)
              dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)                          !hr01
!hr01         if(sigmv(j).gt.zero) sigmv(j)=e0f*e0o/(e0fo*e0)*sigmv(j)
            if(sigmv(j).gt.zero) sigmv(j)=((e0f*e0o)/(e0fo*e0))*sigmv(j) !hr01
!hr01         yv(1,j)=ejf0v(j)/ejfv(j)*yv(1,j)
              yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)                         !hr01
!hr01   50       yv(2,j)=ejf0v(j)/ejfv(j)*yv(2,j)
   50       yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)                           !hr01
            if(n.eq.1) write(98,'(1p,6(2x,e25.18))')                    &
     &(xv(1,j),yv(1,j),xv(2,j),yv(2,j),sigmv(j),dpsv(j),                &
     &j=1,napx)
            call synuthck
            goto 490
!--HORIZONTAL DIPOLE
   60       do 70 j=1,napx
            yv(1,j)=yv(1,j)+strackc(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+stracks(i)*oidpsv(j)
   70       continue
            goto 490
!--NORMAL QUADRUPOLE
   80       do 90 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
   90       continue
            goto 490
!--NORMAL SEXTUPOLE
  100       do 110 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  110       continue
            goto 490
!--NORMAL OCTUPOLE
  120       do 130 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  130       continue
            goto 490
!--NORMAL DECAPOLE
  140       do 150 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  150       continue
            goto 490
!--NORMAL DODECAPOLE
  160       do 170 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  170       continue
            goto 490
!--NORMAL 14-POLE
  180       do 190 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  190       continue
            goto 490
!--NORMAL 16-POLE
  200       do 210 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  210       continue
            goto 490
!--NORMAL 18-POLE
  220       do 230 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  230       continue
            goto 490
!--NORMAL 20-POLE
  240       do 250 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
!hr02       yv(2,j)=yv(2,j)+oidpsv(j)*(-strackc(i)*cikve+               &
!hr02&stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(stracks(i)*crkve-                &!hr02
     &strackc(i)*cikve)                                                  !hr02
  250       continue
            goto 490
  520       continue
            do 530 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  530       continue
            goto 490
  540       continue
            do 550 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tiltc(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tiltc(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*xlvj*oidpsv(j)                   &
!hr03&+dpsv1(j))*dki(ix,1)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-(((strack(i)*xlvj)*oidpsv(j)               &!hr03
     &+dpsv1(j))*dki(ix,1))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  550       continue
            goto 260
  560       continue
            do 570 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  570       continue
            goto 490
  580       continue
            do 590 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-strackc(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*(one-tiltc(i))
            yv(1,j)=(yv(1,j)-strackc(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       yv(2,j)=yv(2,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,1)*oidpsv(j)*tilts(i)
            yv(2,j)=(yv(2,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,1))*oidpsv(j))*tilts(i)                             !hr03
!hr03       sigmv(j)=sigmv(j)+rvv(j)*dki(ix,1)*xlvj
            sigmv(j)=sigmv(j)+(rvv(j)*dki(ix,1))*xlvj                    !hr03
  590       continue
            goto 260
  600       continue
            do 610 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  610       continue
            goto 490
  620       continue
            do 630 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)+(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tilts(i)                                     &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)+(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tilts(i))                                   &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)-(strack(i)*zlvj*oidpsv(j)                   &
!hr03&-dpsv1(j))*dki(ix,2)*tiltc(i)                                     &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)-(((strack(i)*zlvj)*oidpsv(j)               &!hr03
     &-dpsv1(j))*dki(ix,2))*tiltc(i))                                   &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  630       continue
            goto 260
  640       continue
            do 650 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  650       continue
            goto 490
  660       continue
            do 670 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03       yv(1,j)=yv(1,j)-stracks(i)*dpsv1(j)                         &
!hr03&+c1e3*dki(ix,2)*oidpsv(j)*tilts(i)
            yv(1,j)=(yv(1,j)-stracks(i)*dpsv1(j))                       &!hr03
     &+((c1e3*dki(ix,2))*oidpsv(j))*tilts(i)                             !hr03
!hr03       yv(2,j)=yv(2,j)+strackc(i)*dpsv1(j)                         &
!hr03&-c1e3*dki(ix,2)*oidpsv(j)*(one-tiltc(i))
            yv(2,j)=(yv(2,j)+strackc(i)*dpsv1(j))                       &!hr03
     &-((c1e3*dki(ix,2))*oidpsv(j))*(one-tiltc(i))                       !hr03
!hr03       sigmv(j)=sigmv(j)-rvv(j)*dki(ix,2)*zlvj
            sigmv(j)=sigmv(j)-(rvv(j)*dki(ix,2))*zlvj                    !hr03
  670       continue
  260       r0=ek(ix)
            nmz=nmu(ix)
          if(nmz.ge.2) then
            do 280 j=1,napx
            xlvj=(xv(1,j)-xsiv(1,i))*tiltc(i)+                          &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlvj=-(xv(1,j)-xsiv(1,i))*tilts(i)+                         &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlvj=(xv(2,j)-zsiv(1,i))*tiltc(i)-                          &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
!hr03         yv1j=bbiv(1,1,i)+bbiv(2,1,i)*xlvj+aaiv(2,1,i)*zlvj
              yv1j=(bbiv(1,1,i)+bbiv(2,1,i)*xlvj)+aaiv(2,1,i)*zlvj       !hr03
!hr03         yv2j=aaiv(1,1,i)-bbiv(2,1,i)*zlvj+aaiv(2,1,i)*xlvj
              yv2j=(aaiv(1,1,i)-bbiv(2,1,i)*zlvj)+aaiv(2,1,i)*xlvj       !hr03
              crkve=xlvj
              cikve=zlvj
                do 270 k=3,nmz
                  crkveuk=crkve*xlvj-cikve*zlvj
                  cikve=crkve*zlvj+cikve*xlvj
                  crkve=crkveuk
!hr03             yv1j=yv1j+bbiv(k,1,i)*crkve+aaiv(k,1,i)*cikve
                  yv1j=(yv1j+bbiv(k,1,i)*crkve)+aaiv(k,1,i)*cikve        !hr03
!hr03             yv2j=yv2j-bbiv(k,1,i)*cikve+aaiv(k,1,i)*crkve
                  yv2j=(yv2j-bbiv(k,1,i)*cikve)+aaiv(k,1,i)*crkve        !hr03
  270           continue
              yv(1,j)=yv(1,j)+(tiltc(i)*yv1j-tilts(i)*yv2j)*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*yv2j+tilts(i)*yv1j)*oidpsv(j)
  280       continue
          else
            do 275 j=1,napx
              yv(1,j)=yv(1,j)+(tiltc(i)*bbiv(1,1,i)-                    &
     &tilts(i)*aaiv(1,1,i))*oidpsv(j)
              yv(2,j)=yv(2,j)+(tiltc(i)*aaiv(1,1,i)+                    &
     &tilts(i)*bbiv(1,1,i))*oidpsv(j)
  275       continue
          endif
            goto 490
!--SKEW ELEMENTS
!--VERTICAL DIPOLE
  290       do 300 j=1,napx
            yv(1,j)=yv(1,j)-stracks(i)*oidpsv(j)
            yv(2,j)=yv(2,j)+strackc(i)*oidpsv(j)
  300       continue
            goto 490
!--SKEW QUADRUPOLE
  310       do 320 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  320       continue
            goto 490
!--SKEW SEXTUPOLE
  330       do 340 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  340       continue
            goto 490
!--SKEW OCTUPOLE
  350       do 360 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  360       continue
            goto 490
!--SKEW DECAPOLE
  370       do 380 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  380       continue
            goto 490
!--SKEW DODECAPOLE
  390       do 400 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  400       continue
            goto 490
!--SKEW 14-POLE
  410       do 420 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  420       continue
            goto 490
!--SKEW 16-POLE
  430       do 440 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  440       continue
            goto 490
!--SKEW 18-POLE
  450       do 460 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  460       continue
            goto 490
!--SKEW 20-POLE
  470       do 480 j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
           crkveuk=crkve*xlv(j)-cikve*zlv(j)
           cikve=crkve*zlv(j)+cikve*xlv(j)
           crkve=crkveuk
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackc(i)*cikve-                &
     &stracks(i)*crkve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackc(i)*crkve+                &
     &stracks(i)*cikve)
  480       continue
          goto 490
  680     continue
          do 690 j=1,napx
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
!hr08       rho2b(j)=crkveb(j)*crkveb(j)+cikveb(j)*cikveb(j)
            rho2b(j)=crkveb(j)**2+cikveb(j)**2                           !hr08
            if(rho2b(j).le.pieni)                                       &
     &goto 690
            tkb(j)=rho2b(j)/(two*sigman2(1,imbb(i)))
            if(ibbc.eq.0) then
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03         yv(1,j)=yv(1,j)+oidpsv(j)*(strack(i)*crkveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))
          yv(1,j)=yv(1,j)+oidpsv(j)*(((strack(i)*crkveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))                      !hr03
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03         yv(2,j)=yv(2,j)+oidpsv(j)*(strack(i)*cikveb(j)/rho2b(j)*  &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))
          yv(2,j)=yv(2,j)+oidpsv(j)*(((strack(i)*cikveb(j))/rho2b(j))*  &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))                      !hr03
            else
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),11)-   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
!+ei
              yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03         cccc=(strack(i)*crkveb(j)/rho2b(j)*                       &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+       &
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
              cccc=(((strack(i)*crkveb(j))/rho2b(j))*                   &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(4,imbb(i)))*bbcu(imbb(i),12)+   &!hr03
     &(((strack(i)*cikveb(j))/rho2b(j))*                                &!hr03
     &(one-exp_rn(-1d0*tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)     !hr03
!hr03&(strack(i)*cikveb(j)/rho2b(j)*                                    &
!+if crlibm
!hr03&(one-exp_rn(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
!+if .not.crlibm
!hr03&(one-exp(-tkb(j)))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
!+ei
              yv(2,j)=yv(2,j)+oidpsv(j)*cccc
            endif
  690     continue
          goto 490
  700     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(xrb(j),zrb(j),crxb(j),crzb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(xbb(j),zbb(j),cbxb(j),cbzb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(1,imbb(i))-sigman2(2,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,xrb(1),zrb(1),crxb(1),crzb(1))
            call wzsubv(napx,xbb(1),zbb(1),cbxb(1),cbzb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 490
  720     continue
          if(ibtyp.eq.0) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
              call errf(zrb(j),xrb(j),crzb(j),crxb(j))
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
              call errf(zbb(j),xbb(j),cbzb(j),cbxb(j))
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          else if(ibtyp.eq.1) then
            do j=1,napx
              r2b(j)=two*(sigman2(2,imbb(i))-sigman2(1,imbb(i)))
              rb(j)=sqrt(r2b(j))
              if(j.eq.1) then
              endif
!hr03         rkb(j)=strack(i)*pisqrt/rb(j)
              rkb(j)=(strack(i)*pisqrt)/rb(j)                            !hr03
              if(ibbc.eq.0) then
!hr03           crkveb(j)=xv(1,j)-clobeam(1,imbb(i))+ed(ix)
                crkveb(j)=(xv(1,j)-clobeam(1,imbb(i)))+ed(ix)            !hr03
!hr03           cikveb(j)=xv(2,j)-clobeam(2,imbb(i))+ek(ix)
                cikveb(j)=(xv(2,j)-clobeam(2,imbb(i)))+ek(ix)            !hr03
              else
!hr03           crkveb(j)=                                              &
!hr03&(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),11)+             &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),12)
                crkveb(j)=                                              &!hr03
     &((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),11)+           &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),12)             !hr03
!hr03           cikveb(j)=                                              &
!hr03&-(xv(1,j)-clobeam(1,imbb(i))+ed(ix))*bbcu(imbb(i),12)+            &
!hr03&(xv(2,j)-clobeam(2,imbb(i))+ek(ix))*bbcu(imbb(i),11)
                cikveb(j)=                                              &!hr03
     &((xv(2,j)-clobeam(2,imbb(i)))+ek(ix))*bbcu(imbb(i),11)            &!hr03
     &-((xv(1,j)-clobeam(1,imbb(i)))+ed(ix))*bbcu(imbb(i),12)            !hr03
              endif
              xrb(j)=abs(crkveb(j))/rb(j)
              zrb(j)=abs(cikveb(j))/rb(j)
!hr03         tkb(j)=(crkveb(j)*crkveb(j)/sigman2(1,imbb(i))+           &
!hr03&cikveb(j)*cikveb(j)/sigman2(2,imbb(i)))*half
              tkb(j)=(crkveb(j)**2/sigman2(1,imbb(i))+                  &!hr03
     &cikveb(j)**2/sigman2(2,imbb(i)))*half                              !hr03
              xbb(j)=sigmanq(2,imbb(i))*xrb(j)
              zbb(j)=sigmanq(1,imbb(i))*zrb(j)
            enddo
            call wzsubv(napx,zrb(1),xrb(1),crzb(1),crxb(1))
            call wzsubv(napx,zbb(1),xbb(1),cbzb(1),cbxb(1))
            do j=1,napx
              if(ibbc.eq.0) then
!hr03           yv(1,j)=yv(1,j)+oidpsv(j)*(rkb(j)*(crzb(j)-             &
!hr03&exp_rn(-1tkb(j))*                                                 &
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
                yv(1,j)=yv(1,j)+oidpsv(j)*((rkb(j)*(crzb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbzb(j)))*sign(one,crkveb(j))-beamoff(4,imbb(i)))                  !hr03
!hr03&cbzb(j))*sign(one,crkveb(j))-beamoff(4,imbb(i)))
!hr03           yv(2,j)=yv(2,j)+oidpsv(j)*(rkb(j)*(crxb(j)-             &
!hr03&exp_rn(-tkb(j))*
!hr03&cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
                yv(2,j)=yv(2,j)+oidpsv(j)*((rkb(j)*(crxb(j)-            &!hr03
     &exp_rn(-1d0*tkb(j))*                                              &!hr03
     &cbxb(j)))*sign(one,cikveb(j))-beamoff(5,imbb(i)))                  !hr03
!hr03     &cbxb(j))*sign(one,cikveb(j))-beamoff(5,imbb(i)))
              else
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-*tkb(j))*cbxb(j))*      &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),11)-((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),11)-(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),12)
                yv(1,j)=yv(1,j)+oidpsv(j)*cccc
!hr03           cccc=(rkb(j)*(crzb(j)-exp_rn(-tkb(j))*cbzb(j))*         &
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                cccc=((rkb(j)*(crzb(j)-exp_rn(-1d0*tkb(j))*cbzb(j)))*   &!hr03
     &sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &!hr03
     &bbcu(imbb(i),12)+((rkb(j)*(crxb(j)-exp_rn(-1d0*tkb(j))*cbxb(j)))* &!hr03
     &sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)           !hr03
!hr03&sign(one,crkveb(j))-beamoff(4,imbb(i)))*                          &
!+if crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp_rn(-tkb(j))*cbxb(j))*       &
!+ei
!+if .not.crlibm
!hr03&bbcu(imbb(i),12)+(rkb(j)*(crxb(j)-exp(-tkb(j))*cbxb(j))*          &
!+ei
!hr03&sign(one,cikveb(j))-beamoff(5,imbb(i)))*bbcu(imbb(i),11)
                yv(2,j)=yv(2,j)+oidpsv(j)*cccc
              endif
            enddo
          endif
          goto 490
  730     continue
!--Hirata's 6D beam-beam kick
            do j=1,napx
!hr03         track6d(1,j)=(xv(1,j)+ed(ix)-clobeam(1,imbb(i)))*c1m3
              track6d(1,j)=((xv(1,j)+ed(ix))-clobeam(1,imbb(i)))*c1m3    !hr03
              track6d(2,j)=(yv(1,j)/oidpsv(j)-clobeam(4,imbb(i)))*c1m3
!hr03         track6d(3,j)=(xv(2,j)+ek(ix)-clobeam(2,imbb(i)))*c1m3
              track6d(3,j)=((xv(2,j)+ek(ix))-clobeam(2,imbb(i)))*c1m3    !hr03
              track6d(4,j)=(yv(2,j)/oidpsv(j)-clobeam(5,imbb(i)))*c1m3
              track6d(5,j)=(sigmv(j)-clobeam(3,imbb(i)))*c1m3
              track6d(6,j)=dpsv(j)-clobeam(6,imbb(i))
            enddo
            call beamint(napx,track6d,parbe,sigz,bbcu,imbb(i),ix,ibtyp, &
     &ibbc)
            do j=1,napx
!hr03         xv(1,j)=track6d(1,j)*c1e3+clobeam(1,imbb(i))-             &
              xv(1,j)=(track6d(1,j)*c1e3+clobeam(1,imbb(i)))-           &!hr03
     &beamoff(1,imbb(i))
!hr03         xv(2,j)=track6d(3,j)*c1e3+clobeam(2,imbb(i))-             &
              xv(2,j)=(track6d(3,j)*c1e3+clobeam(2,imbb(i)))-           &!hr03
     &beamoff(2,imbb(i))
!hr03         dpsv(j)=track6d(6,j)+clobeam(6,imbb(i))-beamoff(6,imbb(i))
              dpsv(j)=(track6d(6,j)+clobeam(6,imbb(i)))-                &!hr03
     &beamoff(6,imbb(i))                                                 !hr03
              oidpsv(j)=one/(one+dpsv(j))
!hr03         yv(1,j)=(track6d(2,j)*c1e3+clobeam(4,imbb(i))-            &
              yv(1,j)=((track6d(2,j)*c1e3+clobeam(4,imbb(i)))-          &!hr03
     &beamoff(4,imbb(i)))*oidpsv(j)
!hr03         yv(2,j)=(track6d(4,j)*c1e3+clobeam(5,imbb(i))-            &
              yv(2,j)=((track6d(4,j)*c1e3+clobeam(5,imbb(i)))-          &!hr03
     &beamoff(5,imbb(i)))*oidpsv(j)
              ejfv(j)=dpsv(j)*e0f+e0f
!hr03         ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
              ejv(j)=sqrt(ejfv(j)**2+pma**2)
              rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
              if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
            enddo
          goto 490
  740     continue
          irrtr=imtr(ix)
          do j=1,napx
!hr03       sigmv(j)=sigmv(j)+cotr(irrtr,5)+rrtr(irrtr,5,1)*xv(1,j)+    &
!hr03&rrtr(irrtr,5,2)*yv(1,j)+rrtr(irrtr,5,3)*xv(2,j)+                  &
!hr03&rrtr(irrtr,5,4)*yv(2,j)+rrtr(irrtr,5,6)*dpsv(j)*c1e3
      sigmv(j)=(((((sigmv(j)+cotr(irrtr,5))+rrtr(irrtr,5,1)*xv(1,j))+   &!hr03
     &rrtr(irrtr,5,2)*yv(1,j))+rrtr(irrtr,5,3)*xv(2,j))+                &!hr03
!BNL-NOV08
!     &rrtr(irrtr,5,4)*yv(2,j)
     &rrtr(irrtr,5,4)*yv(2,j))+(rrtr(irrtr,5,6)*dpsv(j))*c1e3            !hr03
!BNL-NOV08
            pux=xv(1,j)
            dpsv3(j)=dpsv(j)*c1e3
!hr03       xv(1,j)=cotr(irrtr,1)+rrtr(irrtr,1,1)*pux+                  &
!hr03&rrtr(irrtr,1,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,1,6)
            xv(1,j)=((cotr(irrtr,1)+rrtr(irrtr,1,1)*pux)+               &!hr03
     &rrtr(irrtr,1,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,1,6)   !hr03
!hr03       yv(1,j)=cotr(irrtr,2)+rrtr(irrtr,2,1)*pux+                  &
!hr03&rrtr(irrtr,2,2)*yv(1,j)+idz(1)*dpsv3(j)*rrtr(irrtr,2,6)
            yv(1,j)=((cotr(irrtr,2)+rrtr(irrtr,2,1)*pux)+               &!hr03
     &rrtr(irrtr,2,2)*yv(1,j))+(dble(idz(1))*dpsv3(j))*rrtr(irrtr,2,6)   !hr03
            pux=xv(2,j)
!hr03       xv(2,j)=cotr(irrtr,3)+rrtr(irrtr,3,3)*pux+                  &
!hr03&rrtr(irrtr,3,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,3,6)
            xv(2,j)=((cotr(irrtr,3)+rrtr(irrtr,3,3)*pux)+               &!hr03
     &rrtr(irrtr,3,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,3,6)   !hr03
!hr03       yv(2,j)=cotr(irrtr,4)+rrtr(irrtr,4,3)*pux+                  &
!hr03&rrtr(irrtr,4,4)*yv(2,j)+idz(2)*dpsv3(j)*rrtr(irrtr,4,6)
            yv(2,j)=((cotr(irrtr,4)+rrtr(irrtr,4,3)*pux)+               &!hr03
     &rrtr(irrtr,4,4)*yv(2,j))+(dble(idz(2))*dpsv3(j))*rrtr(irrtr,4,6)   !hr03
          enddo
 
!----------------------------------------------------------------------
 
! Wire.
 
          goto 490
  745     continue
          xory=1
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 490
  746     continue
          xory=2
          nfree=nturn1(ix)
         if(n.gt.nfree) then
          nac=n-nfree
          pi=4d0*atan_rn(1d0)
!---------ACdipAmp input in Tesla*meter converted to KeV/c
!---------ejfv(j) should be in MeV/c --> ACdipAmp/ejfv(j) is in mrad
!hr03     acdipamp=ed(ix)*clight*1.0d-3
          acdipamp=(ed(ix)*clight)*1.0d-3                                !hr03
!---------Qd input in tune units
          qd=ek(ix)
!---------ACphase input in radians
          acphase=acdipph(ix)
          nramp1=nturn2(ix)
          nplato=nturn3(ix)
          nramp2=nturn4(ix)
          do j=1,napx
      if (xory.eq.1) then
        acdipamp2=acdipamp*tilts(i)
        acdipamp1=acdipamp*tiltc(i)
      else
        acdipamp2=acdipamp*tiltc(i)
        acdipamp1=-acdipamp*tilts(i)
      endif
              if(nramp1.gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(1,j)=yv(1,j)+(((acdipamp1*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)*nac/dble(nramp1)/ejfv(j)
                yv(2,j)=yv(2,j)+(((acdipamp2*                           &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &dble(nac))/dble(nramp1))/ejfv(j)                                   !hr03
              endif
              if(nac.ge.nramp1.and.(nramp1+nplato).gt.nac) then
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03           yv(1,j)=yv(1,j)+acdipamp1*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(1,j)=yv(1,j)+(acdipamp1*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03           yv(2,j)=yv(2,j)+acdipamp2*                              &
!hr03&sin_rn(2d0*pi*qd*nac+acphase)/ejfv(j)
                yv(2,j)=yv(2,j)+(acdipamp2*                             &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))/ejfv(j)                   !hr03
              endif
              if(nac.ge.(nramp1+nplato).and.(nramp2+nramp1+nplato).gt.  &
     &nac)then
!hr03         yv(1,j)=yv(1,j)+acdipamp1*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(1,j)=yv(1,j)+((acdipamp1*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
!hr03         yv(2,j)=yv(2,j)+acdipamp2*sin_rn(2d0*pi*qd*nac+acphase)*  &
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              yv(2,j)=yv(2,j)+((acdipamp2*                              &!hr03
     &sin_rn(((2d0*pi)*qd)*dble(nac)+acphase))*                         &!hr03
     &((-1d0*dble(nac-nramp1-nramp2-nplato))/dble(nramp2)))/ejfv(j)      !hr03
!hr03&(-(nac-nramp1-nramp2-nplato)*1d0/dble(nramp2))/ejfv(j)
              endif
      enddo
      endif
          goto 490
  751     continue
          xory=1
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 490
  752     continue
          xory=2
!---------CrabAmp input in MV
!---------ejfv(j) should be in MeV/c --> CrabAmp/c/ejfv(j) is in rad
!---------ejfv(j) should be in MeV ?? --> CrabAmp/ejfv(j) is in rad
!---------CrabFreq input in MHz (ek)
!---------sigmv should be in mm --> sigmv*1e-3/clight*ek*1e6 in rad
          pi=4d0*atan_rn(1d0)
        crabfreq=ek(ix)*c1e3
 
        do j=1,napx
!hr03    crabamp=ed(ix)/(ejfv(j))*c1e3
         crabamp=(ed(ix)/ejfv(j))*c1e3                                   !hr03
!        write(*,*) crabamp, ejfv(j), clight, "HELLO"
 
!hr03   yv(xory,j)=yv(xory,j) - crabamp*                                &
!hr03&sin_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))
        yv(xory,j)=yv(xory,j) - crabamp*                                &!hr03
     &sin_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix))         !hr03
!hr03 dpsv(j)=dpsv(j) - crabamp*crabfreq*2d0*pi/clight*xv(xory,j)*      &
!hr03&cos_rn(sigmv(j)/clight*crabfreq*2d0*pi + crabph(ix))*c1m3
      dpsv(j)=dpsv(j) -                                                 &!hr03
     &((((((crabamp*crabfreq)*2d0)*pi)/clight)*xv(xory,j))*             &!hr03
     &cos_rn((((sigmv(j)/clight)*crabfreq)*2d0)*pi + crabph(ix)))*c1m3   !hr03
      ejf0v(j)=ejfv(j)
      ejfv(j)=dpsv(j)*e0f+e0f
!hr03 ejv(j)=sqrt(ejfv(j)*ejfv(j)+pma*pma)
      ejv(j)=sqrt(ejfv(j)**2+pma**2)                                     !hr03
      oidpsv(j)=one/(one+dpsv(j))
      dpsv1(j)=(dpsv(j)*c1e3)*oidpsv(j)
      yv(1,j)=(ejf0v(j)/ejfv(j))*yv(1,j)
      yv(2,j)=(ejf0v(j)/ejfv(j))*yv(2,j)
      rvv(j)=(ejv(j)*e0f)/(e0*ejfv(j))
      if(ithick.eq.1) call envarsv(dpsv,oidpsv,rvv,ekv)
      enddo
          goto 490
!--DIPEDGE ELEMENT
  753     continue
          do j=1,napx
            xlv(j)=(xv(1,j)-xsiv(1,i))*tiltc(i)+                        &
     &(xv(2,j)-zsiv(1,i))*tilts(i)
!hr02       zlv(j)=-(xv(1,j)-xsiv(1,i))*tilts(i)+                       &
!hr02&(xv(2,j)-zsiv(1,i))*tiltc(i)
            zlv(j)=(xv(2,j)-zsiv(1,i))*tiltc(i)-                        &!hr02
     &(xv(1,j)-xsiv(1,i))*tilts(i)                                       !hr02
            crkve=xlv(j)
            cikve=zlv(j)
            yv(1,j)=yv(1,j)+oidpsv(j)*(strackx(i)*crkve-                &
     &stracks(i)*cikve)
            yv(2,j)=yv(2,j)+oidpsv(j)*(strackz(i)*cikve+                &
     &strackc(i)*crkve)
          enddo
          goto 490
!--solenoid
  754     continue
          do j=1,napx
            yv(1,j)=yv(1,j)-xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)+xv(1,j)*strackx(i)
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       yv(1,j)=crkve*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&cikve*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       yv(2,j)=-crkve*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&cikve*cos(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       crkve=xv(1,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))+             &
!hr02&xv(2,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))
!hr02       cikve=-xv(1,j)*sin(strackz(i)*ejf0v(j)/ejfv(j))+            &
!hr02&xv(2,j)*cos(strackz(i)*ejf0v(j)/ejfv(j))
            yv(1,j)=crkve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &cikve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            yv(2,j)=cikve*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &crkve*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                        !hr02
            crkve=xv(1,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))+        &!hr02
     &xv(2,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            cikve=xv(2,j)*cos_rn((strackz(i)*ejf0v(j))/ejfv(j))-        &!hr02
     &xv(1,j)*sin_rn((strackz(i)*ejf0v(j))/ejfv(j))                      !hr02
            xv(1,j)=crkve
            xv(2,j)=cikve
            yv(1,j)=yv(1,j)+xv(2,j)*strackx(i)
            yv(2,j)=yv(2,j)-xv(1,j)*strackx(i)
!hr02       crkve=sigmv(j)-0.5*(xv(1,j)*xv(1,j)+xv(2,j)*xv(2,j))*       &
!hr02&strackx(i)*strackz(i)*rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
        crkve=sigmv(j)-0.5d0*(((((((xv(1,j)**2+xv(2,j)**2)*strackx(i))* &!hr02
     &strackz(i))*rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)           !hr02
            sigmv(j)=crkve
!hr02       crkve=yv(1,j)-xv(1,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      crkve=yv(1,j)-(((xv(1,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       cikve=yv(2,j)-xv(2,j)*strackx(i)*strackz(i)*ejf0v(j)/ejfv(j)
      cikve=yv(2,j)-(((xv(2,j)*strackx(i))*strackz(i))*ejf0v(j))/ejfv(j) !hr02
!hr02       sigmv(j)=sigmv(j)+(xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i)* &
!hr02&rvv(j)*ejf0v(j)/ejfv(j)*ejf0v(j)/ejfv(j)
      sigmv(j)=sigmv(j)+((((((xv(1,j)*cikve-xv(2,j)*crkve)*strackz(i))* &!hr02
     &rvv(j))*ejf0v(j))/ejfv(j))*ejf0v(j))/ejfv(j)                       !hr02
          enddo
          goto 490
 
!----------------------------
 
! Wire.
 
  748     continue
!     magnetic rigidity
!hr03 chi = sqrt(e0*e0-pmap*pmap)*c1e6/clight
      chi = (sqrt(e0**2-pmap**2)*c1e6)/clight                            !hr03
 
      ix = ixcav
      tx = xrms(ix)
      ty = zrms(ix)
      dx = xpl(ix)
      dy = zpl(ix)
      embl = ek(ix)
      l = wirel(ix)
      cur = ed(ix)
 
!hr03 leff = embl/cos_rn(tx)/cos_rn(ty)
      leff = (embl/cos_rn(tx))/cos_rn(ty)                                !hr03
!hr03 rx = dx *cos_rn(tx)-embl*sin_rn(tx)/2
      rx = dx *cos_rn(tx)-(embl*sin_rn(tx))*0.5d0                        !hr03
!hr03 lin= dx *sin_rn(tx)+embl*cos_rn(tx)/2
      lin= dx *sin_rn(tx)+(embl*cos_rn(tx))*0.5d0                        !hr03
      ry = dy *cos_rn(ty)-lin *sin_rn(ty)
      lin= lin*cos_rn(ty)+dy  *sin_rn(ty)
 
      do 750 j=1, napx
 
      xv(1,j) = xv(1,j) * c1m3
      xv(2,j) = xv(2,j) * c1m3
      yv(1,j) = yv(1,j) * c1m3
      yv(2,j) = yv(2,j) * c1m3
 
!      write(*,*) 'Start: ',j,xv(1,j),xv(2,j),yv(1,j),
!     &yv(2,j)
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) -                                               &!hr03
     &((embl*0.5d0)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) -                                               &!hr03
     &((embl*0.5d0)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2)                                                        !hr03
 
!     call tilt(tx,ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(tx)*yv(2,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(tx))*yv(2,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(1,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-tx)                                                   !hr03
!+if crlibm
!hhr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
      xv(1,j) = xv(1,j)*(cos_rn(tx)-sin_rn(tx)*tan_rn(atan_rn(yv(1,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(1,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-tx)
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(ty)*yv(1,j)/sqrt((1+dpsv(j))**2- &
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))-ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(ty))*yv(1,j))/                &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))-ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))-ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
      xv(2,j) = xv(2,j)*(cos_rn(ty)-sin_rn(ty)*tan_rn(atan_rn(yv(2,j)/  &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))-ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))-ty)
 
!     call drift(lin)
 
!hr03 xv(1,j) = xv(1,j) + lin*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) + (lin*yv(1,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) + lin*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-   &
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) + (lin*yv(2,j))/                                &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
!      call kick(l,cur,lin,rx,ry,chi)
 
      xi = xv(1,j)-rx
      yi = xv(2,j)-ry
!hr03 yv(1,j) = yv(1,j)-c1m7*cur/chi*xi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(1,j) = yv(1,j)-((((c1m7*cur)/chi)*xi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
!GRD FOR CONSISTENSY
!hr03 yv(2,j) = yv(2,j)-c1m7*cur/chi*yi/(xi**2+yi**2)*                  &
!hr03&(sqrt((lin+l)**2+xi**2+yi**2)-sqrt((lin-l)**2+                    &
!hr03&xi**2+yi**2))
      yv(2,j) = yv(2,j)-((((c1m7*cur)/chi)*yi)/(xi**2+yi**2))*          &!hr03
     &(sqrt(((lin+l)**2+xi**2)+yi**2)-sqrt(((lin-l)**2+                 &!hr03
     &xi**2)+yi**2))                                                     !hr03
 
!     call drift(leff-lin)
 
!hr03 xv(1,j) = xv(1,j) + (leff-lin)*yv(1,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(1,j) = xv(1,j) + ((leff-lin)*yv(1,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
!hr03 xv(2,j) = xv(2,j) + (leff-lin)*yv(2,j)/sqrt((1+dpsv(j))**2-       &
!hr03&yv(1,j)**2-yv(2,j)**2)
      xv(2,j) = xv(2,j) + ((leff-lin)*yv(2,j))/sqrt(((1d0+dpsv(j))**2-  &!hr03
     &yv(1,j)**2)-yv(2,j)**2)                                            !hr03
 
!     call invtilt(tx,ty)
 
!hr03 xv(1,j) = xv(1,j)-xv(2,j)*sin_rn(-ty)*yv(1,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+ty)
      xv(1,j) = xv(1,j)-(((xv(2,j)*sin_rn(-ty))*yv(1,j))/               &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(1,j)**2))/                               &!hr03
     &cos_rn(atan_rn(yv(2,j)/sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-        &!hr03
     &yv(2,j)**2))+ty)                                                   !hr03
!+if crlibm
!hr03&yv(1,j)**2)/cos_rn(atan_rn(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(1,j)**2)/cos(atan(yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+ty)
!hr03 xv(2,j) = xv(2,j)*(cos_rn(-ty)-sin_rn(-ty)*tan_rn(atan_rn(yv(2,j)/&
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
      xv(2,j) = xv(2,j)*                                                &!hr03
     &(cos_rn(-1d0*ty)-sin_rn(-1d0*ty)*tan_rn(atan_rn(yv(2,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty))
!hr03 yv(2,j) = sqrt((1+dpsv(j))**2-yv(1,j)**2)*sin_rn(atan_rn(yv(2,j)/ &
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
      yv(2,j) = sqrt((1d0+dpsv(j))**2-yv(1,j)**2)*                      &!hr03
     &sin_rn(atan_rn(yv(2,j)/                                           &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+ty)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+ty)
 
!hr03 xv(2,j) = xv(2,j)-xv(1,j)*sin_rn(-tx)*yv(2,j)/sqrt((1+dpsv(j))**2-&
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2))+tx)
      xv(2,j) = xv(2,j)-(((xv(1,j)*sin_rn(-1d0*tx))*yv(2,j))/           &!hr03
     &sqrt((1d0+dpsv(j))**2-yv(2,j)**2))/cos_rn(atan_rn(yv(1,j)/        &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!+if crlibm
!hr03&yv(2,j)**2)/cos_rn(atan_rn(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!+ei
!+if .not.crlibm
!hr03&yv(2,j)**2)/cos(atan(yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-      &
!+ei
!hr03&yv(2,j)**2))+tx)
!hr03 xv(1,j) = xv(1,j)*(cos_rn(-tx)-sin_rn(-tx)*tan_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
      xv(1,j) = xv(1,j)*                                                &!hr03
     &(cos_rn(-1d0*tx)-sin_rn(-1d0*tx)*tan_rn(atan_rn(yv(1,j)/          &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx))               !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx))
!hr03 yv(1,j) = sqrt((1+dpsv(j))**2-yv(2,j)**2)*sin_rn(atan_rn(yv(1,j)/
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
      yv(1,j) = sqrt((1d0+dpsv(j))**2-yv(2,j)**2)*                       !hr03
     &sin_rn(atan_rn(yv(1,j)/                                            !hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2))+tx)                !hr03
!hr03&sqrt((1+dpsv(j))**2-yv(1,j)**2-yv(2,j)**2))+tx)
 
!     call shift(-embl*tan(tx),-embl*tan(ty)/cos(tx))
 
      xv(1,j) = xv(1,j) + embl*tan_rn(tx)
!hr03 xv(2,j) = xv(2,j) + embl*tan_rn(ty)/cos_rn(tx)
      xv(2,j) = xv(2,j) + (embl*tan_rn(ty))/cos_rn(tx)                   !hr03
 
!     call drift(-embl/2)
 
!hr03 xv(1,j) = xv(1,j) - embl/2*yv(1,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(1,j) = xv(1,j) - ((embl*0.5d0)*yv(1,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
!hr03 xv(2,j) = xv(2,j) - embl/2*yv(2,j)/sqrt((1+dpsv(j))**2-yv(1,j)**2-&
!hr03&yv(2,j)**2)
      xv(2,j) = xv(2,j) - ((embl*0.5d0)*yv(2,j))/                       &!hr03
     &sqrt(((1d0+dpsv(j))**2-yv(1,j)**2)-yv(2,j)**2)                     !hr03
 
      xv(1,j) = xv(1,j) * c1e3
      xv(2,j) = xv(2,j) * c1e3
      yv(1,j) = yv(1,j) * c1e3
      yv(2,j) = yv(2,j) * c1e3
 
!      write(*,*) 'End: ',j,xv(1,j),xv(2,j),yv(1,j),                       &
!     &yv(2,j)
 
!-----------------------------------------------------------------------
 
  750     continue                                                      `
          goto 490
 
!----------------------------
 
  490       continue
          llost=.false.
          do j=1,napx
             llost=llost.or.                                            &
     &abs(xv(1,j)).gt.aper(1).or.abs(xv(2,j)).gt.aper(2)
          enddo
          if (llost) then
             kpz=abs(kp(ix))
             if(kpz.eq.2) then
                call lostpar3(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             elseif(kpz.eq.3) then
                call lostpar4(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             else
                call lostpar2(i,ix,nthinerr)
                if(nthinerr.ne.0) return
             endif
          endif
  500     continue
          call lostpart(nthinerr)
          if(nthinerr.ne.0) return
          if(ntwin.ne.2) call dist1
          if(mod(n,nwr(4)).eq.0) call write6(n)
  510 continue
      return
      end
      subroutine synuthck
!-----------------------------------------------------------------------
!
!  TRACK THICK LENS PART
!
!
!  F. SCHMIDT
!-----------------------------------------------------------------------
!  3 February 1999
!-----------------------------------------------------------------------
      implicit none
      double precision sin_rn,cos_rn,tan_rn,sinh_rn,cosh_rn,asin_rn,    &
     &acos_rn,atan_rn,atan2_rn,exp_rn,log_rn,log10_rn
      integer ih1,ih2,j,kz1,l
      double precision fokm
      integer mbea,mcor,mcop,mmul,mpa,mran,nbb,nblo,nblz,ncom,ncor1,    &
     &nelb,nele,nema,ninv,nlya,nmac,nmon1,npart,nper,nplo,npos,nran,    &
     &nrco,ntr,nzfz
      parameter(npart = 64,nmac = 1)
      parameter(nele=1200,nblo=600,nper=16,nelb=140,nblz=20000,         &
     &nzfz = 300000,mmul = 20)
      parameter(nran = 2000000,ncom = 100,mran = 500,mpa = 6,nrco = 5,  &
     &nema = 15)
      parameter(mcor = 10,mcop = mcor+6, mbea = 99)
      parameter(npos = 20000,nlya = 10000,ninv = 1000,nplo = 20000)
      parameter(nmon1 = 600,ncor1 = 600)
      parameter(ntr = 20,nbb = 350)
      double precision c180e0,c1e1,c1e12,c1e13,c1e15,c1e16,c1e2,c1e3,   &
     &c1e4,c1e6,c1m1,c1m7,c1m10,c1m12,c1m13,c1m15,c1m18,c1m2,c1m21,     &
     &c1m24,c1m3,c1m36,c1m38,c1m6,c1m9,c2e3,c4e3,crade,clight,four,half,&
     &one,pieni,pmae,pmap,three,two,zero
      parameter(pieni = 1d-38)
      parameter(zero = 0.0d0,half = 0.5d0,one = 1.0d0)
      parameter(two = 2.0d0,three = 3.0d0,four = 4.0d0)
      parameter(c1e1 = 1.0d1,c1e2 = 1.0d2,c1m2 = 1.0d-2)
      parameter(c1e3 = 1.0d3,c2e3 = 2.0d3,c4e3 = 4.0d3,c1e4 = 1.0d4)
      parameter(c1e12 = 1.0d12,c1e13 = 1.0d13,c1e15 = 1.0d15,c1e16 =    &
     &1.0d16)
      parameter(c180e0 = 180.0d0,c1e6 = 1.0d6)
      parameter(c1m1 = 1.0d-1,c1m3 = 1.0d-3,c1m6 = 1.0d-6,c1m7 = 1.0d-7)
      parameter(c1m9 = 1.0d-9,c1m10 = 1.0d-10,c1m12 = 1.0d-12)
      parameter(c1m13 = 1.0d-13,c1m15 = 1.0d-15)
      parameter(c1m18 = 1.0d-18,c1m21 = 1.0d-21,c1m24 = 1.0d-24)
      parameter(c1m36 = 1.0d-36,c1m38 = 1.0d-38)
      parameter(pmap = 938.271998d0,pmae = .510998902d0)
      parameter(crade = 2.817940285d-15, clight = 2.99792458d8)
      integer iav,ibb6d,ibbc,ibeco,ibidu,ibtyp,ic,icext,icextal,iclo,   &
     &iclo6,iclo6r,icode,icoe,icomb,icomb0,iconv,icow,icr,idam,idfor,   &
     &idis,idp,ierro,iffw,ifh,iicav,il,ilin,imad,imbb,                  &
     &imc,imtr,iorg,iout,                                               &
     &ipos,ipr,iprint,ipt,iq,iqmod,iqmod6,iratioe,irco,ird,ire,ires,    &
     &irew,irip,irm,irmod2,ise,ise1,ise2,ise3,isea,iskew,iskip,istw,    &
     &isub,itco,itcro,itf,ithick,ition,itionc,itqv,its6d,iu,iver,ivox,  &
     &ivoz,iwg,ixcav,izu0,kanf,kp,kpa,kwtype,kz,lhc,m21,m22,m23,mblo,   &
     &mbloz,mcut,mel,mesa,mmac,mout2,mp,mper,mstr,msym,mtyp,mzu,napx,   &
     &napxo,nbeam,nch,ncororb,ncorrep,ncorru,ncy,ndafi,nde,nhcorr,      &
     &nhmoni,niu,nlin,nmu,npp,nprint,nqc,nre,nrel,nrr,nrturn,nskew,     &
     &nstart,nstop,nt,nta,ntco,nte,ntwin,nu,numl,numlr,nur,nvcorr,      &
     &nvmoni,nwr, nturn1, nturn2, nturn3, nturn4,numlcp,numlmax,nnuml
      double precision a,ak0,aka,alfx,alfz,amp0,aper,apx,apz,ape,bbcu,  &
     &bclorb,beamoff,benkc,benki,betac,betam,betx,betz,bk0,bka,bl1,bl2, &
     &clo6,clobeam,clop6,cma1,cma2,cotr,crad,de0,dech,ded,dfft,         &
     &di0,dip0,dki,dkq,dma,dmap,dphix,dphiz,dppoff,dpscor,dqq,dres,dsi, &
     &dsm0,dtr,e0,ed,ej,ejf,ek,el,elbe,emitx,emity,emitz,extalign,      &
     &exterr,eui,euii,gammar,hsy,hsyc,pac,pam,parbe,parbe14,partnum,    &
     &phas,phas0,phasc,pi,pi2,pisqrt,pma,ptnfac,qs,qw0,qwsk,qx0,qxt,qz0,&
     &qzt,r00,rad,ramp,rat,ratio,ratioe,rfre,rrtr,rtc,rts,rvf,rzph,     &
     &sigcor,sige,sigma0,sigman,sigman2,sigmanq,sigmoff,sigz,sm,ta,tam1,&
     &tam2,tiltc,tilts,tlen,totl,track6d,xpl,xrms,zfz,zpl,zrms,wirel,   &
     &acdipph, crabph, bbbx, bbby, bbbs,                                &
     &crabph2, crabph3, crabph4
      real hmal
      character*16 bez,bezb,bezr,erbez,bezl
      character*80 toptit,sixtit,commen
      common/erro/ierro,erbez
      common/kons/pi,pi2,pisqrt,rad
      common/str /il,mper,mblo,mbloz,msym(nper),kanf,iu,ic(nblz)
      common/ell /ed(nele),el(nele),ek(nele),sm(nele),kz(nele),kp(nele)
      common/bbb /bbbx(nele), bbby(nele), bbbs(nele)
      common/pla /xpl(nele),xrms(nele),zpl(nele),zrms(nele)
      common/str2 /mel(nblo),mtyp(nblo,nelb),mstr(nblo)
      common/mat/a(nele,2,6),bl1(nblo,2,6),bl2(nblo,2,6)
      common/syos2/rvf(mpa)
      common/tra1/rat,idfor,napx,napxo,numl,niu(2),numlr,nde(2),nwr(4), &
     &ird,imc,irew,ntwin,iclo6,iclo6r,iver,ibidu,numlcp,numlmax,nnuml
      common/syn/qs,e0,pma,ej(mpa),ejf(mpa),phas0,phas,hsy(3),          &
     &crad,hsyc(nele),phasc(nele),dppoff,sigmoff(nblz),tlen,            &
     &iicav,itionc(nele),ition,idp,ncy,ixcav
      common/corcom/dpscor,sigcor,icode,idam,its6d
      common/multi/bk0(nele,mmul),ak0(nele,mmul),                       &
     &bka(nele,mmul),aka(nele,mmul)
      common/mult1/benki,benkc(nele),r00(nele),irm(nele),nmu(nele)
      common/rand0/zfz(nzfz),iorg,mzu(nblz),bezr(3,nele),izu0,mmac,mcut
      common/rand1/exterr(nblz,40),extalign(nblz,3),tiltc(nblz),        &
     &tilts(nblz),mout2,icext(nblz),icextal(nblz)
      common/beo /aper(2),di0(2),dip0(2),ta(6,6)
      common/clo/dma,dmap,dkq,dqq,de0,ded,dsi,dech,dsm0,itco,itcro,itqv,&
     &iout
      common/qmodi/qw0(3),amp0,iq(3),iqmod,kpa(nele),iqmod6
      common/linop/bez(nele),elbe(nblo),bezb(nblo),ilin,nt,iprint,      &
     &ntco,eui,euii,nlin,bezl(nele)
      common/cororb/betam(nmon1,2),pam(nmon1,2),betac(ncor1,2),         &
     &pac(ncor1,2),bclorb(nmon1,2),nhmoni,nhcorr,nvmoni,nvcorr,         &
     &ncororb(nele)
      common/apert/apx(nele),apz(nele),ape(3,nele)
      common/clos/sigma0(2),iclo,ncorru,ncorrep
      common/combin/icomb0(20),icomb(ncom,20),ratio(ncom,20),           &
     &ratioe(nele),iratioe(nele),icoe
      common/seacom/ise,mesa,mp,m21,m22,m23,ise1,ise2,ise3,isea(nele)
      common/subres/qxt,qzt,tam1,tam2,isub,nta,nte,ipt,totl
      common/secom/rtc(9,18,10,5),rts(9,18,10,5),ire(12),ipr(5),irmod2
      common/secom1/dtr(10),nre,nur,nch,nqc,npp,nrr(5),nu(5)
      common/postr/dphix,dphiz,qx0,qz0,dres,dfft,cma1,cma2,             &
     &nstart,nstop,iskip,iconv,imad
      common/posti1/ipos,iav,iwg,ivox,ivoz,ires,ifh,toptit(5)
      common/posti2/kwtype,itf,icr,idis,icow,istw,iffw,nprint,ndafi
      common/ripp/irip,irco,ramp(nele),rfre(nele),rzph(nele),nrel(nele)
      common/ripp2/nrturn
      common/skew/qwsk(2),betx(2),betz(2),alfx(2),alfz(2),iskew,nskew(6)
      common/pawc/hmal(nplo)
      common/tit/sixtit,commen,ithick
      common/co6d/clo6(3),clop6(3)
      common/dkic/dki(nele,3)
      common/beam/sigman(2,nbb),sigman2(2,nbb),sigmanq(2,nbb),          &
     &clobeam(6,nbb),beamoff(6,nbb),parbe(nele,5),track6d(6,npart),     &
     &ptnfac(nele),sigz,sige,partnum,parbe14,emitx,emity,emitz,gammar,  &
     &nbeam,ibbc,ibeco,ibtyp,lhc
      common/trom/ cotr(ntr,6),rrtr(ntr,6,6),imtr(nele)
      common/bb6d/ bbcu(nbb,12),ibb6d,imbb(nblz)
      common/wireco/ wirel(nele)
      common/acdipco/ acdipph(nele), nturn1(nele), nturn2(nele),        &
     &nturn3(nele), nturn4(nele)
      common/crabco/ crabph(nele),crabph2(nele),                        &
     &crabph3(nele),crabph4(nele)
      integer idz,itra
      double precision al,as,chi0,chid,dp1,dps,exz,sigm
      common/syos/as(6,2,npart,nele),al(6,2,npart,nele),sigm(mpa),      &
     &dps(mpa),idz(2)
      common/anf/chi0,chid,exz(2,6),dp1,itra
      integer ichrom,is
      double precision alf0,amp,bet0,clo,clop,cro,x,y
      common/tra/x(mpa,2),y(mpa,2),amp(2),bet0(2),alf0(2),clo(2),clop(2)
      common/chrom/cro(2),is(2),ichrom
      integer icorr,idial,idptr,imod1,imod2,inorm,ipar,namp,ncor,nctype,&
     &ndimf,nmom,nmom1,nmom2,nord,nord1,nordf,nsix,nvar,nvar2,nvarf
      double precision dpmax,preda,weig1,weig2
      character*16 coel
      common/dial/preda,idial,nord,nvar,nvar2,nsix,ncor,ipar(mcor)
      common/norf/nordf,nvarf,nord1,ndimf,idptr,inorm,imod1,imod2
      common/tcorr/icorr,nctype,namp,nmom,nmom1,nmom2,weig1,weig2,dpmax,&
     &coel(10)
      double precision aai,ampt,bbi,damp,rfres,rsmi,rzphs,smi,smizf,xsi,&
     &zsi
      integer napxto
      real tlim,time0,time1,time2,time3,trtime
      common/xz/xsi(nblz),zsi(nblz),smi(nblz),smizf(nblz),              &
     &aai(nblz,mmul),bbi(nblz,mmul)
      common/rfres/rsmi(nblz),rfres(nblz),rzphs(nblz)
      common/damp/damp,ampt
      common/ttime/tlim,time0,time1,time2,time3,trtime,napxto
      double precision tasm
      common/tasm/tasm(6,6)
      integer iv,ixv,nlostp,nms,numxv
      double precision aaiv,aek,afok,alf0v,ampv,aperv,as3,as4,as6,bbiv, &
     &bet0v,bl1v,ci,clo0,clo6v,cloau,clop0,clop6v,clopv,clov,co,cr,dam, &
     &di0au,di0xs,di0zs,dip0xs,dip0zs,dp0v,dpd,dpsq,dpsv,dpsv6,dpsvl,   &
     &ejf0v,ejfv,ejv,ejvl,ekk,ekkv,ekv,eps,epsa,fake,fi,fok,fok1,fokqv, &
     &g,gl,hc,hi,hi1,hm,hp,hs,hv,oidpsv,qw,qwc,qwcs,rho,rhoc,rhoi,rvv,  &
     &si,sigmv,sigmv6,sigmvl,siq,sm1,sm12,sm2,sm23,sm3,smiv,tas,        &
     &tasau,tau,wf,wfa,wfhi,wx,x1,x2,xau,xlv,xsiv,xsv,xv,xvl,yv,yvl,zlv,&
     &zsiv,zsv
      logical pstop
      common/main1/                                                     &
     &ekv(npart,nele),fokqv(npart),aaiv(mmul,nmac,nblz),                &
     &bbiv(mmul,nmac,nblz),smiv(nmac,nblz),zsiv(nmac,nblz),             &
     &xsiv(nmac,nblz),xsv(npart),zsv(npart),qw(2),qwc(3),clo0(2),       &
     &clop0(2),eps(2),epsa(2),ekk(2),cr(mmul),ci(mmul),xv(2,npart),     &
     &yv(2,npart),dam(npart),ekkv(npart),sigmv(npart),dpsv(npart),      &
     &dp0v(npart),sigmv6(npart),dpsv6(npart),ejv(npart),ejfv(npart),    &
     &xlv(npart),zlv(npart),pstop(npart),rvv(npart),                    &
     &ejf0v(npart),numxv(npart),nms(npart),nlostp(npart)
      common/main2/ dpd(npart),dpsq(npart),fok(npart),rho(npart),       &
     &fok1(npart),si(npart),co(npart),g(npart),gl(npart),sm1(npart),    &
     &sm2(npart),sm3(npart),sm12(npart),as3(npart),as4(npart),          &
     &as6(npart),sm23(npart),rhoc(npart),siq(npart),aek(npart),         &
     &afok(npart),hp(npart),hm(npart),hc(npart),hs(npart),wf(npart),    &
     &wfa(npart),wfhi(npart),rhoi(npart),hi(npart),fi(npart),hi1(npart),&
     &xvl(2,npart),yvl(2,npart),ejvl(npart),dpsvl(npart),oidpsv(npart), &
     &sigmvl(npart),iv(npart),aperv(npart,2),ixv(npart),clov(2,npart),  &
     &clopv(2,npart),alf0v(npart,2),bet0v(npart,2),ampv(npart)
      common/main3/ clo6v(3,npart),clop6v(3,npart),hv(6,2,npart,nblo),  &
     &bl1v(6,2,npart,nblo),tas(npart,6,6),qwcs(npart,3),di0xs(npart),   &
     &di0zs(npart),dip0xs(npart),dip0zs(npart),xau(2,6),cloau(6),       &
     &di0au(4),tau(6,6),tasau(npart,6,6),wx(3),x1(6),x2(6),fake(2,20)
      integer numx
      double precision e0f
      common/main4/ e0f,numx
      integer ktrack,nwri
      double precision dpsv1,strack,strackc,stracks,strackx,strackz
      common/track/ ktrack(nblz),strack(nblz),strackc(nblz),            &
     &stracks(nblz),strackx(nblz),strackz(nblz),dpsv1(npart),nwri
      save
!---------------------------------------  SUBROUTINE 'ENVARS' IN-LINE
      do 10 j=1,napx
        dpd(j)=one+dpsv(j)
        dpsq(j)=sqrt(dpd(j))
!
   10 continue
      do 160 l=1,il
        if(abs(el(l)).le.pieni) goto 160
        kz1=kz(l)+1
!       goto(20,40,80,60,40,60,100,100,140),kz1
!       goto 160
!Eric
!-----------------------------------------------------------------------
!  DRIFTLENGTH
!-----------------------------------------------------------------------
        if (kz1.eq.1) then
          goto 20
!-----------------------------------------------------------------------
!  RECTANGULAR MAGNET
!  HORIZONTAL
!-----------------------------------------------------------------------
        elseif (kz1.eq.2.or.kz1.eq.5) then
   40     fokm=el(l)*ed(l)
          if(abs(fokm).le.pieni) goto 20
          if(kz1.eq.2) then
            ih1=1
            ih2=2
          else
!  RECTANGULAR MAGNET VERTICAL
            ih1=2
            ih2=1
          endif
          do 50 j=1,napx
            fok(j)=fokm/dpsq(j)
            rho(j)=(one/ed(l))*dpsq(j)
            fok1(j)=(tan_rn(fok(j)*half))/rho(j)
            si(j)=sin_rn(fok(j))
            co(j)=cos_rn(fok(j))
            al(2,ih1,j,l)=rho(j)*si(j)
!hr01       al(5,ih1,j,l)=-dpsv(j)*(rho(j)*(one-co(j))/dpsq(j))*c1e3
      al(5,ih1,j,l)=((-1d0*dpsv(j))*((rho(j)*(one-co(j)))/dpsq(j)))*c1e3 !hr01
!hr01       al(6,ih1,j,l)=-dpsv(j)*(two*tan_rn(fok(j)*half)/dpsq(j))*   &
!hr01&c1e3
      al(6,ih1,j,l)=((-1d0*dpsv(j))*((two*tan_rn(fok(j)*half))/dpsq(j)))&!hr01
     &*c1e3                                                              !hr01
            sm1(j)=cos_rn(fok(j))
            sm2(j)=sin_rn(fok(j))*rho(j)
            sm3(j)=-sin_rn(fok(j))/rho(j)
            sm12(j)=el(l)-sm1(j)*sm2(j)
            sm23(j)=sm2(j)*sm3(j)
!hr01       as3(j)=-rvv(j)*(dpsv(j)*rho(j)/(two*dpsq(j))*sm23(j)- rho(j)&
!hr01&*dpsq(j)*(one-sm1(j)))
      as3(j)=(-1d0*rvv(j))*(((dpsv(j)*rho(j))/(two*dpsq(j)))*sm23(j)-   &!hr01
     &(rho(j)*dpsq(j))*(one-sm1(j)))                                    &!hr01
!hr01       as4(j)=-rvv(j)*sm23(j)/c2e3
            as4(j)=((-1d0*rvv(j))*sm23(j))/c2e3                          !hr01
!hr01       as6(j)=-rvv(j)*(el(l)+sm1(j)*sm2(j))/c4e3
            as6(j)=((-1d0*rvv(j))*(el(l)+sm1(j)*sm2(j)))/c4e3            !hr01
!hr01       as(1,ih1,j,l)=(-rvv(j)*(dpsv(j)*dpsv(j)/(four*dpd(j))*
!hr01&sm12(j)+dpsv(j)*(el(l)-sm2(j)))+el(l)*(one-rvv(j)))*c1e3
            as(1,ih1,j,l)=(el(l)*(one-rvv(j))-rvv(j)*((dpsv(j)**2/      &!hr06
     &(four*dpd(j)))*sm12(j)+dpsv(j)*(el(l)-sm2(j))))*c1e3               !hr06
!hr01       as(2,ih1,j,l)=-rvv(j)*(dpsv(j)/(two*rho(j)*dpsq(j))*sm12(j)-&
!hr01&sm2(j)*dpsq(j)/rho(j))+fok1(j)*as3(j)
         as(2,ih1,j,l)=(-1d0*rvv(j))*((dpsv(j)/((two*rho(j))*dpsq(j)))* &!hr01
     &sm12(j)-(sm2(j)*dpsq(j))/rho(j))+fok1(j)*as3(j)                    !hr01
            as(3,ih1,j,l)=as3(j)
!hr01       as(4,ih1,j,l)=as4(j)+two*as6(j)*fok1(j)
            as(4,ih1,j,l)=as4(j)+(two*as6(j))*fok1(j)                    !hr01
!hr01       as(5,ih1,j,l)=-rvv(j)*sm12(j)/(c4e3*rho(j)*rho(j))+ as6(j)  &
!hr01&*fok1(j)*fok1(j)+fok1(j)*as4(j)
            as(5,ih1,j,l)=((-1d0*rvv(j))*sm12(j))/(c4e3*rho(j)**2)+     &!hr01
     &as6(j)*fok1(j)**2+fok1(j)*as4(j)                                   !hr01
            as(6,ih1,j,l)=as6(j)
!--VERTIKAL
            g(j)=tan_rn(fok(j)*half)/rho(j)
            gl(j)=el(l)*g(j)
            al(1,ih2,j,l)=one-gl(j)
!hr01       al(3,ih2,j,l)=-g(j)*(two-gl(j))
            al(3,ih2,j,l)=(-1d0*g(j))*(two-gl(j))                        !hr01
            al(4,ih2,j,l)=al(1,ih2,j,l)
!hrr01      as6(j)=-rvv(j)*al(2,ih2,j,l)/c2e3
            as6(j)=((-1d0*rvv(j))*al(2,ih2,j,l))/c2e3                    !hr01
!hr01       as(4,ih2,j,l)=-two*as6(j)*fok1(j)
            as(4,ih2,j,l)=((-1d0*two)*as6(j))*fok1(j)                    !hr01
!hr01       as(5,ih2,j,l)=as6(j)*fok1(j)*fok1(j)
            as(5,ih2,j,l)=(as6(j)*fok1(j))*fok1(j)                       !hr01
            as(6,ih2,j,l)=as6(j)
   50     continue
          goto 160
        elseif (kz1.eq.4.or.kz1.eq.6) then
!-----------------------------------------------------------------------
!  SEKTORMAGNET
!  HORIZONTAL
!-----------------------------------------------------------------------
   60     fokm=el(l)*ed(l)
          if(abs(fokm).le.pieni) goto 20
          if(kz1.eq.4) then
            ih1=1
            ih2=2
          else
!  SECTOR MAGNET VERTICAL
            ih1=2
            ih2=1
          endif
          do 70 j=1,napx
            fok(j)=fokm/dpsq(j)
            rho(j)=(one/ed(l))*dpsq(j)
            si(j)=sin_rn(fok(j))
            co(j)=cos_rn(fok(j))
!hr01       rhoc(j)=rho(j)*(one-co(j))/dpsq(j)
            rhoc(j)=(rho(j)*(one-co(j)))/dpsq(j)                         !hr01
            siq(j)=si(j)/dpsq(j)
            al(1,ih1,j,l)=co(j)
            al(2,ih1,j,l)=rho(j)*si(j)
!hr01       al(3,ih1,j,l)=-si(j)/rho(j)
            al(3,ih1,j,l)=(-1d0*si(j))/rho(j)                            !hr01
            al(4,ih1,j,l)=co(j)
!hr01       al(5,ih1,j,l)=-dpsv(j))*rhoc(j)*c1e3
            al(5,ih1,j,l)=((-1d0*dpsv(j))*rhoc(j))*c1e3                  !hr01
!hr01       al(6,ih1,j,l)=-dpsv(j)*siq(j)*c1e3
            al(6,ih1,j,l)=((-1d0*dpsv(j))*siq(j))*c1e3                   !hr01
            sm12(j)=el(l)-al(1,ih1,j,l)*al(2,ih1,j,l)
            sm23(j)=al(2,ih1,j,l)*al(3,ih1,j,l)
!hr01       as(1,ih1,j,l)=(-rvv(j)*(dpsv(j)*dpsv(j)/(four*dpd(j))*      &
!hr01&sm12(j)+dpsv(j)*(el(l)-al(2,ih1,j,l)))+el(l)*(one-rvv(j)))*c1e3
            as(1,ih1,j,l)=(el(l)*(one-rvv(j))-rvv(j)*((dpsv(j)**2/      &!hr06
     &(four*dpd(j)))*sm12(j)+dpsv(j)*(el(l)-al(2,ih1,j,l))))*c1e3        !hr06
!hr01       as(2,ih1,j,l)=-rvv(j)*(dpsv(j)/(two*rho(j)*dpsq(j))*sm12(j)-&
!hr01&dpd(j)*siq(j))
      as(2,ih1,j,l)=(-1d0*rvv(j))*((dpsv(j)/(two*rho(j)*dpsq(j)))*      &!hr01
     &sm12(j)-dpd(j)*siq(j))                                             !hr01
!hr01       as(3,ih1,j,l)=-rvv(j)*(dpsv(j)*rho(j)/(two*dpsq(j))*sm23(j)-&
!hr01&dpd(j)*rhoc(j))
      as(3,ih1,j,l)=(-1d0*rvv(j))*(((dpsv(j)*rho(j))/(two*dpsq(j)))*    &!hr01
     &sm23(j)-dpd(j)*rhoc(j))                                            !hr01
!hr01       as(4,ih1,j,l)=-rvv(j)*sm23(j)/c2e3
            as(4,ih1,j,l)=((-1d0*rvv(j))*sm23(j))/c2e3                   !hr01
!hr01       as(5,ih1,j,l)=-rvv(j)*sm12(j)/(c4e3*rho(j)*rho(j))
            as(5,ih1,j,l)=((-1d0*rvv(j))*sm12(j))/((c4e3*rho(j))*rho(j)) !hr01
!hr01       as(6,ih1,j,l)=-rvv(j)*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l))/  &
      as(6,ih1,j,l)=((-1d0*rvv(j))*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l)))/&!hr01
     &c4e3
!--VERTIKAL
!hr01       as(6,ih2,j,l)=-rvv(j)*al(2,ih2,j,l)/c2e3
            as(6,ih2,j,l)=((-1d0*rvv(j))*al(2,ih2,j,l))/c2e3             !hr01
   70     continue
          goto 160
        elseif (kz1.eq.3) then
!-----------------------------------------------------------------------
!  QUADRUPOLE
!  FOCUSSING
!-----------------------------------------------------------------------
   80   do 90 j=1,napx
            fok(j)=ekv(j,l)*oidpsv(j)
            aek(j)=abs(fok(j))
            hi(j)=sqrt(aek(j))
            fi(j)=el(l)*hi(j)
            if(fok(j).le.zero) then
              al(1,1,j,l)=cos_rn(fi(j))
              hi1(j)=sin_rn(fi(j))
              if(abs(hi(j)).le.pieni) then
                al(2,1,j,l)=el(l)
              else
                al(2,1,j,l)=hi1(j)/hi(j)
              endif
              al(3,1,j,l)=-hi1(j)*hi(j)
              al(4,1,j,l)=al(1,1,j,l)
              as(1,1,j,l)=el(l)*(one-rvv(j))*c1e3
!hr01         as(4,1,j,l)=-rvv(j)*al(2,1,j,l)*al(3,1,j,l)/c2e3
              as(4,1,j,l)=(((-1d0*rvv(j))*al(2,1,j,l))*al(3,1,j,l))/c2e3 !hr01
!hr01         as(5,1,j,l)=-rvv(j)*(el(l)-al(1,1,j,l)*al(2,1,j,l))*      &
!hr01&aek(j)/c4e3
           as(5,1,j,l)=(((-1d0*rvv(j))*(el(l)-al(1,1,j,l)*al(2,1,j,l)))*&!hr01
     &aek(j))/c4e3                                                       !hr01
!hr01         as(6,1,j,l)=-rvv(j)*(el(l)+al(1,1,j,l)*al(2,1,j,l))/c4e3
       as(6,1,j,l)=((-1d0*rvv(j))*(el(l)+al(1,1,j,l)*al(2,1,j,l)))/c4e3  !hr01
!--DEFOCUSSING
              hp(j)=exp_rn(fi(j))
              hm(j)=one/hp(j)
              hc(j)=(hp(j)+hm(j))*half
              hs(j)=(hp(j)-hm(j))*half
              al(1,2,j,l)=hc(j)
              if(abs(hi(j)).le.pieni) then
                al(2,2,j,l)=el(l)
              else
                al(2,2,j,l)=hs(j)/hi(j)
              endif
              al(3,2,j,l)=hs(j)*hi(j)
              al(4,2,j,l)=hc(j)
!hr01         as(4,2,j,l)=-rvv(j)*al(2,2,j,l)*al(3,2,j,l)/c2e3
              as(4,2,j,l)=(((-1d0*rvv(j))*al(2,2,j,l))*al(3,2,j,l))/c2e3 !hr01
!hr01         as(5,2,j,l)=+rvv(j)*(el(l)-al(1,2,j,l)*al(2,2,j,l))*      &
!hr01&aek(j)/c4e3
              as(5,2,j,l)=((rvv(j)*(el(l)-al(1,2,j,l)*al(2,2,j,l)))*    &!hr01
     &aek(j))/c4e3                                                       !hr01
!hr01         as(6,2,j,l)=-rvv(j)*(el(l)+al(1,2,j,l)*al(2,2,j,l))/c4e3
      as(6,2,j,l)=((-1d0*rvv(j))*(el(l)+al(1,2,j,l)*al(2,2,j,l)))/c4e3   !hr01
            else
              al(1,2,j,l)=cos_rn(fi(j))
              hi1(j)=sin_rn(fi(j))
              if(abs(hi(j)).le.pieni) then
                al(2,2,j,l)=el(l)
              else
                al(2,2,j,l)=hi1(j)/hi(j)
              endif
!hr01         al(3,2,j,l)=-hi1(j)*hi(j)
              al(3,2,j,l)=(-1d0*hi1(j))*hi(j)                            !hr01
              al(4,2,j,l)=al(1,2,j,l)
!hr01         as(1,2,j,l)=el(l)*(one-rvv(j))*c1e3
              as(1,2,j,l)=(el(l)*(one-rvv(j)))*c1e3                      !hr01
!hr01         as(4,2,j,l)=-rvv(j)*al(2,2,j,l)*al(3,2,j,l)/c2e3
              as(4,2,j,l)=(((-1d0*rvv(j))*al(2,2,j,l))*al(3,2,j,l))/c2e3 !hr01
!hr01         as(5,2,j,l)=-rvv(j)*(el(l)-al(1,2,j,l)*al(2,2,j,l))*      &
!hr01&aek(j)/c4e3
           as(5,2,j,l)=(((-1d0*rvv(j))*(el(l)-al(1,2,j,l)*al(2,2,j,l)))*&!hr01
     &aek(j))/c4e3                                                       !hr01
!hr01         as(6,2,j,l)=-rvv(j)*(el(l)+al(1,2,j,l)*al(2,2,j,l))/c4e3
        as(6,2,j,l)=((-1d0*rvv(j))*(el(l)+al(1,2,j,l)*al(2,2,j,l)))/c4e3 !hr01
!--DEFOCUSSING
              hp(j)=exp_rn(fi(j))
              hm(j)=one/hp(j)
              hc(j)=(hp(j)+hm(j))*half
              hs(j)=(hp(j)-hm(j))*half
              al(1,1,j,l)=hc(j)
              if(abs(hi(j)).le.pieni) then
                al(2,1,j,l)=el(l)
              else
                al(2,1,j,l)=hs(j)/hi(j)
              endif
              al(3,1,j,l)=hs(j)*hi(j)
              al(4,1,j,l)=hc(j)
!hr01         as(4,1,j,l)=-rvv(j)*al(2,1,j,l)*al(3,1,j,l)/c2e3
              as(4,1,j,l)=(((-1d0*rvv(j))*al(2,1,j,l))*al(3,1,j,l))/c2e3 !hr01
!hr01         as(5,1,j,l)=+rvv(j)*(el(l)-al(1,1,j,l)*al(2,1,j,l))*      &
!hr01&aek(j)/c4e3
              as(5,1,j,l)=((rvv(j)*(el(l)-al(1,1,j,l)*al(2,1,j,l)))*    &!hr01
     &aek(j))/c4e3                                                       !hr01
!hr01         as(6,1,j,l)=-rvv(j)*(el(l)+al(1,1,j,l)*al(2,1,j,l))/c4e3
        as(6,1,j,l)=((-1d0*rvv(j))*(el(l)+al(1,1,j,l)*al(2,1,j,l)))/c4e3 !hr01
            endif
   90     continue
          goto 160
        elseif (kz1.eq.7.or.kz1.eq.8) then
!-----------------------------------------------------------------------
!  COMBINED FUNCTION MAGNET HORIZONTAL
!  FOCUSSING
!-----------------------------------------------------------------------
  100     if(kz1.eq.7) then
            do 110 j=1,napx
              fokqv(j)=ekv(j,l)
  110       continue
            ih1=1
            ih2=2
          else
!  COMBINED FUNCTION MAGNET VERTICAL
            do 120 j=1,napx
              fokqv(j)=-ekv(j,l)
  120       continue
            ih1=2
            ih2=1
          endif
          do 130 j=1,napx
            wf(j)=ed(l)/dpsq(j)
!hr01       fok(j)=fokqv(j)/dpd(j)-wf(j)*wf(j)
            fok(j)=fokqv(j)/dpd(j)-wf(j)**2                              !hr01
            afok(j)=abs(fok(j))
            hi(j)=sqrt(afok(j))
            fi(j)=hi(j)*el(l)
            if(afok(j).le.pieni) then
!hr01         as(6,1,j,l)=-rvv(j)*el(l)/c2e3
              as(6,1,j,l)=((-1d0*rvv(j))*el(l))/c2e3                     !hr01
              as(6,2,j,l)=as(6,1,j,l)
!hr01         as(1,1,j,l)=el(l)*(one-rvv(j))*c1e3
              as(1,1,j,l)=(el(l)*(one-rvv(j)))*c1e3                      !hr01
            endif
!hr06       if(fok(j).lt.-pieni) then
            if(fok(j).lt.(-1d0*pieni)) then                              !hr06
              si(j)=sin_rn(fi(j))
              co(j)=cos_rn(fi(j))
!hr01         wfa(j)=wf(j)/afok(j)*(one-co(j))/dpsq(j)
              wfa(j)=((wf(j)/afok(j))*(one-co(j)))/dpsq(j)               !hr01
!hr01         wfhi(j)=wf(j)/hi(j)*si(j)/dpsq(j)
              wfhi(j)=((wf(j)/hi(j))*si(j))/dpsq(j)                      !hr01
              al(1,ih1,j,l)=co(j)
              al(2,ih1,j,l)=si(j)/hi(j)
!hr01         al(3,ih1,j,l)=-si(j)*hi(j)
              al(3,ih1,j,l)=(-1d0*si(j))*hi(j)                           !hr01
              al(4,ih1,j,l)=co(j)
!hr01         al(5,ih1,j,l)=-wfa(j)*dpsv(j)*c1e3
              al(5,ih1,j,l)=((-1d0*wfa(j))*dpsv(j))*c1e3                 !hr01
!hr01         al(6,ih1,j,l)=-wfhi(j)*dpsv(j)*c1e3
              al(6,ih1,j,l)=((-1d0*wfhi(j))*dpsv(j))*c1e3                !hr01
              sm12(j)=el(l)-al(1,ih1,j,l)*al(2,ih1,j,l)
              sm23(j)=al(2,ih1,j,l)*al(3,ih1,j,l)
!hr01         as(1,ih1,j,l)=(-rvv(j)*(dpsv(j)*dpsv(j)/(four*dpd(j))*sm12&
!hr01&(j)+ dpsv(j)*(el(l)-al(2,ih1,j,l)))/afok(j)*wf(j)*wf(j)+el        &
!hr01&(l)* (one-rvv(j)))*c1e3
      as(1,ih1,j,l)=(el(l)*(one-rvv(j))-                                &!hr06
     &((rvv(j)*((dpsv(j)**2/(four*dpd(j)))*                             &!hr06
     &sm12(j)+dpsv(j)*(el(l)-al(2,ih1,j,l))))/afok(j))*wf(j)**2)*c1e3    !hr06
!hr01         as(2,ih1,j,l)=-rvv(j)*(dpsv(j)*wf(j)/(two*dpsq(j))*       &
!hr01&sm12(j)-dpd(j)*wfhi(j))
           as(2,ih1,j,l)=(-1d0*rvv(j))*(((dpsv(j)*wf(j))/(two*dpsq(j)))*&!hr01
     &sm12(j)-dpd(j)*wfhi(j))                                            !hr01
!hr01         as(3,ih1,j,l)=-rvv(j)*(dpsv(j)*half/afok(j)/dpd(j)* ed(l) &
!hr01&*sm23(j)-dpd(j)*wfa(j))
      as(3,ih1,j,l)=(-1d0*rvv(j))*(((((dpsv(j)*half)/afok(j))/dpd(j))*  &!hr01
     &ed(l))*sm23(j)-dpd(j)*wfa(j))                                      !hr01
!hr01       as(4,ih1,j,l)=-rvv(j)*sm23(j)/c2e3
            as(4,ih1,j,l)=((-1d0*rvv(j))*sm23(j))/c2e3                   !hr01
!hr01         as(5,ih1,j,l)=-rvv(j)*sm12(j)*afok(j)/c4e3
              as(5,ih1,j,l)=(((-1d0*rvv(j))*sm12(j))*afok(j))/c4e3       !hr01
!hr01         as(6,ih1,j,l)=-rvv(j)*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l)) &
!hr01&/c4e3
      as(6,ih1,j,l)=((-1d0*rvv(j))*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l))) &!hr01
     &/c4e3                                                              !hr01
              aek(j)=abs(ekv(j,l)/dpd(j))
              hi(j)=sqrt(aek(j))
              fi(j)=hi(j)*el(l)
              hp(j)=exp_rn(fi(j))
              hm(j)=one/hp(j)
              hc(j)=(hp(j)+hm(j))*half
              hs(j)=(hp(j)-hm(j))*half
              al(1,ih2,j,l)=hc(j)
              if(abs(hi(j)).gt.pieni) al(2,ih2,j,l)=hs(j)/hi(j)
              al(3,ih2,j,l)=hs(j)*hi(j)
              al(4,ih2,j,l)=hc(j)
!hr01         as(4,ih2,j,l)=-rvv(j)*al(2,ih2,j,l)*al(3,ih2,j,l)/c2e3
      as(4,ih2,j,l)=(((-1d0*rvv(j))*al(2,ih2,j,l))*al(3,ih2,j,l))/c2e3   !hr01
!hr01         as(5,ih2,j,l)=+rvv(j)*(el(l)-al(1,ih2,j,l)*al(2,ih2,j,l))*&
!hr01&aek(j)/c4e3
            as(5,ih2,j,l)=((rvv(j)*(el(l)-al(1,ih2,j,l)*al(2,ih2,j,l)))*&!hr01
     &aek(j))/c4e3                                                       !hr01
!hr01         as(6,ih2,j,l)=-rvv(j)*(el(l)+al(1,ih2,j,l)*al(2,ih2,j,l)) &
!hr01&/c4e3
      as(6,ih2,j,l)=((-1d0*rvv(j))*(el(l)+al(1,ih2,j,l)*al(2,ih2,j,l))) &!hr01
     &/c4e3                                                              !hr01
            endif
!--DEFOCUSSING
            if(fok(j).gt.pieni) then
              hp(j)=exp_rn(fi(j))
              hm(j)=one/hp(j)
              hc(j)=(hp(j)+hm(j))*half
              hs(j)=(hp(j)-hm(j))*half
              al(1,ih1,j,l)=hc(j)
              al(2,ih1,j,l)=hs(j)/hi(j)
              al(3,ih1,j,l)=hs(j)*hi(j)
              al(4,ih1,j,l)=hc(j)
!hr01         wfa(j)=wf(j)/afok(j)*(one-hc(j))/dpsq(j)
              wfa(j)=((wf(j)/afok(j))*(one-hc(j)))/dpsq(j)               !hr01
!hr01         wfhi(j)=wf(j)/hi(j)*hs(j)/dpsq(j)
              wfhi(j)=((wf(j)/hi(j))*hs(j))/dpsq(j)                      !hr01
!hr01         al(5,ih1,j,l)= wfa(j)*dpsv(j)*c1e3
              al(5,ih1,j,l)= (wfa(j)*dpsv(j))*c1e3                       !hr01
!hr01         al(6,ih1,j,l)=-wfhi(j)*dpsv(j)*c1e3
              al(6,ih1,j,l)=((-1d0*wfhi(j))*dpsv(j))*c1e3                !hr01
              sm12(j)=el(l)-al(1,ih1,j,l)*al(2,ih1,j,l)
              sm23(j)=al(2,ih1,j,l)*al(3,ih1,j,l)
!hr06         as(1,ih1,j,l)=(rvv(j)*(dpsv(j)*dpsv(j)/(four*dpd(j))*
!hr06&sm12(j)+dpsv(j)*(el(l)-al(2,ih1,j,l)))/afok(j)*wf(j)*wf(j)+el(l)* &
!hr06&(one-rvv(j)))*c1e3
              as(1,ih1,j,l)=(((rvv(j)*((dpsv(j)**2/(four*dpd(j)))*      &!hr06
     &sm12(j)+dpsv(j)*(el(l)-al(2,ih1,j,l))))/afok(j))*wf(j)**2+el(l)*  &!hr06
     &(one-rvv(j)))*c1e3                                                 !hr06
!hr01         as(2,ih1,j,l)=-rvv(j)*(dpsv(j)*wf(j)/(two*dpsq(j))*       &
!hr01&sm12(j)-dpd(j)*wfhi(j))
           as(2,ih1,j,l)=(-1d0*rvv(j))*(((dpsv(j)*wf(j))/(two*dpsq(j)))*&!hr01
     &sm12(j)-dpd(j)*wfhi(j))                                            !hr01
!hr01         as(3,ih1,j,l)=rvv(j)*(dpsv(j)*half/afok(j)/dpd(j)* ed(l)  &
!hr01&*sm23(j)-dpd(j)*wfa(j))
      as(3,ih1,j,l)=rvv(j)*(((((dpsv(j)*half)/afok(j))/dpd(j))* ed(l))  &!hr01
     &*sm23(j)-dpd(j)*wfa(j))                                            !hr01
!hr01         as(4,ih1,j,l)=-rvv(j)*sm23(j)/c2e3
              as(4,ih1,j,l)=((-1d0*rvv(j))*sm23(j))/c2e3                 !hr01
!hr01         as(5,ih1,j,l)=+rvv(j)*sm12(j)*afok(j)/c4e3
              as(5,ih1,j,l)=((rvv(j)*sm12(j))*afok(j))/c4e3              !hr01
!hr01         as(6,ih1,j,l)=-rvv(j)*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l)) &
!hr01&/c4e3
      as(6,ih1,j,l)=((-1d0*rvv(j))*(el(l)+al(1,ih1,j,l)*al(2,ih1,j,l))) &!hr01
     &/c4e3                                                              !hr01
              aek(j)=abs(ekv(j,l)/dpd(j))
              hi(j)=sqrt(aek(j))
              fi(j)=hi(j)*el(l)
              si(j)=sin_rn(fi(j))
              co(j)=cos_rn(fi(j))
              al(1,ih2,j,l)=co(j)
              al(2,ih2,j,l)=si(j)/hi(j)
!hr01         al(3,ih2,j,l)=-si(j)*hi(j)
              al(3,ih2,j,l)=(-1d0*si(j))*hi(j)                           !hr01
              al(4,ih2,j,l)=co(j)
!hr01         as(4,ih2,j,l)=-rvv(j)*al(2,ih2,j,l)*al(3,ih2,j,l)/c2e3
        as(4,ih2,j,l)=(((-1d0*rvv(j))*al(2,ih2,j,l))*al(3,ih2,j,l))/c2e3 !hr01
!hr01         as(5,ih2,j,l)=-rvv(j)*(el(l)-al(1,ih2,j,l)*al(2,ih2,j,l))*&
!hr01&aek(j)/c4e3
      as(5,ih2,j,l)=(((-1d0*rvv(j))*(el(l)-al(1,ih2,j,l)*al(2,ih2,j,l)))&!hr01
     &*aek(j))/c4e3                                                      !hr01
!hr01         as(6,ih2,j,l)=-rvv(j)*(el(l)+al(1,ih2,j,l)*al(2,ih2,j,l)) &
!hr01&/c4e3
      as(6,ih2,j,l)=((-1d0*rvv(j))*(el(l)+al(1,ih2,j,l)*al(2,ih2,j,l))) &!hr01
     &/c4e3                                                              !hr01
            endif
  130     continue
          goto 160
        elseif (kz1.eq.9) then
!-----------------------------------------------------------------------
!  EDGE FOCUSSING
!-----------------------------------------------------------------------
  140     do 150 j=1,napx
            rhoi(j)=ed(l)/dpsq(j)
!hr01       fok(j)=rhoi(j)*tan_rn(el(l)*rhoi(j)*half)
            fok(j)=rhoi(j)*tan_rn((el(l)*rhoi(j))*half)                  !hr01
            al(3,1,j,l)=fok(j)
            al(3,2,j,l)=-fok(j)
  150     continue
          goto 160
        else
!Eric
! Is really an error but old code went to 160
          goto 160
        endif
!-----------------------------------------------------------------------
!  DRIFTLENGTH
!-----------------------------------------------------------------------
   20   do 30 j=1,napx
!hr01     as(6,1,j,l)=-rvv(j)*el(l)/c2e3
          as(6,1,j,l)=((-1d0*rvv(j))*el(l))/c2e3                         !hr01
          as(6,2,j,l)=as(6,1,j,l)
!hr01     as(1,1,j,l)=el(l)*(one-rvv(j))*c1e3
          as(1,1,j,l)=(el(l)*(one-rvv(j)))*c1e3                          !hr01
   30   continue
  160 continue
!---------------------------------------  END OF 'ENVARS' (2)
      return
      end
