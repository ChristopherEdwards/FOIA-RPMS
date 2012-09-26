BSDX43 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
EN ;
 W !!,$$CTR("*** Patient Wellness Handout ***"),!!
SELTYP ;
 K DIADD,DLAYGO
 D ^XBFMK
 K DIC S DIC="^APCHPWHT(",DIC("A")="Select Patient Wellness Handout type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,16)
 I $D(^DISV(DUZ,"^APCHPWHT(")) S Y=^("^APCHPWHT(") I $D(^APCHPWHT(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC K DIC
 I Y=-1 D EXIT Q
 S APCHPWHT=+Y
SELPT ;
 W !
 S DFN=""
 K DIC S DIC=9000001,DIC("A")="Select patient: ",DIC(0)="AEQM" D ^DIC K DIC
 I Y=-1 G SELTYP
 S DFN=+Y W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) !,"Patient's chart number is ",$P(^(0),U,2),!
 I $$AGE^AUPNPAT(DFN,DT)<18 W !,"Warning:  This handout is designed for patients 18 and older.  This",!,"patient is under 18.  Please select a different patient." K DFN G SELPT
 ;.S APCHSQ=""
 ;.K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue and print the handout",DIR("B")="N" KILL DA D ^DIR KILL DIR
 ;.I 'Y S APCHSQ=1
 ;.Q
 D ZIS
 D EXIT
 Q
 ;
EN2(APCHPWHT,P) ;EP
 NEW DFN
 S DFN=P
 D ZIS
 Q
 ;
WISD(DFN,SDATE,BSDMODE,APCHPWHT,EMSG) ;PEP; print PCC health summary
 ; .EMSG = returned error message if error
 ;
 I +DFN=0 Q
 ;
 NEW DGPGM,VAR,VAR1,DEV,POP
 S SDX="ALL",ORDER="",SDREP=0,SDSTART="",DIV=$$DIV^BSDU
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 adde BSDNHS to variable list
 ;S VAR="DIV^ORDER^SDX^SDATE^DFN^SDREP^SDSTART^BSDMODE^BSDNHS"
 ;S VAR1="DIV;ORDER;SDX;SDATE;DFN;SDREP;SDSTART;BSDMODE;BSDNHS"
 ;end of these PATCH 1003 changes
 ;
 S DGPGM="PRINT^BSDX43"
 ;I $G(BSDDEV)]"" D ZIS^BDGF("F","PRINT^BSDX43","PCC HEALTH SUMMARY",VAR1,BSDDEV) Q
 S DEV=$S($G(BSDMODE)="CR":".05",1:".11")   ;default printer fields
 S BDGDEV=$$GET1^DIQ(9009020.2,$$DIV^BSDU,DEV)
 I BDGDEV="" K BDGDEV S EMSG="PCC Health Summary could not be printed: no default "_$S(BSDMODE="CR":"chart request",1:"walk in")_" printer defined in the IHS SCHEDULING PARAMETERS table." Q
 S IOP=BDGDEV D ^%ZIS I POP D END^SDROUT1 Q
 D PRINT
 Q
 ;
ZIS ;EP
 S Y="P"
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 S XBRP="PRINT^BSDX43",XBRC="",XBRX="EXIT^BSDX43",XBNS="APCH;DFN"
 D ^XBDBQUE
 D EXIT
 Q
 ;
EHR(DFN,APCHPWHT)  ;EP - CMI/GRL support for EHR
 I '$G(APCHPWHT) S APCHPWHT=$P($G(^APCCCTRL(DUZ(2),0)),U,16)
 I APCHPWHT="" S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 D EN^XBNEW("PRINT^APCHPWHG","DFN;APCHPWHT")
 Q
EXIT ;
 D EN^XBVK("APCH")
 K DFN
 D ^XBFMK
 Q
 ;
 ;
EXIT1 ;
 D CLEAR^VALM1
 D FULL^VALM1
 K DFN
 D ^XBFMK
 Q
 ;
ENCOMP ;EP
 NEW T,APCHPWHT
 S APCHPWHT=$P($G(^APCCCTRL(DUZ(2),0)),U,16)
 I 'APCHPWHT S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 I 'APCHPWHT Q
 W:$D(IOF) @IOF
 D EHR(APCHSPAT,APCHPWHT)
 Q
 ;
EN1(APCHPWHT) ;EP
 NEW APCHOLD
 D PRINT
 Q
PRINT ;EP
 U IO
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP($J,"APCHPWH")
 D UPDLOG(DFN,APCHPWHT,DUZ)
 D EP1^BSDX42(DFN,APCHPWHT,1) ;gather up data in ^TMP
W ;write out array
 ;W:$D(IOF) @IOF
 K APCHQUIT
 S APCHPG=0 D HEADER
 Q:$D(APCHQUIT)
 S APCHX=0 F  S APCHX=$O(^TMP($J,"APCHPWH",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .;find number of lines until next component
 .S C=0 I ^TMP($J,"APCHPWH",APCHX)["________________" S A=APCHX F  S A=$O(^TMP($J,"APCHPWH",A)) Q:A'=+A  Q:^TMP($J,"APCHPWH",A)["_______________"  S C=C+1
 .I $Y>(IOSL-$S(C<7:(C+3),1:3)) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP($J,"APCHPWH",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 ;footer
 I $E(IOST)="C",IO=IO(0) W ! K DIR S DIR(0)="EO",DIR("A")="End of Report.  Press Enter." D ^DIR K DIR Q
 D EOJ
 D ^%ZISC
 Q
 ;
EOJ ;
 ;
 K ^TMP($J,"APCHPWH")
 D EN^XBVK("APCH")
 D EN^XBVK("APCD")
 D ^XBFMK
 K BIDLLID,BIDLLPRO,BIDLLRUN,BIRESULT,BISITE
 K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 K N,%,T,F,X,Y,B,C,E,F,H,J,L,N,P,T,W,ST,ST0
 Q
HEADER ;
 G:APCHPG=0 HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 S APCHPG=APCHPG+1
 W !,"My Wellness Handout",?45,"Report Date: ",$$FMTE^XLFDT(DT),?72,"Page: ",APCHPG,!,$TR($J("",(IOM-2))," ","-"),!
 I APCHPG>1 W "********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!
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
UPDDEF ;EP - called from option to update default PWH for the site
 W !!,"This option is used to set the default Patient Wellness Handout"
 W !,"for a site."
 W !!
 K DIC S DIC="^APCCCTRL(",DIC("B")=$P(^DIC(4,DUZ(2),0),U),DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 Q
 S DA=+Y,DIE="^APCCCTRL(",DR=".16" D ^DIE
 D ^XBFMK
 Q
 ;
