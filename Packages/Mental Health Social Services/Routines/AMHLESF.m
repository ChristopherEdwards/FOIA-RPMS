AMHLESF ; IHS/CMI/LAB - SUICIDE FORM UPDATE ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1,2**;JUN 18, 2010;Build 23
 ;
 ;
START ;
 D EN^XBVK("AMH")
 W:$D(IOF) @IOF
 W $$CTR("Update Suicide Forms",80)
GETPAT ;
 S (AMHPAT,DFN)=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 D EOJ Q
 I '$$ALLOWP^AMHUTIL(DUZ,DFN) D NALLOWP^AMHUTIL S DFN="" G GETPAT
 S (DFN,AMHPAT)=+Y
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S (DFN,AMHPAT)="" D EOJ Q
 D EN
END ;
 D EOJ
 K AMHP,AMHQUIT,AMHW
 Q
 ;
EN ;EP -- main entry point
 NEW AMHLEAP
 D EN^VALM("AMH VIEW/UPDATE SUICIDE FORM")
 K AMHCASE,AMHX,AMHD,AMHRCNT,AMHLINE,AMHCDATE,AMHF,AMHLESF,AMHDP,AMHIISFE,AMHRCNT,AMHSF
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Suicide Forms on File for: "_IORVON_$P(^DPT(DFN,0),U)_IOINORM
 S VALMHDR(2)="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2))_"    "_$$VAL^XBDIQ1(2,DFN,.02)_"   DOB: "_$$DOB^AUPNPAT(DFN,"E")
 S VALMHDR(3)="Tribe: "_$E($$TRIBE^AUPNPAT(DFN,"E"),1,25)_"  Community: "_$$COMMRES^AUPNPAT(DFN,"E")
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
INIT ; 
 S VALMSG="?? for more actions  + next screen  - prev screen"
 D GATHER
 S VALMCNT=AMHLINE
 Q
 ;
GATHER ;
 K AMHLESF
 S AMHRCNT=0,AMHLINE=0
 I '$D(^AMHPSUIC("AC",DFN)) S AMHLESF(1,0)="No Suicide Forms currently on file for "_$P(^DPT(DFN,0),U),AMHLESF("IDX",1,1)="" S AMHRCNT=1 Q
 S AMHSD=0 F  S AMHSD=$O(^AMHPSUIC("AA",DFN,AMHSD)) Q:AMHSD'=+AMHSD  S AMHSF=0 F  S AMHSF=$O(^AMHPSUIC("AA",DFN,AMHSD,AMHSF)) Q:AMHSF'=+AMHSF  D
 .S AMHRCNT=AMHRCNT+1
 .S X=AMHRCNT_") Local Case #: "_$P(^AMHPSUIC(AMHSF,0),U,2),$E(X,35)="Computer Case #: "_$P(^AMHPSUIC(AMHSF,0),U)
 .S AMHLINE=AMHLINE+1,AMHLESF(AMHLINE,0)=X,AMHLESF("IDX",AMHLINE,AMHRCNT)=AMHSF
 .S X="   Date of Act: "_$$VAL^XBDIQ1(9002011.65,AMHSF,.06),$E(X,35)="Provider: "_$$VAL^XBDIQ1(9002011.65,AMHSF,.03)
 .S AMHLINE=AMHLINE+1,AMHLESF(AMHLINE,0)=X,AMHLESF("IDX",AMHLINE,AMHRCNT)=AMHSF
 .S X="   Suicidal Behavior: "_$$VAL^XBDIQ1(9002011.65,AMHSF,.131),AMHLINE=AMHLINE+1,AMHLESF(AMHLINE,0)=X,AMHLESF("IDX",AMHLINE,AMHRCNT)=AMHSF
 .S Y="",Z=0 F  S Z=$O(^AMHPSUIC(AMHSF,11,Z)) Q:Z'=+Z  S Y=Y_$$EXTSET^XBFUNC(9002011.6511,.01,$P(^AMHPSUIC(AMHSF,11,Z,0),U))_"  "
 .S X="   Method: "_Y,AMHLINE=AMHLINE+1,AMHLESF(AMHLINE,0)=X,AMHLESF("IDX",AMHLINE,AMHRCNT)=AMHSF
 .I $$INCOMPSF(AMHSF) S X="   "_IORVON_"[Incomplete Form]"_IOINORM,AMHLINE=AMHLINE+1,AMHLESF(AMHLINE,0)=X,AMHLESF("IDX",AMHLINE,AMHRCNT)=AMHSF
 Q
