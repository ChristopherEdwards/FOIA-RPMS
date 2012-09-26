AMHBPL2 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ; 08 Sep 2011  12:17 PM
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
NO1 ;EP
 NEW AMHNOTES,AMHTNDF,AMHTQ,AMHNNUM,X,Y,AMHTN,AMHTDOI,AMHTTPT,AMHAUTH,AMHUPV
 S AMHUPV=0
NO12 W:$D(IOF) @IOF
 W !!,"Adding a Note to the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s BH Problem List.",!
 ;S (X,D)=0 F  S X=$O(AMHBHPL("IDX",X)) Q:X'=+X!D  S Y=$O(AMHBHPL("IDX",X,0)) S:Y>AMHPIEN D=1 I AMHBHPL("IDX",X,Y)=AMHPIEN W !,AMHBHPL(X,0)
 S DA=AMHPIEN,DIC="^AMHPPROB(" D EN^DIQ
 D DDN^AMHBPL1
 ;S AMHTNDF=0 F AMHTQ=0:0 S AMHTNDF=$O(^AMHPTP("AE",AMHPIEN,AMHTNDF)) Q:'AMHTNDF  D DSPN
 W ! S DIR(0)="Y",DIR("A")="Add a new Problem Note for this Problem",DIR("B")="Y" K DA D ^DIR K DIR
 G:$D(DIRUT) NOX
 G:Y=0 NOX
NUM ;
 S AMHNNUM=$$GETNUM^AMHLETN(AMHPIEN)
 W !
 S DIC="^AMHPTP(",X=AMHNNUM,DIC("DR")=".02////"_AMHPAT_";.03////"_AMHPIEN_";.05////"_DT,DIADD=1,DLAYGO=9002011.53,DIC(0)="EL"
 D FILE^DICN
 K DLAYGO,DIADD,DIC,DA
 I Y=-1 W !,"error creating note entry" D PAUSE^AMHBPL1 G NOX ; Q
 W !
 S AMHNIEN=+Y
 S DIE="^AMHPTP(",DA=AMHNIEN,DR=".04;.06//^S X=$P(^VA(200,DUZ,0),U);.07" D ^DIE K DIE,DR,DA
 S AMHUPV=1
 G NO12 ; D EXIT
