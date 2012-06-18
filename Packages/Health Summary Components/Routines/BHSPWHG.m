BHSPWHG ;IHS/MSC/MGH  - Health summmary for patient wellness handout;04-Aug-2009 16:52;MGH
 ;;1.0;HEALTH SUMMARY COMONENTS;**3**;March 17, 2006
 ;-----------------------------------------------------------
 ;Copy of APCHPWHG
 ;IHS/CMI/LAB - PCC HEALTH SUMMARY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;------------------------------------------------------------
EHR ;EP - CMI/GRL support for EHR
 N BHSPAT,BHSPHT
 S BHSPAT=DFN
 S BHPWHT=$P($G(^APCCCTRL(DUZ(2),0)),U,16)
 I BHPWHT="" S BHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 D PRINT
 Q
 ;
SEL ;EP -Selected type of handout
 N BHSPAT,BHSFOR,BHSCVD
 S BHSPAT=DFN
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S BHSFOR=0 F  S BHSFOR=$O(GMTSEG(GMTSEGN,9001026,BHSFOR)) Q:BHSFOR'=+BHSFOR!($D(GMTSQIT))  D  Q:$D(GMTSQIT)
 .S BHPWHT=$G(GMTSEG(GMTSEGN,9001026,BHSFOR))
 .Q:BHPWHT=""
 .Q:'$D(^APCHPWHT(BHPWHT))
 .Q:$G(^ACHPWHT(BHPWHT,1))=""
 D PRINT
 Q
EN1(APCHPWHT) ;EP
 NEW APCHOLD
 D PRINT
 Q
PRINT ;EP
 S BHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP($J,"BHPWH")
 D UPDLOG(DFN,BHPWHT,DUZ)
 D EP^APCHPWH1(DFN,BHPWHT,1) ;gather up data in ^TMP
W ;write out array
 ;W:$D(IOF) @IOF
 K BHSQUIT
 ;S BHPG=0 D HEADER
 Q:$D(BHSQUIT)
 S BHX=0 F  S BHX=$O(^TMP($J,"APCHPWH",BHX)) Q:BHX'=+BHX!($D(GMTSQIT))  D
 .;find number of lines until next component
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .S C=0 I ^TMP($J,"APCHPWH",BHX)["________________" S A=BHX F  S A=$O(^TMP($J,"APCHPWH",A)) Q:A'=+A  Q:^TMP($J,"APCHPWH",A)["_______________"  S C=C+1
 .;I $Y>(IOSL-$S(C<7:(C+3),1:3)) D HEADER Q:$D(BHSQUIT)
 .W !,^TMP($J,"APCHPWH",BHX)
 .Q
 D CKP^GMTSUP Q:$D(GMTSQIT)
 Q
 ;footer
 ;I $E(IOST)="C",IO=IO(0) W ! K DIR S DIR(0)="EO",DIR("A")="End of Report.  Press Enter." D ^DIR K DIR Q
 ;D EOJ
 ;Q
 ;
EOJ ;
 ;
 K ^TMP($J,"BHPWH")
 ;D EN^XBVK("APCH")
 ;D EN^XBVK("APCD")
 ;D ^XBFMK
 K BIDLLID,BIDLLPRO,BIDLLRUN,BIRESULT,BISITE,BHX,BHPG
 K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 K N,%,T,F,X,Y,B,C,E,F,H,J,L,N,P,T,W,ST,ST0,A
 Q
HEADER ;
 ;G:BHPG=0 HEAD1
 ;I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 ;W:$D(IOF) @IOF
 ;S BHPG=BHPG+1
 ;W !,"My Wellness Handout",?45,"Report Date: ",$$FMTE^XLFDT(DT),?72,"Page: ",BHPG,!,$TR($J("",(IOM-2))," ","-"),!
 I BHPG>1 W "********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
UPDLOG(P,T,D) ;EP - update pwh log
 I $G(P)="" Q
 I $G(T)="" Q
 NEW DIC,X,DD,DO,D0
 S X=P,DIC="^APCHPWHL(",DIC(0)="L",DIADD=1,DLAYGO=9001027
 S DIC("DR")=".02////"_T_";.03////"_D_";.04////"_DT_";.05///"_$$NOW^XLFDT_";.06////"_DUZ(2)
 K DD,D0,D0
 D FILE^DICN
 D ^XBFMK
 K DIADD,DLAYGO
 Q
 ;