EDIT ;EP
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S AMHSF=0,(X,Y)=0 F  S X=$O(AMHLESF("IDX",X)) Q:X'=+X!(AMHSF)  I $O(AMHLESF("IDX",X,0))=R S Y=$O(AMHLESF("IDX",X,0)),AMHSF=AMHLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DA=AMHSF,DIE="^AMHPSUIC(",DR=".21////"_DT_";.22////"_DUZ_";.27////"_$$NOW^XLFDT D ^DIE
 D ADDDS
 D EXIT
 Q
DISP ;EP
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S AMHSF=0,(X,Y)=0 F  S X=$O(AMHLESF("IDX",X)) Q:X'=+X!(AMHSF)  I $O(AMHLESF("IDX",X,0))=R S Y=$O(AMHLESF("IDX",X,0)),AMHSF=AMHLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 D EP^AMHLESF1(AMHSF)
 D EXIT
 Q
DEL ;EP - called from protocol
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Suicide Form.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT Q
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." G EXIT
 S AMHSF=0,(X,Y)=0 F  S X=$O(AMHLESF("IDX",X)) Q:X'=+X!(AMHSF)  I $O(AMHLESF("IDX",X,0))=R S Y=$O(AMHLESF("IDX",X,0)),AMHSF=AMHLESF("IDX",X,Y)
 I '$D(^AMHPSUIC(AMHSF,0)) W !,"Not a valid SUICIDE RECORD." K AMHRDEL,R,AMHSF,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this suicide form",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 S DA=AMHSF,DIK="^AMHPSUIC(" D ^DIK
 D EXIT
 Q
BV ;
 NEW AMHPAT
 D EP^AMHVD(DFN)
 D EXIT
 Q
HS ;EP
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
ADDSF(AMHPAT) ;EP
 D FULL^VALM1
 W:$D(IOF) @IOF
PROV ;
 D ^XBFMK
 S AMHDP=""
 W !! S DIC("A")="Provider Completing the Form: ",DIC="^VA(200,",DIC(0)="AEMQ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Provider Selected." D EXIT Q
 S AMHPROV=+Y