NOX ;
 I AMHUPV D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I")) S DA=AMHPIEN,DIE="^AMHPPROB(",DR=".03////"_$$NOW^XLFDT_".15////"_DUZ D ^DIE K DA,DIE,DR
 K Y,X,L,AMHNNUM,AMHL,DIC,DA,DD,AMHC,AMHN,AMHNIEN,DR,DIADD
 Q
RNO1 ;EP - called from AMHBPL1 - remove a note
 NEW AMHNOTES,AMHTNDF,AMHTQ,AMHNNUM,X,Y,AMHTN,AMHTDOI,AMHTTPT,AMHAUTH,AMHRN
 W:$D(IOF) @IOF
 K AMHN,AMHL,AMHX,AMHC
 W !!,"Editing a Note on the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s BH Problem List.",!
 S DA=AMHPIEN,DIC="^AMHPPROB(" D EN^DIQ
 D DDN^AMHBPL1
 ;S AMHTNDF=0 F AMHTQ=0:0 S AMHTNDF=$O(^AMHPTP("AE",AMHPIEN,AMHTNDF)) Q:'AMHTNDF  D DSPN
 I '$D(AMHNOTES) W !?8,"No notes on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_AMHC_":",DIR("A")="Remove which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S AMHRN=AMHNOTES(+Y)
RSURE ;
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this NOTE",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." G RNO1X
 I 'Y W !,"Okay, not deleted." G RNO1X
 S DA=AMHRN,DIE="^AMHPTP(",DR=".01///@" D ^DIE K DIE,DR,DA,Y W !
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I")) S DA=AMHPIEN,DIE="^AMHPPROB(",DR=".03////"_$$NOW^XLFDT_".15////"_DUZ D ^DIE K DA,DIE,DR
RNO1X ;xit
 K AMHPIEN,AMHL,AMHX,AMHN,AMHY
 Q
MN1 ;EP - called to modify a note
 NEW AMHNOTES,AMHTNDF,AMHTQ,AMHNNUM,X,Y,AMHTN,AMHTDOI,AMHTTPT,AMHAUTH
 W:$D(IOF) @IOF
 K AMHN,AMHL,AMHX,AMHC
 W !!,"Editing a Note on the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s BH Problem List.",!
 S DA=AMHPIEN,DIC="^AMHPPROB(" D EN^DIQ
 D DDN^AMHBPL1
 ;S AMHTNDF=0 F AMHTQ=0:0 S AMHTNDF=$O(^AMHPTP("AE",AMHPIEN,AMHTNDF)) Q:'AMHTNDF  D DSPN
 I '$D(AMHNOTES) W !?8,"No notes on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_AMHC_":",DIR("A")="Edit which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S AMHY=+Y
MSURE ;
 S DA=AMHNOTES(+Y),DIE="^AMHPTP(",DR=".04;.07" D ^DIE K DIE,DR,DA,Y W !
 D PLUDE^AMHAPRB(AMHPIEN,AMHPAT,AMHR,,$$PRIMPROV^AMHUTIL(AMHR,"I")) S DA=AMHPIEN,DIE="^AMHPPROB(",DR=".03////"_$$NOW^XLFDT_".15////"_DUZ D ^DIE K DA,DIE,DR
MNO1X ;
 K AMHPIEN,AMHL,AMHX,AMHN,AMHY,AMHNOTES
 Q
BHP ;EP - called from protocol
 D FULL^VALM1
 I '$D(^XUSEC("AMHZ PCC PROBLEM LIST",DUZ)) W !!,"You do not have security access to the PCC Problem List.  Please see your",!,"supervisor or program manager.  The security Key is AMHZ PCC PROBLEM LIST.",! D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 W !!,"Please select the problem entry to add to the PCC Problem List."
 NEW AMHPIEN,AMHTEMP,AMHDSME,AMHDSMI,AMHDSM9,AMHN,AMHPLI
 D GETPROB^AMHBPL1
 I 'AMHPIEN D PAUSE^AMHBPL1 G BHPX  ; Q
 S AMHDSMI=$P(^AMHPPROB(AMHPIEN,0),U,1)
 S AMHDSME=$P(^AMHPROB(AMHDSMI,0),U,1)
 S AMHDSM9=$P(^AMHPROB(AMHDSMI,0),U,5)  ;icd9 code
 I AMHDSM9="" W !!,"This code is administrative in nature and cannot be added to the PCC ",!,"Problem List.",! D PAUSE^AMHBPL1 G BHPX
 D ^AMHPROB
 S AMHDSMI=$P(^AMHPPROB(AMHPIEN,0),U,1)
 S AMHDSME=$P(^AMHPROB(AMHDSMI,0),U,1)
 S AMHDSM9=$P(^AMHPROB(AMHDSMI,0),U,5)  ;icd9 code
 S AMHN=$P(^AMHPPROB(AMHPIEN,0),U,5) I AMHN S AMHN="`"_AMHN
 I $$HASPROB(AMHPAT,AMHDSM9) W !!,AMHDSM9," is already on this patient's PCC Problem List."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to add diagnosis "_AMHDSME_" to PCC",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not added." G BHPX
 I 'Y W !,"Okay, not added." G BHPX
 S X=$$ADDPROB(AMHDSM9,AMHPAT,,,AMHN,,,$P(^AMHPPROB(AMHPIEN,0),U,12),$P(^AMHPPROB(AMHPIEN,0),U,13))
 I X W !,"Error updating PCC Problem List...Notify Help Desk." D BHPX
 S AMHPLI=$P(X,U,2)
 W !,"This is the only narrative the rest of the medical community will see",!,"on the Health Summary for this problem.  You may change it now if desired.",!
 S DA=AMHPLI,DIE="^AUPNPROB(",DR=".05//" D ^DIE K DA,DR,DIE
BHPX ;
 D EXIT^AMHBPL1
 Q
HASPROB(P,D) ;EP
 NEW X,G
 S G=0
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .I $$VAL^XBDIQ1(9000011,X,.01)=D S G=1
 Q G
ADDPROB(AMHDX,AMHP,AMHDLM,AMHCLS,AMHN,AMHFAC,AMHDTE,AMHSTAT,AMHDOO,AMHCLAS,AMHEBU,AMHEC1,AMHEC2,AMHEC3) ;PEP called to non-interactively add a problem to the pcc problem list
 ;AMHDX is the dx - pass in "`"_ien format or pass code (required)
 ;AMHP is the patient dfn (required)
 ;AMHDLM is the date last modified, if null I will stuff DT, PASS IN EXTERNAL FORMAT PLEASE
 ;AMHCLS is the class (not required)
 ;AMHN - provider narrative pass either "`"_ien of prov narr or pass narrative text
 ;AMHFAC - facility ien, if null will use DUZ(2)
 ;AMHDTE - date entered, if null will use DT , PASS IN EXTERNAL FORMAT PLEASE
 ;AMHSTAT - status I or A WILL DEFAULT TO A IF NONE PASSED
 ;AMHDOO - date of onset (pass in EXTERNAL  format please) (not required)
 ;AMHCLAS= .15 field
 ;AMHEBU = ENTERED BY (field 1.03) if blank  is stuffed with DUZ
 ;AMHEC1, AMHEC2, AMHEC3 - E CODES pass in "`"_ien format or pass code (required)
 ;
 ;error codes will be past back
 ;    1 = invalid dx, either not a valid ien, inactive code, E code
 ;    2 = invalid patient dfn, either not a valid dfn or patient merged
 ;    3 = invalid class code
 ;    4 = error creating entry with FILE^DICN
 ;    5 = invalid date last modified
 ;    6 = invalid provider narrative
 ;    7 = invalid date entered
 ;    8 = invalid facility
 ;    9 = invalid status
 ;   10 = invalid date of onset
 ;   11 = invalid ecode 1
 ;   12 = invalid ecode 2
 ;   13 = invalid ecode 3
 ;
 NEW AMHERR
 S AMHERR=0
 D EN^XBNEW("AP^AMHBPL2","AMHDX;AMHP;AMHDLM;AMHCLS;AMHN;AMHFAC;AMHDTE;AMHSTAT;AMHDOO;AMHCLAS;AMHEBU;AMHERR;AMHEC1;AMHEC2;AMHEC3;AMHPLI")
 Q AMHERR_U_$G(AMHPLI)
 ;
AP ;EP
 NEW IEN,%,F,%FDA
P I '$G(AMHP) S AMHERR=2 Q
 I '$D(^DPT(AMHP)) S AMHERR=2 Q
 I $P(^DPT(AMHP,0),U,19) S AMHERR=2 Q
 I '$D(^AUPNPAT(AMHP)) S AMHERR=2 Q
 S Y=AMHP D ^AUPNPAT
DX ;DX CHK
 I $G(AMHDX)="" S AMHERR=1 Q
 D CHK^DIE(9000011,.01,"",AMHDX,.%) I %="^" S AMHERR=1 Q
 S AMHDX=%
DLM ;
 I $G(AMHDLM)="" S AMHDLM=$$FMTE^XLFDT(DT,"1D")
 D CHK^DIE(9000011,.03,"",AMHDLM,.%) I %="^" S AMHERR=5 Q
CLS ;
 I $G(AMHCLS)="" S AMHCLS=""
 I AMHCLS]"" D  Q:AMHERR
 .D CHK^DIE(9000011,.04,"",AMHCLS,.%) I %="^" S AMHERR=3 Q
NARR ;
 I $G(AMHN)="" S AMHERR=6 Q
 I $$CHKNARR(AMHN) S AMHERR=6 Q
FAC ;
 I '$G(AMHFAC) S AMHFAC=DUZ(2)
 I '$D(^AUTTLOC(AMHFAC)) S AMHERR=8 Q
DTE ;
 I $G(AMHDTE)="" S AMHDTE=$$FMTE^XLFDT(DT,"1D")
 D CHK^DIE(9000011,.08,"",AMHDTE,.%) I %="^" S AMHERR=7 Q
STATUS ;
 I $G(AMHSTAT)="" S AMHSTAT="A" G DOO
 D CHK^DIE(9000011,.12,"",AMHSTAT,.%) I %="^" S AMHERR=9 Q
DOO ;
 S:$G(AMHDOO)="" AMHDOO="" G CLASS
 D CHK^DIE(9000011,.13,"",AMHDOO,.%) I %="^" S AMHERR=10 Q
CLASS ;
 S AMHCLAS=$G(AMHCLAS)
 S AMHEC1=$G(AMHEC1)
 I AMHEC1]"" D CHK^DIE(9000011,.16,"",AMHEC1,.%) I %="^" S AMHERR=11 Q
 S AMHEC2=$G(AMHEC2)
 I AMHEC2]"" D CHK^DIE(9000011,.17,"",AMHEC2,.%) I %="^" S AMHERR=12 Q
 S AMHEC3=$G(AMHEC3)
 I AMHEC3]"" D CHK^DIE(9000011,.18,"",AMHEC3,.%) I %="^" S AMHERR=13 Q
