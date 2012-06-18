AMHPL1 ; IHS/CMI/LAB - problem list update from list manager ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
DIE ;
 S DA=AMHPIEN,DIE="^AUPNPROB(",DR=AMHTEMP D ^DIE
KDIE ;kill all vars used by DIE
 K DIE,DR,DA,DIU,DIV,DQ,D0,DO,DI,DIW,DIY,%,DQ,DLAYGO
 Q
GETPROB ;get record
 S AMHPIEN=0
 D EN^VALM2(XQORNOD(0),"OS") ;this list man call allows user to select an entry in list
 I '$D(VALMY) W !,"No problem selected." Q
 S AMHP=$O(VALMY(0)) I 'AMHP K AMHP,VALMY,XQORNOD W !,"No record selected." Q
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
 S AMHPPTR=+Y,APCDLOOK=$P(^AMHPROB(AMHPPTR,0),U,5),APCDLOOK=+$$CODEN^ICDCODE(APCDLOOK,80)
 I APCDLOOK=""!(APCDLOOK=-1) W !!,"no icd9 code mapped to that code." D PAUSE,EXIT Q
 S APCDLOOK="`"_APCDLOOK
 ;S DLAYGO=9000011
 D KDIE S DLAYGO=9000011,DIE("NO^")=1,DIE="^AUPNPAT(",DR="[AMH ADD PCC PROBLEM]",DA=AMHPLPT D ^DIE D KDIE
 K DLAYGO D EXIT
 Q
EDIT ;EP - called from protocol to modify a problem on problem list
 NEW AMHPIEN
 D GETPROB
 I 'AMHPIEN D PAUSE,EXIT Q
 S APCDPIEN=AMHPIEN K AMHDATE
 S AMHTEMP="[APCD MODIFY PROBLEM]"
 W:$D(IOF) @IOF W !,"Editing Problem ... "
 D DIE K APCDPIEN
 D EXIT
 Q
DEL ;EP - called from protocol to delete a problem on problem list
 D FULL^VALM1
 S DIR(0)="L^1:"_AMHRCNT,DIR("A")="Delete Which Problem(s)" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No problems selected." D PAUSE,EXIT Q
 I Y="" W !,"No problems selected." D PAUSE,EXIT Q
 NEW C,I,T,S,AMHDEL,G,P,IEN,X
 S C="",(S,T)=0 F I=1:1 S C=$P(Y,",",I) Q:C=""  S T=T+1 D
 .S (X,G)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X!(G)  I $D(^TMP($J,"AMHPL","IDX",X,C)) S G=1
 .I 'G W !,$C(7),C," is an invalid problem number." Q
 .S AMHDEL(C)=^TMP($J,"AMHPL","IDX",X,C),S=S+1
 .Q
 I S'=T W !!,"Not all problem numbers are valid." Q
 W:$D(IOF) @IOF
 W !!,"Deleting the following Problem(s) from ",$P($P(^DPT(AMHPLPT,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,P)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X  S P=0 F  S P=$O(^TMP($J,"AMHPL","IDX",X,P)) Q:P'=+P  I $D(AMHDEL(P)) W !,^TMP($J,"AMHPL",X,0)
 ;
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this PROBLEM(s)",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." D PAUSE,EXIT Q
 I 'Y W !,"Okay, not deleted." D PAUSE,EXIT Q
 NEW IEN S IEN=0 F  S IEN=$O(AMHDEL(IEN)) Q:IEN'=+IEN  S DA=AMHDEL(IEN),DIK="^AUPNPROB(" D ^DIK W !,"PROBLEM DELETED" K DA,DIK
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