GETDATE ;EP 
 W !!
 S AMHDATE="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter the DATE of the SUICIDE ACT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT G PROV
 S AMHDATE=Y
 S X=0,G=0,Y=0,Q=0 F  S X=$O(^AMHPSUIC("AC",DFN,X)) Q:X'=+X!(G)  I $P(^AMHPSUIC(X,0),U,6)=AMHDATE D
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
ADDDS ;
 S AMHIISFE=1
 S DA=AMHSF,DDSFILE=9002011.65,DR="[AMH SUICIDE FORM UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG D PAUSE,EXIT Q
 D CHECK
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
CHECK ; check record for completeness
 S AMHC=0
 F AMHF=.03:.01:.08 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" W !,$P(^DD(9002011.65,AMHF,0),U)," is a required data element." S AMHC=1
 F AMHF=.11,.13:.01:.15,.25 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" W !,$P(^DD(9002011.65,AMHF,0),U)," is a required data element." S AMHC=1
 I $$VAL^XBDIQ1(9002011.65,AMHSF,.25)="OTHER",$$VAL^XBDIQ1(9002011.65,AMHSF,1402)="" S AMHC=1 W !,"Location of Act is OTHER, OTHER description is required."
 I $$VAL^XBDIQ1(9002011.65,AMHSF,.25)'="OTHER",$$VAL^XBDIQ1(9002011.65,AMHSF,1402)]"" S DA=AMHSF,DIE="^AMHPSUIC(",DR="1402///@" D ^DIE K DA,DIE,DR
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(AMHSF,11,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,11,X,0)),U)]"" S G=1
 .I $P($G(^AMHPSUIC(AMHSF,11,X,0)),U)=8,$P(^AMHPSUIC(AMHSF,11,X,0),U,2)="" W !,"One of the Methods is OTHER.  OTHER description is Required." S AMHC=1
 .I $P(^AMHPSUIC(AMHSF,11,X,0),U,1)'=7 K ^AMHPSUIC(AMHSF,11,X,11)
 .I $P(^AMHPSUIC(AMHSF,11,X,0),U,1)=7 D
 ..S Y=0 F  S Y=$O(^AMHPSUIC(AMHSF,11,X,11,Y)) Q:Y'=+Y  D
 ...S D=$P(^AMHPSUIC(AMHSF,11,X,11,Y,0),U,1)
 ...I $P(^AMHTSDRG(D,0),U,2),$P(^AMHPSUIC(AMHSF,11,X,11,Y,0),U,2)="" S AMHC=1 W !,"Method is Overdose, Drug type is Other, Other description is required."
 .Q
 I 'G W !!,"You must enter a METHOD." S AMHC=1
 S G=$P(^AMHPSUIC(AMHSF,0),U,26)
 I G="" W !!,"You must enter a value for SUBSTANCE Use.  None or Unknown are valid values." S AMHC=1
 I G=2 D
 .S X=0 F  S X=$O(^AMHPSUIC(AMHSF,15,X)) Q:X'=+X  D
 ..S D=$P(^AMHPSUIC(AMHSF,15,X,0),U,1)
 ..I $P(^AMHTSSU(D,0),U,2),$P(^AMHPSUIC(AMHSF,15,X,0),U,2)="" S AMHC=1 W !,"Substance Involved is Alcohol/Drugs, Drug is Other, Other Description is Required."
 S (Z,G,X)=0 F  S X=$O(^AMHPSUIC(AMHSF,13,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,13,X,0)),U)]"" S G=1
 .S D=$P(^AMHPSUIC(AMHSF,13,X,0),U,1)
 .I $P(^AMHTSCF(D,0),U,1)="OTHER",$P(^AMHPSUIC(AMHSF,13,X,0),U,2)="" S AMHC=1 W !,"Contributing Factor is OTHER, OTHER description is required."
 .Q
 ;NOW CHECK FOR OTHER
 I 'G W !!,"You must enter a CONTRIBUTING FACTOR.  Unknown is a valid value." S AMHC=1
 I $P(^AMHPSUIC(AMHSF,0),U,15)=7,$$VAL^XBDIQ1(9002011.65,AMHSF,1401)="" S AMHC=1 W !,"Location of Act is OTHER, OTHER description is required."
 I $P(^AMHPSUIC(AMHSF,0),U,15)'=7,$$VAL^XBDIQ1(9002011.65,AMHSF,1401)]"" S DIE="^AMHPSUIC(",DA=AMHSF,DR="1401///@" D ^DIE K DA,DIE,DR
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
 K X,Y,Z,I
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
AV ;EP add visit
 D FULL^VALM1
 D GETPAT^AMHLEA
 I 'AMHPAT W !,"NO Patient selected!",! D PAUSE^AMHLEA D EXIT Q
 S DFN=AMHPAT
 S AMHDPEEP=AMHPROV
 D CONTACT^AMHLEP1(AMHPAT,1)
 S AMHPROV=AMHDPEEP
 D PAUSE^AMHLEA
 D EXIT
 Q
