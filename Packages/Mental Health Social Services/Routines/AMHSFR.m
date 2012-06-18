AMHSFR ; IHS/CMI/LAB - REVIEW SF BY DATE 28 Apr 2009 10:46 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W $$CTR("Review/Update Suicide Forms by Date",80)
 D DONE
 ;
D ;date range
 K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Suicide form date"
 D ^DIR S:Y<1 AMHQUIT=1 Q:Y<1  S AMHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Suicide form date"
 D ^DIR S:Y<1 AMHQUIT=1 Q:Y<1  S AMHED=Y
 ;
 I AMHED<AMHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G D
 D EN,FULL^VALM1,EXIT
 Q
DONE ;
 D EN^XBVK("AMH")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
EN ;
 K AMHSFR
 D GATHER
 D EN^VALM("AMH SF BY DATE")
 D CLEAR^VALM1
 Q
GATHER ;
 K AMHSFR
 S AMHLINE=0
 S AMHSD=$$FMADD^XLFDT(AMHED,1),AMHSD=9999999-AMHSD
 F  S AMHSD=$O(^AMHPSUIC("AB",AMHSD)) Q:AMHSD'=+AMHSD!(AMHSD>(9999999-AMHBD))  D
 .S AMHX=0 F  S AMHX=$O(^AMHPSUIC("AB",AMHSD,AMHX)) Q:AMHX'=+AMHX  D
 ..S DFN=$P(^AMHPSUIC(AMHX,0),U,4),AMHDOB=$P(^DPT(DFN,0),U,3)
 ..Q:'$$ALLOW(DUZ,AMHX)
 ..Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 ..S AMHD=$P(^AMHPSUIC(AMHX,0),U,6)
 ..S AMHLINE=AMHLINE+1,X=AMHLINE_")",$E(X,$S($L(AMHLINE)<3:5,1:6))=$S($$INCOMPSF^AMHLESF(AMHX):"I",1:"")
 ..S $E(X,8)=$E(AMHD,4,5)_"/"_$E(AMHD,6,7)_"/"_$E(AMHD,2,3),$E(X,17)=$E($P(^DPT(DFN,0),U),1,19),$E(X,37)=$$HRN^AUPNPAT(DFN,DUZ(2)),$E(X,44)=$E(AMHDOB,4,5)_"/"_$E(AMHDOB,6,7)_"/"_$E(AMHDOB,2,3)
 ..S $E(X,53)=$E($$VAL^XBDIQ1(9002011.65,AMHX,.131),1,20),$E(X,74)=$$VAL^XBDIQ1(9002011.65,AMHX,.031)
 ..S $E(X,78)=$$VAL^XBDIQ1(9002011.65,AMHX,.02),$E(X,96)=$$VAL^XBDIQ1(9002011.65,AMHX,.01)
 ..S AMHSFR(AMHLINE,0)=X,AMHSFR("IDX",AMHLINE,AMHLINE)=AMHX
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HDR ; -- header code
 S VALMHDR(1)="Suicide Form Review: "_$$FMTE^XLFDT(AMHBD)_" - "_$$FMTE^XLFDT(AMHED)
 S VALMHDR(2)="I = Incomplete Form"
 S X="",$E(X,8)="Date",$E(X,53)="" S VALMHDR(3)=X
 S X="",X="No.",$E(X,8)="of Act",$E(X,17)="Patient",$E(X,37)="HRN",$E(X,44)="DOB",$E(X,53)="Suicidal Behavior",$E(X,74)="PRV",$E(X,78)="Local Case #",$E(X,96)="Case #",VALMHDR(4)=X
 Q
 ;
INIT ; -- init variables and list array
 D GATHER
 S VALMCNT=AMHLINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXPND ; -- expand code
 Q
EDIT ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHSF=0 S AMHSF=AMHSFR("IDX",R,R)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
DGSECE ;
 I '$P(^AMHPSUIC(AMHSF,0),U,4) G EDITR9
 S AMHPAT=$P(^AMHPSUIC(AMHSF,0),U,4)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,0)
 I '$G(AMHRESU(1)) G EDITR9
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to edit this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
EDITR9 ;
 S DA=AMHSF,DIE="^AMHPSUIC(",DR=".21////"_DT_";.22////"_DUZ_";.27////"_$$NOW^XLFDT D ^DIE
 S (AMHPAT,DFN)=$P(^AMHPSUIC(AMHSF,0),U,4)
 D ADDDS
 D EXIT
 Q
