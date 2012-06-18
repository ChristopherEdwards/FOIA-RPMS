AMHLE2 ; IHS/CMI/LAB - DE CONT. ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
RECCHECK ;EP - check record for completeness
 I '$D(^AMHREC(AMHR,0)) Q
 S AMHREC=$G(^AMHREC(AMHR,0))
 S (AMHERROR,AMHOKAY)=0
 I $P(AMHREC,U,4)="" W !,"Location of Encounter Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,5)="" W !,"Community of Service Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,6)="" W !,"Activity Type Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,7)="" W !,"Type of Contact Missing!" S (AMHOKAY,AMHERROR)=1
 S (X,Y)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 W !,"No primary Provider!" S (AMHOKAY,AMHERROR)=1  ;,$C(7),$C(7) S AMHERROR=1 H 2
 I Y>1 W !,"Multiple Primary Providers!" S (AMHOKAY,AMHERROR)=1  ;,$C(7),$C(7) W:'$G(AMHERROR) " PLEASE EDIT THIS RECORD" H 2
 I '$D(^AMHRPRO("AD",AMHR)) W !,"No POV entered!!" S (AMHOKAY,AMHERROR)=1  ;,$C(7) W:'$G(AMHERROR) "  PLEASE EDIT THIS RECORD" H 2 Q
 ;IF PAT ACTIVITY AND PATIENT MISSING - ERROR
 I $P(AMHREC,U,12)="" W !,"Activity Time Missing!" S (AMHOKAY,AMHERROR)=1 ;W $C(7) S AMHERROR=1 H 2
 I $G(AMHERROR) W !!,"Please EDIT this record." D PAUSE^AMHLEA
 I AMHACTN=2&($P(^AMHREC(AMHR,0),U,8)="") D DELPT
 Q