NMBR ;calculate new number
 NEW X,Y S X=0,Y="" F  S Y=$O(^AUPNPROB("AA",AMHP,AMHFAC,Y)) S:Y'="" X=$E(Y,2,4) I Y="" S X=X+1 K Y Q
 S AMHNMBR=X
FILE ;
 S AMHOVRR=1,AMHALVR=""
 S X=AMHDX,DIC(0)="L",DIC="^AUPNPROB(",DLAYGO=9000011,DIADD=1
 S DIC("DR")=".02////"_AMHP_";.03///"_AMHDLM_";.04///"_AMHCLS_";.05///"_AMHN_";.06////"_AMHFAC_";.08///"_AMHDTE_";.07///"_AMHNMBR_";.12///"_AMHSTAT_";.13///"_AMHDOO_";1.03////"_$S($G(AMHEBU):AMHEBU,1:DUZ)_";.15///"_AMHCLAS
 S DIC("DR")=DIC("DR")_";.16///"_AMHEC1_";.17///"_AMHEC2_";.18///"_AMHEC3
 K DD,DO D FILE^DICN K DD,DO,DR,DLAYGO,DIADD,DIC
 I Y=-1 S AMHERR=4 Q
 S AMHPLI=+Y
 Q
CHKNARR(D) ;
 NEW %,F
 S F=0
 I $E(D)="`" S D=$P(D,"`",2) D  Q F
 .I '$D(^AUTNPOV(D)) S F=1
 .;S AMHN=D
 .Q
 S X=D X $P(^DD(9999999.27,.01,0),U,5,99)
 I '$D(X) S F=1
 Q F