DISP ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHSF=0 S AMHSF=AMHSFR("IDX",R,R)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
DGSECD ;
 I '$P(^AMHPSUIC(AMHSF,0),U,4) G EDITD9
 S AMHPAT=$P(^AMHPSUIC(AMHSF,0),U,4)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,0)
 I '$G(AMHRESU(1)) G EDITD9
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to display this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
EDITD9 ;
 ;NEW DFN,AMHPAT
 D EP^AMHLESF1(AMHSF)
 D EXIT
 Q
DEL ;EP - called from protocol
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Suicide Form.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT Q
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHSF=0 S AMHSF=AMHSFR("IDX",R,R)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
DGSECX ;
 I '$P(^AMHPSUIC(AMHSF,0),U,4) G EDITX9
 S AMHPAT=$P(^AMHPSUIC(AMHSF,0),U,4)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,0)
 I '$G(AMHRESU(1)) G EDITX9
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to delete this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
EDITX9 ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 S DA=AMHSF,DIK="^AMHPSUIC(" D ^DIK
 D EXIT
 Q
BV ;
 ;S DFN=AMHPAT
 NEW AMHPAT
 D EP^AMHVD(DFN)
 D EXIT
 Q
HS ;EP called from protocol to generate hs
 D FULL^VALM1
 S Y=DFN D ^AUPNPAT
 D GETTYPE
 I '$G(APCHSTYP) D EN^XBVK("APCH") Q
 S APCHSPAT=DFN
 S %="PCC Health Summary for "_$P(^DPT(APCHSPAT,0),U)
 NEW DFN,AMHPAT D VIEWR^XBLM("EN^APCHS",%)
 D EN^XBVK("APCH") K AMCHDAYS,AMCHDOB,%
 D EXIT
 Q
GETTYPE ;
 I $G(^AMHSITE(DUZ(2),0))="" D DEFAULT Q
 S APCHSTYP=$P(^AMHSITE(DUZ(2),0),U,4) I APCHSTYP="" D DEFAULT Q
 I '$D(^APCHSCTL(APCHSTYP)) W !,"Error in Site Parameter File!",$C(7),$C(7) S APCHSTYP="" Q
 Q
DEFAULT ;
 S APCHSTYP=""
 S X="BEHAVIORAL HEALTH",DIC(0)="",DIC="^APCHSCTL(" D ^DIC K DIC,DA
 I Y=-1 W !!,"PCC MENTAL HEALTH HEALTH SUMMARY TYPE IS MISSING!!  NOTIFY YOUR SUPERVISOR OR SITE MANAGER.",!! Q
 S APCHSTYP=+Y
 Q
ADD ;EP
 D FULL^VALM1
 S AMHPAT=""
 D GETPAT^AMHLEA
 I 'AMHPAT W !!,"No patient entered..." D EXIT Q
 S Y=AMHPAT D ^AUPNPAT
 S DFN=AMHPAT
 D ADDSF(AMHPAT)
 D CLEAR^VALM1
 D EXIT
 Q
ADDSF(AMHPAT) ;EP called from protocol to add a new form
 D FULL^VALM1
 W:$D(IOF) @IOF
PROV ;
 D ^XBFMK
 S AMHDP=""
 W !! S DIC("A")="Provider Completing the Form: ",DIC="^VA(200,",DIC(0)="AEMQ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Provider Selected." D EXIT Q
 S AMHPROV=+Y