DELPT ;delete .02 field of all record entries if not patient related
 S AMHVFLE=9002011 F AMHVL=0:0 S AMHVFLE=$O(^DIC(AMHVFLE)) Q:AMHVFLE>9002011.49  D
 .S AMHVDG=^DIC(AMHVFLE,0,"GL"),AMHVIGR=AMHVDG_"""AD"",AMHR,AMHVDFN)"
 .S AMHVDFN="" F AMHVI=1:1 S AMHVDFN=$O(@AMHVIGR) Q:AMHVDFN=""  S AMHVIGL=AMHVDG_AMHVDFN_",0)" W:'$D(ZTQUEUED) "." I $P((@AMHVIGL),U,2)]"" S DA=AMHVDFN,DITC="",DR=".02///@",DIE=AMHVDG D CALLDIE^AMHLEIN
 Q
EP1(AMHPAT) ;EP called from protocol
 D FULL^VALM1
 W:$D(IOF) @IOF
 S AMHDATE=DT
 S AMHLOC=DUZ(2)
 ;D EN^XBNEW("MHPL^AMHLE2","AMH*")
 D MHPL^AMHLE2
 Q
EP ;EP = CALLED FROM SCREENMAN
 W:$D(IOF) @IOF
 D EN^XBNEW("MHPL^AMHLE2","AMH*")
 Q
MHPL ;EP - update mh/ss problem list
 S APCDOVRR=""
 K AMHX,AMHJ,AMHTEXT
 I $G(AMHLOC)="" S AMHLOC=DUZ(2)
 W !!,"Behavioral Health Patient Diagnosis List Update Menu",!
 F AMHJ=1:1:11 S AMHX=$P($T(PROBMENU+AMHJ),";;",2) W !?11,AMHJ,")  ",AMHX
 K AMHX,AMHJ,AMHTEXT
 S DIR(0)="N^1:11:0",DIR("A")="Choose One",DIR("B")="11" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=11
 S AMHPLC=Y
 I '$G(AMHAUTH),$G(AMHR) S AMHAUTH=$$PPNAME^AMHUTIL(AMHR)
 I '$G(AMHAUTH) S AMHAUTH=$P(^VA(200,DUZ,0),U)
 I AMHPLC=10 S DFN=AMHPAT D EN1^AMHPL Q
 S DIE="^AUPNPAT(",DR="["_$P($T(PROBMENU+AMHPLC),";;",3)_"]",DA=AMHPAT,DIE("NO^")="" D CALLDIE^AMHLEIN K DR,DA,DIE
 I $D(Y) W !!,"Error encountered in updating BH Diagnosis List for ",$P(^DPT(AMHPAT,0),U)
 K Y,X,DIU,DIV
 G MHPL
PCCLINK ;EP - PCCLINK
 K X
 I AMHACTN=4 G PCCLINK2
 I '$D(^AMHREC(AMHR,0)) G PCCLINK2
 I $G(AMHVDLT) G PCCLINK2
 Q:'$P(^AMHREC(AMHR,0),U,8)  ;no pcc if not a patient encounter
 S X=$$ESIG^AMHESIG(AMHR)
 I '$P(X,U,2),AMHLPCC W !!,"No PCC Link...Note not signed." D PAUSE^AMHLEA Q
PCCLINK1 ;
 I 'AMHLPCC Q:'$$PRVLINK($$PPINT^AMHUTIL(AMHR))  ;quit if no pcc link
PCCLINK2 ;
 I $G(AMHVDLT)="",AMHACTN=4 Q
 I $G(AMHVDLT),AMHACTN=4 D TASK Q
 D VISIT
 I 'AMHVISIT,$P(^AMHREC(AMHR,0),U,16)]"" D  Q
 .S APCDVDLT=$P(^AMHREC(AMHR,0),U,16) D ^APCDVDLT
 .S DIE="^AMHREC(",DA=AMHR,DR=".16///@" D CALLDIE^AMHLEIN
 Q:AMHVISIT
 Q
PRVLINK(P) ;EP
 I '$G(P) Q 0
 I '$D(^AMHSITE(DUZ(2),11,"B",P)) Q 0
 NEW A
 S A=$O(^AMHSITE(DUZ(2),11,"B",P,0))
 I 'A Q 0
 I $P(^AMHSITE(DUZ(2),11,A,0),U,1)=1 Q 0
 Q 1
 ;
VISIT ;
 K AMHDNKA
 S AMHVISIT=0
 Q:'$G(AMHR)
 Q:'$P(^AMHREC(AMHR,0),U,8)  ;no pcc if not a patient encounter
 ;do not pass residential type of visits to pcc
 I $$VAL^XBDIQ1(9002011,AMHR,.07)="RESIDENTIAL" Q  ;if one record a day, don't want in PCC
 ;do not pass visits with dnka problem code
 ;check for at least one pov that is icd9 codable
 S (AMHX,AMHGOT,AMHDNKA)=0 F  S AMHX=$O(^AMHRPRO("AD",AMHR,AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.1 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.11 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.2 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.21 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.3 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U,5)]"" S AMHGOT=1
 .Q
 Q:AMHDNKA
 Q:$P(^AMHREC(AMHR,0),U,6)=""
 Q:'AMHGOT
 Q:'$P(^AMHTACT($P(^AMHREC(AMHR,0),U,6),0),U,4)  ;quit if not an activity that gets passed to PCC
TASK ;
 ;*****************************
 I AMHACTN=4 G TASK1
 I '$G(AMHIAIG),$$ESIG^AMHESIG(AMHR),$P($G(^AMHREC(AMHR,11)),U,12)="" D  Q  ;no esig
 .W !!,"There is no electronic signature, this visit will not be passed to PCC." D PAUSE^AMHLEA
TASK1 ;
 D START^AMHPCCL S AMHVISIT=1 Q  ;************ FOR TESTING IN FOREGROUND
 Q
 ;
PROBMENU ;;
 ;;Add a Problem to BH Diagnosis List;;AMH ADD PROBLEM
 ;;Modify a Problem on BH Diagnosis List;;AMH MODIFY PROBLEM
 ;;Remove a Problem from BH Diagnosis List;;AMH REMOVE PROBLEM
 ;;Inactivate an Active Problem on BH Diagnosis List;;AMH INACTIVATE PROBLEM
 ;;Activate an Inactive Problem on BH Diagnosis List;;AMH ACTIVATE PROBLEM
 ;;Add a Treatment Note to a BH Problem;;AMH ADD NOTE
 ;;Modify a Treatment Note of BH Problem;;AMH MODIFY NOTE
 ;;Remove a Treatment Note to BH Problem;;AMH REMOVE NOTE
 ;;Display Patient's BH Diagnosis List;;AMH DISPLAY PROBLEM LIST
 ;;Update the Patient's PCC Problem List
 ;;Quit
