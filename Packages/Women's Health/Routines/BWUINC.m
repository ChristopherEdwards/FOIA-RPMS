BWUINC ; IHS/CMI/LAB/PLS - update income status ;06-Oct-2003 15:36;DKM
 ;;2.0;WOMEN'S HEALTH;**8,9**;SEP 21, 2001
 ;
 ;
EP1(DFN) ;EP - CALLED FROM PROTOCOL
 Q:'$G(DFN)
 Q:'$D(^DPT(DFN))
 Q:$P(^DPT(DFN,0),U,19)
 D EN
 D FULL^VALM1
 K VALMHDR
 Q
EP ;EP CALLED FROM DATA ENTRY
 Q:'$G(BWPAT)
 S DFN=BWPAT
 N BWR
 S Y=BWPAT D ^AUPNPAT
 D EN
 Q
START ;EP - update case data
 K BWCASE,BWX,BWY
 W:$D(IOF) @IOF W !!,"***  Update Patient Income Category Data   ***",!!
 S DFN="" F  D GETPAT Q:DFN=""  D EN,FULL^VALM1,EXIT
 D EOJ
 Q
EN ; -- main entry point for BW UPDATE PATIENT CASE DATA
 D EN^VALM("BW UPDATE INCOME/RACE")
 K BWCASE,BWX,BWD,BWRCNT,BWLINE,BWDN
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$TR($J(" ",80)," ","-")
 S VALMHDR(2)="Patient Name: "_IORVON_$P(^DPT(DFN,0),U)_IOINORM_"   DOB: "_$$FTIME^VALM1($P(^DPT(DFN,0),U,3))_"   Sex: "_$P(^DPT(DFN,0),U,2)_"   HRN: "_$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),1:"????")
 S Y=0,X="" F  S Y=$O(^BWP(DFN,2,Y)) Q:Y'=+Y  S Z=$P(^BWP(DFN,2,Y,0),U) I Z S X=X_$P($G(^BWRACE(Z,0)),U)_"   "
 S VALMHDR(3)="Race: "_X
 S VALMHDR(4)=$TR($J(" ",80)," ","-")
 S VALMHDR(5)=""
 S VALMHDR(6)="#   DATE ENTERED       INCOME CATEGORY   # IN HOUSEHOLD"
 Q
 ;
GETPAT ;
 ;W:$D(IOF) @IOF
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y<0 Q
 ;I '$D(^BWP(+Y,0)) W !!,"This patient is not on the Women's Health Register.  Cannot update.",! H 2 S DFN="" Q
 S DFN=+Y
 Q
INIT ; -- init variables and list array
 S VALMSG="?? for more actions  + next screen  - prev screen"
 D GATHER ;gather up all records for display
 S VALMCNT=BWLINE
 Q
 ;
GATHER ;
 K BWCASE
 S BWRCNT=0,BWLINE=0
 S BWD=0 F  S BWD=$O(^AUPNINCS("AA",DFN,BWD)) Q:BWD'=+BWD  D
 .S BWX=0 F  S BWX=$O(^AUPNINCS("AA",DFN,BWD,BWX)) Q:BWX'=+BWX  D
 ..S BWY=0 F  S BWY=$O(^AUPNINCS("AA",DFN,BWD,BWX,BWY)) Q:BWY'=+BWY  D
 ...S BWRCNT=BWRCNT+1,BWLINE=BWLINE+1,%=^AUPNINCS(BWY,0),Y=BWRCNT
 ...S $E(Y,5)=$$VAL^XBDIQ1(9000026,BWY,.03),$E(Y,24)=$$VAL^XBDIQ1(9000026,BWY,.01),$E(Y,42)=$$VAL^XBDIQ1(9000026,BWY,.04)
 ...S BWCASE(BWLINE,0)=Y,BWCASE("IDX",BWLINE,BWRCNT)=BWY
 Q
GETIS ;
 W !!
 S BWDN="",DIR(0)="9000026,.01",DIR("A")="Enter INCOME CATEGORY" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S BWDN=Y
 Q
