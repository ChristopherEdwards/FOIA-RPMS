SDMULT ;ALB/TMP - MAKE MULTI-CLINIC APPOINTMENTS ; [ 03/08/2004  7:47 AM ]
 ;;5.3;Scheduling;**63,168**;Aug 13, 1993
 ;IHS/ANMC/LJF  8/18/2000 added DIC("W") to warn if clinic inactivated
 ;             10/18/2000 added check: user have access to princ clin?
 ;
 I '$D(DT) D DT^SDUTL
 S IOP=$S($D(ION):ION,1:"HOME") D ^%ZIS K SDNEXT,SDC1,IOP
1 K SDAPTYP S SDMLT="",DIC="^DPT(",DIC(0)="AQZME" D ^DIC S DFN=+Y I "^"[X K FND S SDNEXT="" K SDMLT,SDAPTYP G END^SDMULT0
 G:Y<0 1 D 2^VADPT I +VADM(6) W !?10,*7,"PATIENT HAS DIED." G 1
 S SDW=$S('$D(^DPT(DFN,.1)):"",^(.1)]"":^(.1),1:""),(SDMM,COLLAT)=0
 S SDXXX="" D EN^SDM I $D(SDMLT1) K FND G END^SDMULT0
 D:'$D(DT) DT^SDUTL S SDCT=0,SDMAX=DT K SDC W !!,"YOU MAY SELECT FROM 2-4 CLINICS",!
RD ;S DIC="^SC(",DIC(0)="AEMQZ",DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))",DIC("A")="Select CLINIC: " D ^DIC K DIC("S"),DIC("A") I X="",SDCT>1 G START^SDMULT0  ;IHS/ANMC/LJF 8/18/2000
 S DIC="^SC(",DIC(0)="AEMQZ",DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))",DIC("A")="Select CLINIC: ",DIC("W")=$$INACTMSG^BSDU D ^DIC K DIC("S"),DIC("A") I X="",SDCT>1 G START^SDMULT0  ;IHS/ANMC/LJF 8/18/2000
 I $S(X["^":1,'$D(DTOUT):0,$D(DTOUT)&DTOUT:1,1:0) K FND G END^SDMULT0
 I $D(SDNEXT) S SDMAX=DT G:X]"" C G END^SDMULT0
 I X']"" W !,*7,"MUST HAVE MORE THAN 1 CLINIC" G RD
 G:Y'>0 RD I $D(SDC1(+Y)) W !,*7,"This clinic has already been selected" G RD
 ;IHS/ITSC/WAR 3/4/04 TESTING NEW CODE
 ;I $D(^SC("AIHSPC",+Y)) S SDPC=+Y D EN^BSDPC K SDPC G RD
 I $D(^SC("AIHSPC",+Y)) W !,*7,"This is a PRINCIPLE clinic, please select one of its subordinate clinics" G RD
 ;End of NEW code 3/4/04
 ;
 ;IHS/ANMC/LJF 10/18/2000
C ;I $D(^SC(+Y,"SDPROT")),$P(^("SDPROT"),"^",1)="Y",'$D(^SC(+Y,"SDPRIV",DUZ)) W !,*7,"Access to ",$$CNAM(+Y)," is prohibited!",!,"Only users with a special code may access this clinic.",*7 G RD
 I $D(^SC(+Y,"SDPROT")),$P(^("SDPROT"),"^",1)="Y",'$D(^SC(+Y,"SDPRIV",DUZ)),'$D(^SC($$PC^BSDU(+Y),"SDPRIV",DUZ)) W !,*7,"Access to ",$$CNAM(+Y)," is prohibited!",!,"Only users with a special code may access this clinic.",*7 G RD
 ;
 I '$D(SDNEXT) S SDOK=0,SC=+Y,SDHY=Y,Y=$S($D(^SC(SC,"SL")):$P(^("SL"),"^",5),1:"") K SD D EN2^SDM S Y=SDHY K SDHY I 'SDOK W !,"CLINIC IGNORED!!" G RD
 K SDOK I '$D(^SC(+Y,"SL")) W !,"No appt length specified - cannot book appts" G RD
 S SL=^("SL"),SDL=+SL ;NAKED REFERENCE ^SC(IFN,"SL")
LEN I $P(SL,"^",2)]"" W !,"  APPOINTMENT LENGTH DESIRED: ",+SL R "// ",X:DTIME G:$L(X)>3 LEN G:X["^" END^SDMULT0 I X]"" S POP=0,S=X D L^SDM1 G:POP LEN S SDL=S
 S X2=$S($D(^SC(+Y,"SDP")):$P(^("SDP"),"^",2),1:0),X1=DT D C^%DTC S SDMAX=$S('(X-DT):SDMAX,'(SDMAX-DT):X,X<SDMAX:X,1:SDMAX)
 I SDMAX'>DT W !,*7,$P(Y,"^",2)," has max # of days for future booking undef or = 0" G RD
 S SDC1(+Y)=$P(Y,U,2)_"^"_SDL,SDCT=SDCT+1,SDC(SDCT)=Y,X2=$S($D(^SC(+Y,"SDP")):$P(^("SDP"),"^",2),1:0),X1=DT D C^%DTC S SDMAX=$S('(X-DT):SDMAX,'(SDMAX-DT):X,X<SDMAX:X,1:SDMAX)
 G DT^SDNEXT:$D(SDNEXT),START^SDMULT0:'(SDCT#4),RD
 ;
 ;
CNAM(SDCL) ;Return clinic name
 ;Input: SDCL=clinic ien
 N SDX
 S SDX=$P($G(^SC(+SDCL,0)),U)
 Q $S($L(SDX):SDX,1:"this clinic")
