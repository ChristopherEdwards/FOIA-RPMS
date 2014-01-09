BCHRPWH ; IHS/CMI/LAB - PCC HEALTH SUMMARY ;
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
EN ;
 W !!,$$CTR("*** Patient Wellness Handout ***"),!!
SELTYP ;
 K DIADD,DLAYGO
 S Y=$O(^APCHPWHT("B","CHR PWH",0))
 S BCHPWHT=+Y
SELPT ;
 W !
 S DFN=""
 K DIC S DIC=9000001,DIC("A")="Select patient: ",DIC(0)="AEQM" D ^DIC K DIC
 I Y=-1 K DFN,BCHPWHT,DIC Q
 S DFN=+Y W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) !,"Patient's chart number is ",$P(^(0),U,2),!
 D EN2^APCHPWHG(BCHPWHT,DFN)
 K BCHPWHT,DIC,DFN
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