ADD ;EP called from protocol to open a new case
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !!!!,"Adding New Income Status Entry for ",$P(^DPT(DFN,0),U),!!
 D GETIS
 Q:BWDN=""
 W !,"Adding Income Status..." K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AUPNINCS(",DLAYGO=9000026,DIADD=1,X=BWDN,DIC("DR")=".02////"_DFN_";.03//"_$$FMTE^XLFDT(DT)_";.04"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Adding Income Status entry failed Record failed !!  Deleting Record.",! D PAUSE Q
 S BWPC=+Y
 D EXIT
 Q
EDIT ;
 S BWPC=0
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S BWR1=$O(VALMY(0)) I 'BWR1 K BWR1,VALMY,XQORNOD W !,"No record selected." G EXIT
 S (X,Y)=0 F  S X=$O(BWCASE("IDX",X)) Q:X'=+X!(BWPC)  I $O(BWCASE("IDX",X,0))=BWR1 S Y=$O(BWCASE("IDX",X,0)),BWPC=BWCASE("IDX",X,Y)
 I '$D(^AUPNINCS(BWPC,0)) W !,"Not a valid INCOME STATUS RECORD." K BWR D PAUSE D EXIT Q
 D FULL^VALM1
 S DA=BWPC,DIE="^AUPNINCS(",DR=".01;.03;.04" D ^DIE
 D EXIT
 Q
UR ;EP - called from protocol
 I '$G(DFN) W !!,"DFN undefined!" D PAUSE,EXIT Q
 I $O(^BWP(DFN,2,0)) W !!,"Race values currently entered for this patient:"
 S X=0 F  S X=$O(^BWP(DFN,2,X)) Q:X'=+X  W !?10 S Y=$P(^BWP(DFN,2,X,0),U) I Y W $P(^BWRACE(Y,0),U)
 D FULL^VALM1
 D ^XBFMK
 S DIE="^BWP(",DA=DFN,DR=2 D ^DIE
 D ^XBFMK
 D EXIT
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K BWX,BWCASE,BWPC,BWR1,BWY
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=BWLINE
 D HDR
 K X,Y,Z,I
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
EOJ ;
 K DDSFILE,DIPGM,Y
 K X,Y,%,DR,DDS,DA,DIC
 K BWCASE,BWX,BWD,BWRCNT,BWLINE,BWDN
 D:$D(VALMWD) CLEAR^VALM1
 K VALM,VALMHDR,VALMKEY,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMLST,VALMVAR,VALMLFT,VALMBCK,VALMCC,VALMAR,VALMBG,VALMCAP,VALMCOFF,VALMCNT,VALMCON,BALMON,VALMEVL,VALMIOXY
 D KILL^AUPNPAT
 Q
 ;
INCV(V,F) ;EP - patient's income level at date of visit v
 I $G(F)="" S F="I"
 I '$G(V) Q ""
 NEW X,Y,Z,P
 I '$D(^AUPNVSIT(V,0)) Q ""
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S X=0,Y="" F  S X=$O(^AUPNINCS("AA",P,X)) Q:X'=+X!(Y)  D
 .S Z=0 F  S Z=$O(^AUPNINCS("AA",P,X,Z)) Q:Z'=+Z!(Y)  D
 ..I (9999999-X)'>D S Y=$O(^AUPNINCS("AA",P,X,Z,0))
 ..Q
 .Q
 I Y="" Q ""
 Q $S(F="I":$$VALI^XBDIQ1(9000026,Y,.01),1:$$VAL^XBDIQ1(9000026,Y,.01))
 I 'P Q ""
INCWH(V,F) ;EP - income stat at procedure date
 I $G(F)="" S F="I"
 I '$G(V) Q ""
 NEW X,Y,Z,P
 I '$D(^BWPCD(V,0)) Q ""
 S P=$P(^BWPCD(V,0),U,2)
 S D=$P($P(^BWPCD(V,0),U,12),".")
 S X=0,Y="" F  S X=$O(^AUPNINCS("AA",P,X)) Q:X'=+X!(Y)  D
 .S Z=0 F  S Z=$O(^AUPNINCS("AA",P,X,Z)) Q:Z'=+Z!(Y)  D
 ..I (9999999-X)'>D S Y=$O(^AUPNINCS("AA",P,X,Z,0))
 ..Q
 .Q
 I Y="" Q ""
 Q $S(F="I":$$VALI^XBDIQ1(9000026,Y,.01),1:$$VAL^XBDIQ1(9000026,Y,.01))
 I 'P Q ""
EXPND ; -- expand code
 Q
 ;