DELPROB(P,REASON,OTHER) ;PEP called to delete a problem from the PCC Problem list
 ;non interactive -1 will be returned if a valid problem ien was not passed
 ;sets .12 field to D, sets 2.01 to DUZ, set 2.02 to $$NOW
 ;if passed sets 2.03 to REASON
 ;if passed, sets 2.04 to OTHER
 NEW DA,DIE,DR
 I '$G(P) Q -1
 I '$D(^AUPNPROB(P)) Q -1
 S REASON=$G(REASON)
 S OTHER=$G(OTHER)
 S DA=P  ;,DIK="^AUPNPROB(" D ^DIK
 S DIE="^AUPNPROB("
 S DR=".12////D;2.01////"_DUZ_";2.02///^S X=$$NOW^XLFDT;2.03///"_REASON_";2.04///"_OTHER
 D ^DIE K DA,DR,DIE
 I $D(Y) Q "-1^INVALID DATA"
 Q ""
PCC ;EP
 D FULL^VALM1
 I '$D(^XUSEC("AMHZ PCC PROBLEM LIST",DUZ)) W !!,"You do not have the security access to the PCC Problem List.  Please see your",!,"supervisor or program manager.  The security Key is AMHZ PCC PROBLEM LIST.",! D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 W !!,"You are now leaving the Behavioral Health Problem List and will be taken"
 W !,"into the PCC Problem List for updating.",!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT^AMHBPL1 Q
 I 'Y D EXIT^AMHBPL1 Q
 S DFN=AMHPAT
 D EN1^APCDPL
 D EXIT^AMHBPL1
 Q
