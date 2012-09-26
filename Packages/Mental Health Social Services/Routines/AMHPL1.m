AMHPL1 ; IHS/CMI/LAB - problem list update from list manager ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
 ;
DIE ;
 S DA=AMHPIEN,DIE="^AUPNPROB(",DR=AMHTEMP D ^DIE
KDIE ;kill all vars used by DIE
 K DIE,DR,DA,DIU,DIV,DQ,D0,DO,DI,DIW,DIY,%,DQ,DLAYGO
 Q
GETPROB ;get record
 S AMHPIEN=0
 I 'AMHRCNT W !,"No problems to select." Q
 S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select Problem" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No Problem Selected" D PAUSE,EXIT Q
 S AMHP=Y
 S (X,Y)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X!(AMHPIEN)  I $O(^TMP($J,"AMHPL","IDX",X,0))=AMHP S Y=$O(^TMP($J,"AMHPL","IDX",X,0)),AMHPIEN=^TMP($J,"AMHPL","IDX",X,Y)
 I '$D(^AUPNPROB(AMHPIEN,0)) W !,"Not a valid PCC PROBLEM." K AMHP S AMHPIEN=0 Q
 D FULL^VALM1 ;give me full control of screen
 Q
ADD ;EP - called from protocol to add a problem to problem list
 D FULL^VALM1 ; this gives me back all screen control
 Q:'$G(AMHPLPT)  ; just want to be sure I have a patient
 S AMHPAT=AMHPLPT
 S:'$G(AMHLOC) AMHLOC=DUZ(2)
 S:$G(AMHDATE)="" AMHDATE=DT ; set up vars needed by pcc data entry template
 W:$D(IOF) @IOF W !,"Adding a new problem for ",$P(^DPT(AMHPLPT,0),U),".",!!
 S DIC("A")="Enter Diagnosis Code: ",DIC="^AMHPROB(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"No diagnosis code selected." D PAUSE,EXIT Q
 NEW AMHPPTR,APCDLOOK,AMHPIEN
 S AMHPPTR=+Y,APCDLOOK=$P(^AMHPROB(AMHPPTR,0),U,5),APCDLOOK=+$$CODEN^ICDCODE(APCDLOOK,80)
 I APCDLOOK=""!(APCDLOOK=-1) W !!,"no icd9 code mapped to that code." D PAUSE,EXIT Q
 S APCDLOOK="`"_APCDLOOK
 S APCDOVRR=1
 ;S DLAYGO=9000011
 D KDIE S DLAYGO=9000011,DIE("NO^")=1,DIE="^AUPNPAT(",DR="[AMH ADD PCC PROBLEM]",DA=AMHPLPT D ^DIE D KDIE
 W !
 D PLUPCC^AMHAPRB(AMHR,AMHPIEN,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 K DLAYGO D EXIT
 Q
EDIT ;EP - called from protocol to modify a problem on problem list
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 S APCDPIEN=AMHPIEN
 S AMHTEMP="[APCD MODIFY PROBLEM]"
 W:$D(IOF) @IOF W !,"Editing Problem ... "
 D DIE K APCDPIEN
 W !
 D PLUPCC^AMHAPRB(AMHR,AMHPIEN,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
DEL ;EP - called from protocol to delete a problem on problem list
 D FULL^VALM1
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 S APCDPIEN=AMHPIEN
 ;
 W !!,"Please Note:  You are NOT permitted to delete a PCC problem without",!,"entering a reason for the deletion."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this PROBLEM",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." D PAUSE,EXIT Q
 I 'Y W !,"Okay, not deleted." D PAUSE,EXIT Q
 S DA=AMHPIEN,DR="[APCD DELETE PROBLEM]",DIE="^AUPNPROB(" D ^DIE K DA,DIE,DR
 W !
 D PLUPCC^AMHAPRB(AMHR,AMHPIEN,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D PAUSE,EXIT,^XBFMK
 Q
AN ;EP - add a note, called from protocol
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D NO1^AMHPL2
 D EXIT
 Q
MN ;EP - called from protocol to modify a note
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D MN1^AMHPL2
 D PAUSE,EXIT
 Q
RNO ;EP - called from protocol to remove a note
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D RNO1^AMHPL2
 D PAUSE,EXIT
 Q
ACT ;EP - called from protocol to activate an inactive problem
 NEW AMHPIEN,AMHNDT
 S AMHNDT=$P(AMHDATE,".")
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 I $P(^AUPNPROB(AMHPIEN,0),U,12)="A" W !!,"That problem is already ACTIVE!!" D PAUSE,EXIT Q
 S AMHTEMP=".12///A;.03////^S X=DT;.14////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Activating Problem ... "
 D DIE
 D PLUPCC^AMHAPRB(AMHR,AMHPIEN,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
INACT ;EP - called from protocol to inactivate an active problem
 NEW AMHPIEN,AMHNDT
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 I $P(^AUPNPROB(AMHPIEN,0),U,12)="I" W !!,"That problem is already INACTIVE!!",! D PAUSE,EXIT Q
 S AMHTEMP=".12///I;.03////^S X=DT;.14////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Inactivating Problem ... "
 D DIE
 D PLUPCC^AMHAPRB(AMHR,AMHPIEN,$$PRIMPROV^AMHUTIL(AMHR,"I"))
 D EXIT
 Q
HS ;EP - called from protocol to display health summary
 D FULL^VALM1
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3) I X,$D(^APCHSCTL(X,0)) S X=$P(^APCHSCTL(X,0),U)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 K DIC,DR,DD S DIC("B")=X,DIC="^APCHSCTL(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,D0,D1,DQ
 I Y=-1 D PAUSE,EXIT Q
 S APCHSTYP=+Y,APCHSPAT=AMHPLPT
 S AMHHDR="PCC Health Summary for "_$P(^DPT(AMHPLPT,0),U)
 D VIEWR^XBLM("EN^APCHS",AMHHDR)
 S (DFN,Y)=AMHPLPT D ^AUPNPAT
 K APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,AMHHDR
 D EXIT
 Q
DD ;EP - called from protocol to display (DIQ) a problem in detail
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 D DIQ^XBLM(9000011,AMHPIEN)
 D EXIT
 Q
FS ;EP -called from protcol to display face sheet
 D FULL^VALM1
 S AMHHDR="Demographic Face Sheet For "_$P(^DPT(AMHPLPT,0),U)
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
 I '$D(^AUPNPROB(P,0)) Q N
 S F=$P(^AUPNPROB(P,0),U,6)
 S N=$S($P(^AUTTLOC(F,0),U,7)]"":$J($P(^(0),U,7),4),1:"??")_$P(^AUPNPROB(P,0),U,7)
 Q N
EXIT ;
 K APCDOVRR
 K DLAYGO
 K APCDPIEN
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^AMHPL
 S VALMCNT=AMHLINE
 D HDR^AMHPL
 K AMHTEMP,AMHPRMT,AMHP,AMHPIEN,AMHAF,AMHF,AMHP0,AMHPRB,APCDLOOK,AMHPPTR
 D KDIE
 Q
NAP ;EP - called from protocol to DOCUMENT NO ACTIVE PROBLEMS IN PCC
 D FULL^VALM1
 NEW AMHDD,AMHNOGO
 I $$ANYACTP(AMHPAT,DT) D  Q
 .W !!,"There are active problems on this patient's PCC problem list.  You"
 .W !,"cannot use this action item."
 .D PAUSE,EXIT Q
 I $$ANYACTBP(AMHPAT,DT) D  I $G(AMHNOGO) D PAUSE,EXIT Q
 .W !!,"There are active problems on this patient's Behavioral health problem list.",!
 .S AMHNOGO=""
 .K DIR
 .S DIR(0)="Y",DIR("A")="Do you still want to document 'No Active Problems' in PCC",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S AMHNOGO=1 Q
 .I 'Y S AMHNOGO=1 Q
 ;
NAPDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that the patient has No Active Problems",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE,EXIT Q
 I 'Y W !,"No action taken." D PAUSE,EXIT Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider documented 'No Active Problems'"
 S DIR("B")=$S($G(AMHDATE):$$FMTE^XLFDT($P(AMHDATE,".")),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G NAPDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G NAPDE1
 S AMHDD=Y
NAPDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who documented 'No Active Problems'"
 S DIR("B")=$$PRIMPROV^AMHUTIL(AMHR,"N") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G NAPDE1P
 S AMHPRV=+Y
 D NAPPCC^AMHAPRB(AMHR,AMHDD,AMHPRV)
 ;D PLRPCC^AMHAPRB(AMHR,AMHPIEN,AMHPRV)
 ;I $P(AMHRET,U,1)=0 W !!,"error:  ",$P(AMHRET,U,2)
 D PAUSE,EXIT
 Q
ANYACTP(P,EDATE) ;EP - does this patient have any active problems IN PCC?
 I '$G(P) Q 0
 S EDATE=$G(EDATE)
 NEW X,Y,Z
 S Z=0
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(Z)  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .I EDATE,$P(^AUPNPROB(X,0),U,8)>EDATE Q
 .S Z=1
 .Q
 Q Z
 ;
ANYACTBP(P,EDATE) ;EP - does this patient have any active problems IN BH?
 I '$G(P) Q 0
 S EDATE=$G(EDATE)
 NEW X,Y,Z
 S Z=0
 S X=0 F  S X=$O(^AMHPPROB("AC",P,X)) Q:X'=+X!(Z)  D
 .Q:'$D(^AMHPPROB(X,0))
 .Q:$P(^AMHPPROB(X,0),U,12)'="A"
 .I EDATE,$P(^AMHPPROB(X,0),U,8)>EDATE Q
 .S Z=1
 .Q
 Q Z
PLR ;EP - called from protocol to DOCUMENT NO ACTIVE PROBLEMS IN PCC
 D FULL^VALM1
 NEW AMHDD,AMHNOGO
 ;
PLRDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that he/she reviewed the Problem List",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE,EXIT Q
 I 'Y W !,"No action taken." D PAUSE,EXIT Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider reviewed the problem list"
 S DIR("B")=$S($G(AMHDATE):$$FMTE^XLFDT($P(AMHDATE,".")),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G NAPDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G NAPDE1
 S AMHDD=Y
PLRDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who reviewed the problem list"
 S DIR("B")=$$PRIMPROV^AMHUTIL(AMHR,"N") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G NAPDE1P
 S AMHPRV=+Y
 D PLRPCC^AMHAPRB(AMHR,AMHDD,AMHPRV)
 ;D PLRPCC^AMHAPRB(AMHR,AMHPIEN,AMHPRV)
 ;I $P(AMHRET,U,1)=0 W !!,"error:  ",$P(AMHRET,U,2)
 D PAUSE,EXIT
 Q