METHOD(VAL) ;
 NEW DDH
 I $G(VAL)="" Q 1
 I '$G(AMHIISFE) Q 1
 I '$G(AMHSF) Q 1
 NEW AMHG,AMHX,AMHDA
 S AMHG=0
 I '$O(^AMHPSUIC(AMHSF,11,0)) Q 1
 S AMHDA=0 F  S AMHDA=$O(^AMHPSUIC(AMHSF,11,AMHDA)) Q:AMHDA'=+AMHDA  S AMHY=$P(^AMHPSUIC(AMHSF,11,AMHDA,0),U) I AMHY'="U" S AMHG=1
 I VAL="U",AMHG D  Q 0
 .NEW A K A
 .S A(1)="You cannot enter UNKNOWN if other legitimate values have already been entered.",A(1,"F")="!"
 .S A(2)="If you want to enter UNKNOWN you must first delete (using the '@') all other entries."
 .D EN^DDIOL(.A)
 .K A
 .Q
 S AMHG=0
 S AMHDA=0 F  S AMHDA=$O(^AMHPSUIC(AMHSF,11,AMHDA)) Q:AMHDA'=+AMHDA  S AMHY=$P(^AMHPSUIC(AMHSF,11,AMHDA,0),U) I AMHY="U" S AMHG=1
 I VAL'="U",AMHG D  Q 0
 .NEW A K A
 .S A(1)="You have already entered UNKNOWN as a value.  If you want to enter",A(1,"F")="!"
 .S A(2)="another method you must first delete (using the '@') the UNKNOWN entry."
 .D EN^DDIOL(.A)
 .K A
 .Q
 Q 1
PS(VAL) ;
 I $G(VAL)="" Q 1
 I '$G(AMHIISFE) Q 1
 I '$G(AMHSF) Q 1
 NEW AMHG,AMHX,AMHDA
 S AMHG=0
 S AMHX=$P(^AMHTSCF(VAL,0),U)
 I '$O(^AMHPSUIC(AMHSF,13,0)) Q 1
 S AMHDA=0 F  S AMHDA=$O(^AMHPSUIC(AMHSF,13,AMHDA)) Q:AMHDA'=+AMHDA  S AMHY=$P(^AMHPSUIC(AMHSF,13,AMHDA,0),U) S AMHY=$P(^AMHTSCF(AMHY,0),U) I AMHY'="UNKNOWN" S AMHG=1
 I AMHX="UNKNOWN",AMHG D  Q 0
 .NEW A K A
 .S A(1)="You cannot enter UNKNOWN if other legitimate values have already been entered.",A(1,"F")="!"
 .S A(2)="If you want to enter UNKNOWN you must first delete (using the '@') all other entries."
 .D EN^DDIOL(.A)
 .K A
 .Q
 S AMHG=0
 S AMHDA=0 F  S AMHDA=$O(^AMHPSUIC(AMHSF,13,AMHDA)) Q:AMHDA'=+AMHDA  S AMHY=$P(^AMHPSUIC(AMHSF,13,AMHDA,0),U) S AMHY=$P(^AMHTSCF(AMHY,0),U) I AMHY="UNKNOWN" S AMHG=1
 I AMHX'="UNKNOWN",AMHG D  Q 0
 .NEW A K A
 .S A(1)="You have already entered UNKNOWN as a value.  If you want to enter",A(1,"F")="!"
 .S A(2)="another factor you must first delete (using the '@') the UNKNOWN entry."
 .D EN^DDIOL(.A)
 .K A
 .Q
 Q 1