GETDATE ;EP - GET DATE OF ENCOUNTER
 W !!
 S AMHDATE="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter the DATE of the SUICIDE ACT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT G PROV
 S AMHDATE=Y
 S X=0,G=0,Y=0 F  S X=$O(^AMHPSUIC("AC",AMHPAT,X)) Q:X'=+X!(G)  I $P(^AMHPSUIC(X,0),U,6)=AMHDATE D
 .S Y=1 W !!,"This patient already has a suicide form on file for this Date of Act."
 .W !,"The form was filled out by:   ",$$VAL^XBDIQ1(9002011.65,X,.03),!
 .S DIR(0)="S^A:Continue to ADD a new form;Q:Quit - do not add a new form",DIR("A")="Do you wish to",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="Q" Q
 .I Y="Q" Q
 .S G=1
 I Y="Q" D PAUSE,EXIT Q
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHPSUIC(",DLAYGO=9002011.65,DIADD=1,X=$$UPI(AMHPAT,AMHDATE)
 S DIC("DR")=".06////"_AMHDATE_";.04////"_AMHPAT_";.03////"_AMHPROV_";.18////"_DT_";.19////"_DUZ_";.21////"_DT_";.22////"_DUZ_";.27////"_$$NOW^XLFDT
 S DIC("DR")=DIC("DR")_";9901///1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Error creating Suicide form!! Deleting form.",! D PAUSE,EXIT Q
 S AMHSF=+Y
 D ADDDS
 D EXIT
 Q
ADDDS ;screenman call
 S AMHIISFE=1
 S DA=AMHSF,DDSFILE=9002011.65,DR="[AMH SUICIDE FORM UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG D PAUSE,EXIT Q
 D CHECK
 Q
 ;
CHECK ; check record for completeness
 S AMHC=0
 F AMHF=.03:.01:.08 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" W !,$P(^DD(9002011.65,AMHF,0),U)," is a required data element." S AMHC=1
 F AMHF=.11,.13:.01:.15,.25 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" W !,$P(^DD(9002011.65,AMHF,0),U)," is a required data element." S AMHC=1
 ;I $P(^AMHPSUIC(AMHSF,0),U,16)="",$P(^AMHPSUIC(AMHSF,0),U,17)="" W !,"INTERVENTION is a required data element." S AMHC=1
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(AMHSF,11,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,11,X,0)),U)]"" S G=1
 .I $P(^AMHPSUIC(AMHSF,11,X,0),U,1)'=7 K ^AMHPSUIC(AMHSF,11,X,11)
 .Q
 I 'G W !!,"You must enter a METHOD." S AMHC=1
 S G=$P(^AMHPSUIC(AMHSF,0),U,26)
 I G="" W !!,"You must enter a value for SUBSTANCE Use.  None and Unknown are valid values." S AMHC=1
 S (Z,G,X)=0 F  S X=$O(^AMHPSUIC(AMHSF,13,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,13,X,0)),U)]"" S G=1
 .Q
 I 'G W !!,"You must enter a CONTRIBUTING FACTOR.  Unknown is a valid value." S AMHC=1
 I AMHC W !!,"One or more required data elements are missing.",!! D  G:Y="E" ADDDS G:Y="L" EXIT W !,"Deleting form..." S DA=AMHSF,DIK="^AMHPSUIC(" D ^DIK D PAUSE
 .S DIR(0)="S^E:Edit and Complete the Form;D:Delete the Incomplete Form;L:Leave the Incomplete Form as is and Finish it Later",DIR("A")="What do you want to do",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="L"
 .Q
EXIT ; -- exit code
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=AMHLINE
 D HDR
 K X,Y,Z,I,AMHPAT,DFN,AMHX,AMHLINE,AMHSF,AMHF,AMHC,AMHRESU
 D KILL^AUPNPAT
 Q
EOJ ;
 D EN^XBVK("AMH")
 K DFN
 K DDSFILE,DIPGM,Y
 K X,Y,%,DR,DDS,DA,DIC
 D:$D(VALMWD) CLEAR^VALM1
 K VALM,VALMHDR,VALMKEY,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMLST,VALMVAR,VALMLFT,VALMBCK,VALMCC,VALMAR,VALMBG,VALMCAP,VALMCOFF,VALMCNT,VALMCON,BALMON,VALMEVL,VALMIOXY
 D KILL^AUPNPAT
 Q
 ;
 ;
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
UPI(P,D) ;EP
 I '$G(P) Q ""
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 Q $P(^AUTTSITE(1,1),U,3)_$E(D,4,5)_$E(D,6,7)_(1700+$E(D,1,3))_$E("0000000000",1,10-$L(P))_P
 ;
ALLOW(S,R) ;EP - CAN THIS USER SEE THIS SUICIDE FORM?
 ;S is duz, R is suicide form ien
 Q 1
 I '$G(S) Q 0
 I '$G(R) Q 0
 I '$D(^AMHPSUIC(R,0)) Q 0
 NEW P
 S P=$P($G(^AMHPSUIC(R,0)),U,4)
 I 'P Q 0
 I $D(^AMHSITE(DUZ(2),16,S)) Q $$ALLOWP^AMHUTIL(S,P)  ;allow all with access
 I $P(^AMHPSUIC(R,0),U,3)=S Q $$ALLOWP^AMHUTIL(S,P)   ;allow your own
 Q 0
