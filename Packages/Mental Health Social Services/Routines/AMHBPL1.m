AMHBPL1 ; IHS/CMI/LAB - problem list update from list manager ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
 ;
DIE ;
 S DIE("NO^")=1
 S DA=AMHPIEN,DIE="^AMHPPROB(",DR=AMHTEMP D ^DIE
KDIE ;kill all vars used by DIE
 K DIE,DR,DA,DIU,DIV,DQ,D0,DO,DI,DIW,DIY,%,DQ,DLAYGO
 Q
GETPROB ;EP - get record
 S AMHPIEN=0
 I 'AMHPRCNT W !!,"No problems to select" Q
 S DIR(0)="N^1:"_AMHPRCNT_":0",DIR("A")="Select Problem" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No Problem Selected" Q
 S AMHP=Y
 S (X,Y)=0 F  S X=$O(AMHBHPL("IDX",X)) Q:X'=+X!(AMHPIEN)  I $O(AMHBHPL("IDX",X,0))=AMHP S Y=$O(AMHBHPL("IDX",X,0)),AMHPIEN=AMHBHPL("IDX",X,Y)
 I '$D(^AMHPPROB(AMHPIEN,0)) W !,"Not a valid BEHAVIORAL HEALTH PROBLEM." K AMHP S AMHPIEN=0 Q
 D FULL^VALM1 ;give me full control of screen
 Q
ADD ;EP - called from protocol to add a problem to problem list
 D FULL^VALM1 ; this gives me back all screen control
 W:$D(IOF) @IOF W !!!,"Adding a new BH Problem for ",$P(^DPT(AMHBPLPT,0),U),".",!!
 W "Purpose of Visit Diagnoses assigned to this patient in the past 90 days:",!
 NEW AMHPOVS,X,Y,N,AMHC,AMHOTH,D,P,AMHANS,AMHNUM,AMHTY,AMHNNUM,AMHNIEN,AMHCODE,AMHPOVS1,AMHANS,AMHOTH,AMHAPIEN,AMHNARR
 S AMHC=0
 S X=0 F  S X=$O(^AMHRPRO("AC",AMHPAT,X)) Q:X'=+X  D
 .Q:'$D(^AMHRPRO(X,0))
 .S D=$P(^AMHRPRO(X,0),U,3)
 .S D=$P($P($G(^AMHREC(D,0)),U,1),".")
 .Q:D<$$FMADD^XLFDT(DT,-91)
 .S Y=$$VAL^XBDIQ1(9002011.01,X,.01)
 .S I=$P(^AMHRPRO(X,0),U,1)
 .S N=$$VAL^XBDIQ1(9002012.2,$$VALI^XBDIQ1(9002011.01,X,.01),.02)
 .S P=$$VAL^XBDIQ1(9002011.01,X,.04)
 .S AMHPOVS(Y)=N_U_P_U_Y_U_I
 S Y="" F  S Y=$O(AMHPOVS(Y)) Q:Y=""  D
 .S AMHC=AMHC+1
 .W $$LBLK(AMHC,3),") ",Y,?15,$P(AMHPOVS(Y),U,1),!
 .S AMHPOVS1(AMHC)=AMHPOVS(Y)
 S AMHC=AMHC+1,AMHOTH=AMHC
 W $$LBLK(AMHC,3),") ","Any Other Diagnosis",!
 S DIR(0)="NO^1:"_AMHC_":0",DIR("A")="Choose a Diagnosis",DIR("B")=AMHC KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No diagnosis selected. " D PAUSE,EXIT Q
 S AMHANS=Y
 I AMHANS'=AMHOTH S AMHCODE=$P(AMHPOVS1(AMHANS),U,4) G ADD1
 S AMHCODE=""
 W !!
 S DIR(0)="9002011.01,.01",DIR("A")="Enter Diagnosis to Add to the Problem List" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No diagnosis selected. " D PAUSE,EXIT Q
 S AMHCODE=+Y
