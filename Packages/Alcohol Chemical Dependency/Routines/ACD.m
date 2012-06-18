ACD ;IHS/ADC/EDE/KML - SET UP CDMIS PACKAGE VARS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;****** Send this routine with each new patch with **n** in piece
 ;****** 3 so the patch level can be displayed as part of the
 ;****** menu header.
 ;
 ;//[ALL CDMIS OPTIONS CALL I '$D(ACD6DIG)]
START ;
 I $G(XQY0)'="",$G(ACDTOP)="" S ACDTOP=XQY0
 S ACDY="",ACDY=$O(^DIC(9.4,"C","ACD",ACDY))
 S ACDVER=^DIC(9.4,ACDY,"VERSION"),ACDVER="V"_ACDVER K ACDY
 S X=$T(+2),X=$P(X,";;",2),X=$P(X,";",3),X=$P(X,"**",2),X=$P(X,",",$L(X,","))
 S:X]"" ACDVER=ACDVER_"P"_X
 S ACDPNM="CHEMICAL DEPENDENCY MIS"
 I '$D(DUZ(2)) W !!,"Your SITE NAME is not set for the KERNEL.",!,"Please contact your System Support person.",!! S ACDQUIT=1 Q
 I $G(DUZ(0))'["M",$G(DUZ(0))'["@" W !!,"You do not have the appropriate FileMan access.",!,"Please contact your System Support person.",!! S ACDQUIT=1 Q
 I '$D(^ACDF5PI(DUZ(2),0)) W !!,"Your Program is not defined in the CDMIS PROGRAM file.",!,"Please contact your Site Manager." S ACDQUIT=1 Q
 S ACDPGM=DUZ(2)
 S ACDSITE=$P(^DIC(4,DUZ(2),0),"^"),ACD6DIG=$P(^AUTTLOC(DUZ(2),0),U,10)
 S X=$G(^ACDF5PI(ACDPGM,11)),Y=$P(X,U,3),X=$P(X,U)
 S ACDFPCC=X ;                    PCC link flag
 S ACDFHCP=Y ;                    Hardcopy bill flag
 S ACDFHCPT=0
 I $O(^ACDF5PI(ACDPGM,21,0)) F Y=0:0 S Y=$O(^ACDF5PI(ACDPGM,21,Y)) Q:'Y  S ACDFHCPT(Y)="",ACDFHCPT=ACDFHCPT+1
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 I $G(IO) S Y=$O(^%ZIS(1,"C",IO,0)) I Y S Y=$P($G(^%ZIS(1,Y,"SUBTYPE")),U) I Y S X=$G(^%ZIS(2,Y,5)),ACDRVON=$P(X,U,4),ACDRVOF=$P(X,U,5)
 I $G(ACDRVON)="" S ACDRVON="""""",ACDRVOF=""""""
 Q
 ;
PRHDR ;EP PRINT HEADER 
 D HDR
 Q
 ;
HDR ;EP - Screen header.
 Q:$G(XQY0)=""
 Q:$G(ACD6DIG)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2),ACDMT=$S(X="ACDMENU":"Main Menu",1:X)
 S ACDPNV=ACDPNM_" "_ACDVER
 S ACDHQAF=$S($E(ACD6DIG)=9:"HEADQUARTERS",$E(ACD6DIG,3,4)="00":"AREA OFFICE",1:"")
 NEW A,D,F,I,L,N,R,V
 S F=0
 S A=$X W IORVON,IORVOFF S D=$X S:D>A F=D-A ;compute length of revvideo
 S L=18,R=61,D=R-L+1,N=R-L-1
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W ?L,"*",$$CTR(ACDPNV,N),?R,"*",!
 W:ACDHQAF'="" ?L,"*",$$CTR(ACDHQAF,N),?R,"*",!
 W ?L,"*",$$CTR($$LOC(),N),?R,"*",!
 W ?L,"*",?(L+(((R-L)-$L(ACDMT))\2)),IORVON,ACDMT,IORVOFF,?R+F,"*",!
 W $$CTR($$REPEAT^XLFSTR("*",D)),!
 K ACDHQAF,ACDMT,ACDPNV
 Q
 ;
 ;----------
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
LJRF(X,Y,Z) ;EP - left justify X in a field Y wide, right filling with Z.
 NEW L,M
 I $L(X)'<Y Q $E(X,1,Y-1)_Z
 S L=Y-$L(X)
 S $P(M,Z,L)=Z
 Q X_M
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
