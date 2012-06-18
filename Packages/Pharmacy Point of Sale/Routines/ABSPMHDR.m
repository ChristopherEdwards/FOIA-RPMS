ABSPMHDR ; IHS/FCS/DRS - MENUS HEADERS ; 
 ;;1.0;PHARMACY POINT OF SALE;**18,22,23**;JUN 21, 2001
 ;
 ;****** Send this routine with each new patch with **n** in piece
 ;****** 3 so the patch level can be displayed as part of the
 ;****** menu header.
 ;IHS/SD/RLT - 8/24/06 - Patch 18
 ;             New code to display patch number in header.
 ;IHS/SD/RLT - 09/20/07 - Patch 22
 ;             Added splash screent for held 3PB claims.
 ;IHS/OIT/SCR - 9/16/08 - Patch 28
 ;            Removed Patch 22 splash screen for held 3PB claims
INIT ;EP -
 I $G(XQY0)'="",$G(ABSPTOP)="" S ABSPTOP=XQY0
 S ABSPY="",ABSPY=$O(^DIC(9.4,"C","ABSP",ABSPY))
 S ABSPVER=^DIC(9.4,ABSPY,"VERSION"),ABSPVER="V"_ABSPVER K ABSPY
 ;RLT - Patch 18
 ;S X=$T(+2),X=$P(X,";;",2),X=$P(X,";",3),X=$P(X,"**",2),X=$P(X,",",$L(X,","))
 S X=$P($$LAST^XPDUTL("PHARMACY POINT OF SALE"),U)
 ;RLT - Patch 18
 S:X]"" ABSPVER=ABSPVER_" P"_X
 S ABSPPNM="PHARMACY POINT OF SALE"
 I '$D(DUZ(2)) W !!,"Your SITE NAME is not set for the KERNEL.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 I '$D(DUZ(0)) W !!,"You do not have the DUZ(0) variable.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 I DUZ(0)'["M",DUZ(0)'["P",DUZ(0)'["p",DUZ(0)'["@" W !!,"You do not have the appropriate FileMan access.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 ;IHS/OIT/SCR - 09/16/08 - Patch 28 - START changes to Remove Patch 22 splash screen for held 3PB claims
 ;IHS/SD/RLT - 09/20/07 - Patch 22
 ; I $P(XQY0,U)="ABSPMENU" D
 ;.N HOLDCHK
 ;.S HOLDCHK=$O(^ABSPHOLD(0))
 ;.I HOLDCHK D HOLDSCR^ABSPOSBH
 ;IHS/OIT/SCR - 09/16/08 - Patch 28 - END changes Remove Patch 22 splash screen for held 3PB claims
 S ABSPSITE=$P(^DIC(4,DUZ(2),0),"^")
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 I $G(IO) S Y=$O(^%ZIS(1,"C",IO,0)) I Y S Y=$P($G(^%ZIS(1,Y,"SUBTYPE")),U) I Y S X=$G(^%ZIS(2,Y,5)),ABSPRVON=$P(X,U,4),ABSPRVOF=$P(X,U,5)
 I $G(ABSPRVON)="" S ABSPRVON="""""",ABSPRVOF=""""""
 Q
 ;
HDR ;EP - Screen header.
 Q:$G(XQY0)=""
 I $G(ABSPTOP)="" D INIT Q:$G(ABSPQUIT)
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2),ABSPMT=$S($P(XQY0,U)="ABSPMENU":"Main Menu",1:X)
 S ABSPPNV=ABSPPNM_" "_ABSPVER
 NEW A,D,F,I,L,N,R,V
 S F=0
 W !
 S A=$X W IORVON,IORVOFF S D=$X S:D>A F=D-A ;compute length of revvideo
 S L=18,R=61,D=R-L+1,N=R-L-1
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W ?L,"*",$$CTR(ABSPPNV,N),?R,"*",!
 W ?L,"*",$$CTR($$LOC(),N),?R,"*",!
 W ?L,"*",?(L+(((R-L)-$L(ABSPMT))\2)),IORVON,ABSPMT,IORVOFF,?R+F,"*",!
 W $$CTR($$REPEAT^XLFSTR("*",D)),!
 K ABSPMT,ABSPPNV
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