ADD1 ;
 K DD,D0,DO,DINUM,DIC,DA,DR,DIADD
 S AMHNUM=0,AMHTY="" F  S AMHTY=$O(^AMHPPROB("AA",AMHPAT,AMHTY)) Q:AMHTY=""  D
 .S AMHNUM=$E(AMHTY,2,4) S AMHNUM=AMHNUM+1
 I AMHNUM=0 S AMHNUM=1
 S AMHNUM=+AMHNUM
 S DIC(0)="EL",DIC="^AMHPPROB(",DLAYGO=9002011.51,DIADD=1,X=AMHCODE
 S DIC("DR")=".02////"_AMHPAT_";.03////"_$$NOW^XLFDT_";.06////"_DUZ(2)_";.07////"_AMHNUM_";.08////"_$$NOW^XLFDT_";.15////"_DUZ
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,"error generating problem entry" D PAUSE,EXIT Q
 S AMHAPIEN=+Y
 S AMHNARR=$P(^AMHPROB(AMHCODE,0),U,2)
 S APCDOVRR=1,AMHOVRR=1
 S DIE("NO^")=1,DIE="^AMHPPROB(",DR=".05//"_AMHNARR,DA=AMHAPIEN D ^DIE D KDIE
STAT ;get status value
 K DIR S DIR(0)="S^A:ACTIVE;I:INACTIVE",DIR("A")="STATUS",DIR("B")="ACTIVE" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is a required response.  " D DELADD G:'AMHDEL STAT S DA=AMHAPIEN,DIK="^AMHPPROB(" D ^DIK K DA,DIK D PAUSE,EXIT Q
 I Y'="I",Y'="A" W !!,"This is a required response, must be A or I, ""^"" to exit and delete the problem." G STAT
 S AMHANS=Y
 S DIE="^AMHPPROB(",DR=".12////"_AMHANS_";.13",DA=AMHAPIEN D ^DIE D KDIE
NO ;
 W !!
 S DIR(0)="Y",DIR("A")="Add TREATMENT Note",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PLUDE^AMHAPRB(AMHAPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I")),EXIT Q
 I 'Y D PLUDE^AMHAPRB(AMHAPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I")),EXIT Q
 S AMHNNUM=$$GETNUM^AMHLETN(AMHAPIEN)
 W !
 S DIC="^AMHPTP(",X=AMHNNUM,DIC("DR")=".02////"_AMHPAT_";.03////"_AMHAPIEN_";.05////"_DT,DIADD=1,DLAYGO=9002011.53,DIC(0)="EL"
 D FILE^DICN
 K DLAYGO,DIADD,DIC,DA
 I Y=-1 W !,"error creating note entry" D PAUSE,EXIT Q
 W !
 S AMHNIEN=+Y
 S DIE="^AMHPTP(",DA=AMHNIEN,DR=".04;.06//^S X=$P(^VA(200,DUZ,0),U);.07" D ^DIE K DIE,DR,DA
 G NO ; D EXIT
 Q
DELADD ;
 S AMHDEL=0
 W !!,"Problem list entry is incomplete, it will be deleted."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this BH Problem",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 I 'Y Q
 S AMHDEL=1
 Q
EDIT ;EP - called from protocol to modify a problem on problem list
 NEW AMHPIEN,AMHTEMP,AMHOLDS,AMHOLDD,AMHNEWC
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 S AMHOLDS=$P(^AMHPPROB(AMHPIEN,0),U,12)
 S AMHOLDD=$P(^AMHPPROB(AMHPIEN,0),U,1)
 S AMHTEMP="[AMH MODIFY PROBLEM]"
 W:$D(IOF) @IOF W !,"Editing Problem ... ",!!
 ;CALL READER FOR .01 AND DO NOT ALLOW @
 S DIR(0)="9002011.51,.01",DIR("A")="Diagnosis",DIR("B")=$P(^AMHPROB(AMHOLDD,0),U,1) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"^ing out...no editing logged." D PAUSE,EXIT Q
 S AMHNEWC=+Y
 I 'AMHNEWC S AMHNEWC=$P(^AMHPPROB(AMHPIEN,0),U,1)
 S DA=AMHPIEN,DIE="^AMHPPROB(",DR=".01////"_AMHNEWC_";.03////"_$$NOW^XLFDT,DIE("NO^")=1 D ^DIE K DA,DIE,DR
 ;D DIE
 ;
 I $P(^AMHPPROB(AMHPIEN,0),U,1)'=AMHOLDD S DIE="^AMHPPROB(",DA=AMHPIEN,DR=".05///"_$P(^AMHPROB($P(^AMHPPROB(DA,0),U,1),0),U,2) D ^DIE K DA,DIE,DR
 D DIE
 I $P(^AMHPPROB(AMHPIEN,0),U,12)="D" D DELMOD
 S DA=AMHPIEN
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
DELMOD ;
 ;
 W !!,"Please Note:  You are NOT permitted to delete a BH Problem without",!,"entering a reason for the deletion."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this BH Problem",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) K DIE,DR,DA S DIE="^AMHPPROB(",DR=".12///"_AMHOLDS,DA=AMHPIEN D ^DIE K DIE,DA,DR W !,"okay, not deleted.  status changed back to "_$$VAL^XBDIQ1(9002011.51,AMHPIEN,.12) D PAUSE Q
 I 'Y K DIE,DR,DA S DIE="^AMHPPROB(",DR=".12///"_AMHOLDS,DA=AMHPIEN D ^DIE K DIE,DA,DR W !,"okay, not deleted.  status changed back to "_$$VAL^XBDIQ1(9002011.51,AMHPIEN,.12) D PAUSE Q
 S DIR(0)="9002011.51,2.01",DIR("A")="Enter the Provider who deleted the Problem"
 S DIR("B")=$S($G(AMHR):$$PRIMPROV^AMHUTIL(AMHR,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  K DIE,DR,DA S DIE="^AMHPPROB(",DR=".12///"_AMHOLDS,DA=AMHPIEN D ^DIE K DIE,DA,DR W !,"  Problem not deleted.  status changed back to "_$$VAL^XBDIQ1(9002011.51,AMHPIEN,.12) D PAUSE Q
 S AMHPRV=+Y
 S DA=AMHPIEN,DR="[AMH DELETE PROBLEM]",DIE="^AMHPPROB(" D ^DIE K DA,DIE,DR
 W !
 Q
DEL ;EP - called from protocol to delete a problem on problem list
 NEW AMHPIEN,ANHPRV
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 W:$D(IOF) @IOF
 W !!,"Deleting the following BH Problem from ",$P($P(^DPT(AMHPAT,0),U),",",2)," ",$P($P(^(0),U),","),"'s BH Problem List.",!
 S DA=AMHPIEN,DIC="^AMHPPROB(" D EN^DIQ
 ;
 W !!,"Please Note:  You are NOT permitted to delete a BH Problem without",!,"entering a reason for the deletion."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this BH Problem",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." D PAUSE,EXIT Q
 I 'Y W !,"Okay, not deleted." D PAUSE,EXIT Q
 S DIR(0)="9002011.51,2.01",DIR("A")="Enter the Provider who deleted the Problem"
 S DIR("B")=$S($G(AMHR):$$PRIMPROV^AMHUTIL(AMHR,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  D PAUSE,EXIT Q
 S AMHPRV=+Y
 S DA=AMHPIEN,DR="[AMH DELETE PROBLEM]",DIE="^AMHPPROB(" D ^DIE K DA,DIE,DR
 W !
 S DA=AMHPIEN
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D PAUSE,EXIT,^XBFMK
 Q
AN ;EP - add a note, called from protocol
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D NO1^AMHBPL2
 D EXIT,^XBFMK
 Q
MN ;EP - called from protocol to modify a note
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D MN1^AMHBPL2
 D PAUSE,EXIT,^XBFMK
 Q
RNO ;EP - called from protocol to remove a note
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D RNO1^AMHBPL2
 D PAUSE,EXIT
 Q
ACT ;EP - called from protocol to activate an inactive problem
 NEW AMHPIEN,AMHNDT
 S AMHNDT=$P(AMHDATE,".")
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 I $P(^AMHPPROB(AMHPIEN,0),U,12)="A" W !!,"That problem is already ACTIVE!!" D PAUSE,EXIT Q
 S AMHTEMP=".12///A;.03////^S X=$$NOW^XLFDT;.15////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Activating BH Problem ... "
 D DIE
 S DA=AMHPIEN
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
INACT ;EP - called from protocol to inactivate an active problem
 NEW AMHPIEN,AMHNDT
 S AMHNDT=$P(AMHDATE,".")
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 I $P(^AMHPPROB(AMHPIEN,0),U,12)="I" W !!,"That BH Problem is already INACTIVE!!",! D PAUSE,EXIT Q
 S AMHTEMP=".12///I;.03////^S X=$$NOW^XLFDT;.15////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Inactivating BH Problem ... "
 D DIE
 S DA=AMHPIEN
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
HS ;EP - called from protocol to display health summary
 NEW AMHHDR
 D FULL^VALM1
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3) I X,$D(^APCHSCTL(X,0)) S X=$P(^APCHSCTL(X,0),U)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 K DIC,DR,DD S DIC("B")=X,DIC="^APCHSCTL(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,D0,D1,DQ
 I Y=-1 D PAUSE,EXIT Q
 S APCHSTYP=+Y,APCHSPAT=AMHPAT
 S AMHHDR="PCC Health Summary for "_$P(^DPT(AMHBPLPT,0),U)
 D VIEWR^XBLM("EN^APCHS",AMHHDR)
 S (DFN,Y)=AMHPAT D ^AUPNPAT
 K APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,AMHHDR
 D EXIT
 Q
DD ;EP - called from protocol to display (DIQ) a problem in detail
 NEW AMHPIEN,AMHTNDF,AMHTN,AMHTDOI,AMHTTPT,AMHTNRQ,AMHAUTH
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D VIEWR^XBLM("DD1^AMHBPL1","Behavioral Health Problem Display")
 D EXIT
 Q
DD1 ;
 ;S DA=AMHPIEN,DIC="^AMHPPROB(" D EN^DIQ
 NEW AMHAR,F,AMHH,AMHZ D ENP^XBDIQ1(9002011.51,AMHPIEN,".01:.13;.15:999999","AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011.51,F,0),U)
 .S AMHZ=AMHAR(F)
 .W !,$E(AMHH,1,25),":",?30,AMHZ
 ;
DDN ;EP
 K AMHNOTES
 S AMHC=0
 Q:'$D(^AMHPTP("AE",AMHPIEN))
 W !,"Notes: "
 S AMHTNDF=0 F AMHTQ=0:0 S AMHTNDF=$O(^AMHPTP("AE",AMHPIEN,AMHTNDF)) Q:'AMHTNDF  D DSPN
 Q
DSPN ; DISPLAY SINGLE NOTE
 S X=$O(^AMHPTP("AE",AMHPIEN,AMHTNDF,"")) Q:X=""
 S AMHC=AMHC+1
 S AMHTN=^AMHPTP(X,0)
 S AMHTDOI=$P(AMHTN,U,5) I AMHTDOI]"" S AMHTDOI=$$DATE^AMHVRL(AMHTDOI)
 S AMHTTPT=$$VAL^XBDIQ1(9002011.53,X,.07)  ;$P(AMHTN,U,7) S AMHTTPT=$S(AMHTTPT=1:"STP",AMHTTPT=2:"LTP",1:"   ")
 S AMHAUTH=$$VAL^XBDIQ1(9002011.53,X,.06)
 W !!?3,AMHC,")",?7,"Date Added: ",AMHTDOI,?30,"Author: "_AMHAUTH
 W !?3,"Note Narrative: "_$$VAL^XBDIQ1(9002011.53,X,.04)
 I AMHTTPT]"" W !?3,AMHTTPT_" TERM TREATMENT"
 S AMHNOTES(AMHC)=X
 Q
FS ;EP -called from protcol to display face sheet
 D FULL^VALM1
 S AMHHDR="Demographic Face Sheet For "_$P(^DPT(AMHPAT,0),U)
 D VIEWR^XBLM("START^AGFACE",AMHHDR)
 K AGOPT,AGDENT,AGMVDF,AMHHDR
 D EXIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
GETNUM(P) ;EP - get problem number given ien of problem entry
 NEW N,F
 S N=""
 I 'P Q N
 I '$D(^AMHPPROB(P,0)) Q N
 S F=$P(^AMHPPROB(P,0),U,6)
 S N=$S($P(^AUTTLOC(F,0),U,7)]"":$J($P(^(0),U,7),4),1:"??")_$P(^AMHPPROB(P,0),U,7)
 Q N
EXIT ;EP
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^AMHBPL
 S VALMCNT=AMHLINE
 D HDR^AMHBPL
 K AMHTEMP,AMHPRMT,AMHP,AMHPIEN,AMHAF,AMHF,AMHP0,AMHPRB
 D KDIE
 Q
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