UPDATE(V,P,E) ;EP - called from xref
 I $G(V)="" Q
 I $G(P)="" Q
 I $G(E)="" Q
 I '$D(^AMHPSUIC(E)) Q
 I '$D(^AMHPSUIC(E,51,0)) S ^AMHPSUIC(E,51,0)="^9002011.6551DA^0^0"
 NEW C,Z,N,G
 ;if this user has been logged in the past hour don't file
 S (G,Z)=0 F  S Z=$O(^AMHPSUIC(E,51,Z)) Q:Z'=+Z  D
 .S C=$P(^AMHPSUIC(E,51,Z,0),U),N=$P(^AMHPSUIC(E,51,Z,0),U,2)
 .Q:N'=P
 .I $$FMDIFF^XLFDT(V,C,2)<3600 S G=1
 I G Q
 S C=0,Z=0 F  S Z=$O(^AMHPSUIC(E,51,Z)) Q:Z'=+Z  S C=Z
 S N=C+1
 S ^AMHPSUIC(E,51,N,0)=V_"^"_P
 S ^AMHPSUIC(E,51,"B",V,N)=""
 S C=0,Z=0 F  S Z=$O(^AMHPSUIC(E,51,Z)) Q:Z'=+Z  S C=C+1
 S $P(^AMHPSUIC(E,51,0),U,3)=N
 S $P(^AMHPSUIC(E,51,0),U,4)=C
 Q
INCOMPSF(AMHSF) ;EP -  check record for completeness 
 NEW AMHC,G,AMHF,Z,X
 S AMHC=0
 S G=0 F AMHF=.03:.01:.08 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" S G=1
 I G Q G
 S G=0 F AMHF=.11,.13:.01:.15,.25 I $$VAL^XBDIQ1(9002011.65,AMHSF,AMHF)="" S G=1
 I G Q G
 I $P(^AMHPSUIC(AMHSF,0),U,15)=7,$$VAL^XBDIQ1(9002011.65,AMHSF,1401)="" S G=1
 I G Q G
 I $$VAL^XBDIQ1(9002011.65,AMHSF,.25)="OTHER",$$VAL^XBDIQ1(9002011.65,AMHSF,1402)="" S G=1
 I G Q G
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(AMHSF,11,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,11,X,0)),U)]"" S G=1
 .I $P(^AMHPSUIC(AMHSF,11,X,0),U,1)'=7 K ^AMHPSUIC(AMHSF,11,X,11)
 .Q
 I 'G Q 1
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(AMHSF,11,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,11,X,0)),U)=8,$P(^AMHPSUIC(AMHSF,11,X,0),U,2)="" S G=1
 .Q
 I G Q G
 S (Z,X,G)=0 F  S X=$O(^AMHPSUIC(AMHSF,11,X)) Q:X'=+X  D
 .I $P(^AMHPSUIC(AMHSF,11,X,0),U,1)=7 D
 ..S Y=0 F  S Y=$O(^AMHPSUIC(AMHSF,11,X,11,Y)) Q:Y'=+Y  D
 ...S D=$P(^AMHPSUIC(AMHSF,11,X,11,Y,0),U,1)
 ...I $P(^AMHTSDRG(D,0),U,2),$P(^AMHPSUIC(AMHSF,11,X,11,Y,0),U,2)="" S G=1
 .Q
 I G Q G
 S G=$P(^AMHPSUIC(AMHSF,0),U,26)
 I G="" Q 1
 I G'=2 S G=0
 I G=2 D
 .S X=0,D=0,G=0 F  S X=$O(^AMHPSUIC(AMHSF,15,X)) Q:X'=+X  D
 ..S D=$P(^AMHPSUIC(AMHSF,15,X,0),U,1)
 ..I $P(^AMHTSSU(D,0),U,2),$P(^AMHPSUIC(AMHSF,15,X,0),U,2)="" S G=1
 I G Q G
 S (Z,G,X)=0 F  S X=$O(^AMHPSUIC(AMHSF,13,X)) Q:X'=+X  D
 .I $P($G(^AMHPSUIC(AMHSF,13,X,0)),U)]"" S G=1
 .Q
 I 'G Q 1
 S (Z,G,X)=0 F  S X=$O(^AMHPSUIC(AMHSF,13,X)) Q:X'=+X  D
 .S D=$P(^AMHPSUIC(AMHSF,13,X,0),U,1)
 .I $P(^AMHTSCF(D,0),U,1)="OTHER",$P(^AMHPSUIC(AMHSF,13,X,0),U,2)="" S G=1
 I G Q G
 Q 0
