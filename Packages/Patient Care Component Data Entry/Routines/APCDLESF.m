APCDLESF ; IHS/CMI/LAB - SUICIDE FORM UPDATE ;
 ;;2.0;IHS PCC SUITE;**2,7**;MAY 14, 2009
 ;
 ;
START ;
 D EN^XBVK("APCD")
 W:$D(IOF) @IOF
 W $$CTR("Update Suicide Forms",80)
GETPAT ;
 S (APCDPAT,DFN)=""
 I '$P($G(^APCDSITE(DUZ(2),0)),U,34) S AUPNLK("INAC")=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y<0 G END
 W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S (DFN,APCDPAT)=+Y
 D INAC^APCDEA(APCDPAT,.X) I 'X S APCDPAT="" G GETPAT
 D EN
END ;
 D EOJ
 K APCDP,APCDQUIT,APCDW
 Q
 ;
EN ; --
 NEW APCDLEAP
 D EN^VALM("APCD SUICIDE VIEW/UPDATE")
 K APCDCASE,APCDX,APCDD,APCDRCNT,APCDLINE,APCDDATE
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Suicide Reporting Forms on File for: "_IORVON_$P(^DPT(DFN,0),U)_IOINORM
 S VALMHDR(2)="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2))_"    "_$$VAL^XBDIQ1(2,DFN,.02)_"   DOB: "_$$DOB^AUPNPAT(DFN,"E")
 S VALMHDR(3)="Tribe: "_$E($$TRIBE^AUPNPAT(DFN,"E"),1,25)_"  Community: "_$$COMMRES^AUPNPAT(DFN,"E")
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
INIT ; -- init variables and list array
 S VALMSG="?? for more actions  + next screen  - prev screen"
 D GATHER ;gather up all records for display
 S VALMCNT=APCDLINE
 Q
 ;
GATHER ;
 K APCDLESF
 S APCDRCNT=0,APCDLINE=0
 I '$D(^AMHPSUIC("AC",DFN)) S APCDLESF(1,0)="No Suicide Forms currently on file for "_$P(^DPT(DFN,0),U),APCDLESF("IDX",1,1)="" S APCDRCNT=1 Q
 S APCDSF=0 F  S APCDSF=$O(^AMHPSUIC("AC",DFN,APCDSF)) Q:APCDSF'=+APCDSF  D
 .S APCDRCNT=APCDRCNT+1
 .S X=APCDRCNT_") Local Case #: "_$P(^AMHPSUIC(APCDSF,0),U,2),$E(X,35)="Computer Generated Case #: "_$P(^AMHPSUIC(APCDSF,0),U)
 .S APCDLINE=APCDLINE+1,APCDLESF(APCDLINE,0)=X,APCDLESF("IDX",APCDLINE,APCDRCNT)=APCDSF
 .S X="   Date of Act: "_$$VAL^XBDIQ1(9002011.65,APCDSF,.06),$E(X,35)="Provider: "_$$VAL^XBDIQ1(9002011.65,APCDSF,.03)
 .S APCDLINE=APCDLINE+1,APCDLESF(APCDLINE,0)=X,APCDLESF("IDX",APCDLINE,APCDRCNT)=APCDSF
 .S X="   Self Destructive Act: "_$$VAL^XBDIQ1(9002011.65,APCDSF,.13),APCDLINE=APCDLINE+1,APCDLESF(APCDLINE,0)=X,APCDLESF("IDX",APCDLINE,APCDRCNT)=APCDSF
 .S Y="",Z=0 F  S Z=$O(^AMHPSUIC(APCDSF,11,Z)) Q:Z'=+Z  S Y=Y_$$EXTSET^XBFUNC(9002011.6511,.01,$P(^AMHPSUIC(APCDSF,11,Z,0),U))_"  "
 .S X="   Method: "_Y,APCDLINE=APCDLINE+1,APCDLESF(APCDLINE,0)=X,APCDLESF("IDX",APCDLINE,APCDRCNT)=APCDSF
 Q
EDIT ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S APCDSF=0,(X,Y)=0 F  S X=$O(APCDLESF("IDX",X)) Q:X'=+X!(APCDSF)  I $O(APCDLESF("IDX",X,0))=R S Y=$O(APCDLESF("IDX",X,0)),APCDSF=APCDLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(APCDSF,0)) W !,"Not a valid SUICIDE RECORD." K APCDRDEL,R,APCDSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DA=APCDSF,DIE="^AMHPSUIC(",DR=".21////"_DT_";.22////"_DUZ D ^DIE
 D ADDDS
 D EXIT
 Q
DISP ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S APCDSF=0,(X,Y)=0 F  S X=$O(APCDLESF("IDX",X)) Q:X'=+X!(APCDSF)  I $O(APCDLESF("IDX",X,0))=R S Y=$O(APCDLESF("IDX",X,0)),APCDSF=APCDLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(APCDSF,0)) W !,"Not a valid SUICIDE RECORD." K APCDRDEL,R,APCDSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 ;NEW DFN,APCDPAT
 D EP^APCDLES1(APCDSF)
 D EXIT
 Q
DEL ;EP - called from protocol
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("APCDZ SUICIDE FORM DELETE",DUZ)) W !!,"You do not have the security access to delete a Suicide Form.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT Q
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S APCDSF=0,(X,Y)=0 F  S X=$O(APCDLESF("IDX",X)) Q:X'=+X!(APCDSF)  I $O(APCDLESF("IDX",X,0))=R S Y=$O(APCDLESF("IDX",X,0)),APCDSF=APCDLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(APCDSF,0)) W !,"Not a valid SUICIDE RECORD." K APCDRDEL,R,APCDSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 S DA=APCDSF,DIK="^AMHPSUIC(" D ^DIK
 D EXIT
 Q
HS ;EP called from protocol to generate hs
 D FULL^VALM1
 S Y=DFN D ^AUPNPAT
 D GETTYPE
 I '$G(APCHSTYP) D EN^XBVK("APCH") Q
 S APCHSPAT=DFN
 S %="PCC Health Summary for "_$P(^DPT(APCHSPAT,0),U)
 NEW DFN,APCDPAT D VIEWR^XBLM("EN^APCHS",%)
 D EN^XBVK("APCH") K AMCHDAYS,AMCHDOB,%
 D EXIT
 Q
GETTYPE ;
 S APCHSTYP=""
 K DIC S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC K DIC
 Q:Y=-1
 S APCHSTYP=+Y
 Q
ADDSF(APCDPAT) ;EP called from protocol to add a new form
 D FULL^VALM1
 W:$D(IOF) @IOF
PROV ;
 D ^XBFMK
 S APCDDP=""
 W !! S DIC("A")="Provider Completing the Form: ",DIC="^VA(200,",DIC(0)="AEMQ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Provider Selected." D EXIT Q
 S APCDPROV=+Y
GETDATE ;EP - GET DATE OF ENCOUNTER
 W !!
 S APCDDATE="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter the DATE of the SUICIDE ACT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT G PROV
 S APCDDATE=Y
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHPSUIC(",DLAYGO=9002011.65,DIADD=1,X=$$UPI(APCDPAT,APCDDATE),DIC("DR")=".06////"_APCDDATE_";.04////"_APCDPAT_";.03////"_APCDPROV_";.18////"_DT_";.19////"_DUZ_";.21////"_DT_";.22////"_DUZ
 S DIC("DR")=DIC("DR")_";9901///1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Error creating Suicide form!! Deleting form.",! D PAUSE,EXIT Q
 S APCDSF=+Y
 D ADDDS
 D EXIT
 Q
ADDDS ;screenman call
 S AMHIISFE=1,AMHSF=APCDSF  ;NEED BH VARIABLES TO USE THAT SCREENMAN SCREEN
 S DA=APCDSF,DDSFILE=9002011.65,DR="[APCD SUICIDE FORM UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S APCDQUIT=1 K DIMSG D PAUSE,EXIT Q
 D CHECK
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
CHECK ; check record for completeness
 S APCDC=0
 F APCDF=.03:.01:.08 I $$VAL^XBDIQ1(9002011.65,APCDSF,APCDF)="" W !,$P(^DD(9002011.65,APCDF,0),U)," is a required data element." S APCDC=1
 F APCDF=.11,.13:.01:.15,.25 I $$VAL^XBDIQ1(9002011.65,APCDSF,APCDF)="" W !,$P(^DD(9002011.65,APCDF,0),U)," is a required data element." S APCDC=1
 ;I $P(^AMHPSUIC(APCDSF,0),U,16)="",$P(^AMHPSUIC(APCDSF,0),U,17)="" W !,"INTERVENTION is a required data element." S APCDC=1
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(APCDSF,11,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(APCDSF,11,X,0)),U)]"" S G=1
 .I $P(^AMHPSUIC(APCDSF,11,X,0),U,1)'=7 K ^AMHPSUIC(APCDSF,11,X,11)
 .Q
 I 'G W !!,"You must enter a METHOD." S APCDC=1
 S G=$P(^AMHPSUIC(APCDSF,0),U,26)
 I G="" W !!,"You must enter a value for SUBSTANCE Use.  None or Unknown are valid values." S APCDC=1
 S (Z,G,X)=0 F  S X=$O(^AMHPSUIC(APCDSF,13,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(APCDSF,13,X,0)),U)]"" S G=1
 .Q
 I 'G W !!,"You must enter a CONTRIBUTING FACTOR.  Unknown is a valid value." S APCDC=1
 I APCDC W !!,"One or more required data elements are missing.",!! D  G:Y="E" ADDDS G:Y="L" EXIT W !,"Deleting form..." S DA=APCDSF,DIK="^AMHPSUIC(" D ^DIK D PAUSE
 .S DIR(0)="S^E:Edit and Complete the Form;D:Delete the Incomplete Form;L:Leave the Incomplete Form as is and Finish it Later",DIR("A")="What do you want to do",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="L"
 .Q
EXIT ; -- exit code
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=APCDLINE
 D HDR
 K X,Y,Z,I
 D EN^XBVK("AMH")
 Q
EOJ ;
 D EN^XBVK("APCD"),EN^XBVK("AMH"),EN^XBVK("APCH"),EN^XBVK("AMQQ")
 K DFN
 K DDSFILE,DIPGM,Y
 K X,Y,%,DR,DDS,DA,DIC
 D:$D(VALMWD) CLEAR^VALM1
 K VALM,VALMHDR,VALMKEY,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMLST,VALMVAR,VALMLFT,VALMBCK,VALMCC,VALMAR,VALMBG,VALMCAP,VALMCOFF,VALMCNT,VALMCON,BALMON,VALMEVL,VALMIOXY
 D KILL^AUPNPAT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
UPI(P,D) ;
 I '$G(P) Q ""
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 Q $P(^AUTTSITE(1,1),U,3)_$E(D,4,5)_$E(D,6,7)_(1700+$E(D,1,3))_$E("0000000000",1,10-$L(P))_P
 ;
