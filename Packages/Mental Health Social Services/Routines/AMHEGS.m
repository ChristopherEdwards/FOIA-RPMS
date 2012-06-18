AMHEGS ; IHS/CMI/LAB - REVIEW SF BY DATE 05 Feb 2010 2:57 PM ; 
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D DONE
 ;
 D EN,FULL^VALM1
 D DONE
 Q
DONE ;
 K AMHX,AMHC,AMHLINE,AMHY,AMHG,AMHR,DFN
 D ^XBFMK
 D KILL^AUPNPAT
 Q
EN ;
 K ^TMP($J,"AMHEGS")
 D GATHER
 D EN^VALM("AMH GROUP PTS")
 D CLEAR^VALM1
 Q
GATHER ;
 K ^TMP($J,"AMHEGS")
 S (AMHC,AMHX,AMHLINE)=0
 F  S AMHX=$O(^AMHGROUP(AMHNG,51,AMHX)) Q:AMHX'=+AMHX  D
 .S DFN=$P(^AMHGROUP(AMHNG,51,AMHX,0),U)
 .S AMHY="",AMHLINE=AMHLINE+1
 .S AMHY=AMHLINE_") "
 .S $E(AMHY,6)=$P(^DPT(DFN,0),U)
 .S $E(AMHY,40)=$P(^DPT(DFN,0),U,2)
 .S $E(AMHY,43)=$$AGE^AUPNPAT(DFN,DT)
 .S $E(AMHY,48)=$$DATE($P(^DPT(DFN,0),U,3))
 .S $E(AMHY,60)=$$HRN^AUPNPAT(DFN,DUZ(2))
 .S Y=$$REC(DFN,AMHNG) S $E(AMHY,70)=$S(Y:"yes",1:"no")
 .S ^TMP($J,"AMHEGS",AMHLINE,0)=AMHY,^TMP($J,"AMHEGS","IDX",AMHLINE,AMHLINE)=AMHX
 Q
REC(P,G) ;does this patient have a record in MHSS for this group
 NEW X,Y,Z
 S X=0,Y=0 F  S X=$O(^AMHGROUP(G,61,X)) Q:X'=+X!(Y)  D
 .S Z=$P(^AMHGROUP(G,61,X,0),U)
 .Q:'$D(^AMHREC(Z,0))
 .I $P(^AMHREC(Z,0),U,8)=P S Y=Z
 .Q
 Q Y
DATE(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HDR ; -- header code
 S VALMHDR(1)="Group Entry"
 S X="",$E(X,6)="Patient Name",$E(X,39)="Sex",$E(X,43)="Age",$E(X,50)="DOB",$E(X,60)="HRN",$E(X,66)="Record Added"
 S VALMHDR(2)=X
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
EDITREC ;
 D FULL^VALM1 K DIR
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHX=0 S AMHX=^TMP($J,"AMHEGS","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,51,AMHX,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE D EXIT Q
 S DFN=$P(^AMHGROUP(AMHNG,51,AMHX,0),U)
 S AMHR=$$REC(DFN,AMHNG)
 I 'AMHR D  D EXIT Q
 .W !!,"There is no visit on file for ",$P(^DPT(DFN,0),U)," for this group activity."
 .S DIR(0)="Y",DIR("A")="Do you want to add a visit",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) D PAUSE Q
 .I 'Y D PAUSE Q
 .S AMHNGX=AMHX D ADDREC1^AMHEGR
 .Q
 I '$D(^AMHREC(AMHR,0)) W !,"Not a valid BH RECORD." K AMHRDEL,AMHR D PAUSE^AMHLEA D EXIT Q
 D FULL^VALM1
 S AMHPAT=DFN
DGSECE ;
 K AMHRESU
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,1)
 I '$G(AMHRESU(1)) G EDITREC1
 I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D DISPDG^AMHLE,PAUSE^AMHLEA,EXIT Q
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to edit this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
EDITREC1 ;
 S AMHVTYPE=$P(^AMHREC(AMHR,0),U,33)
 I AMHVTYPE="" S AMHVTYPE="R"
 S AMHDATE=$P(^AMHREC(AMHR,0),U)
 S AMHPTYPE=$P(^AMHREC(AMHR,0),U,2)
 S AMHACTN=2
 S DIADD=1,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR K DIADD
 I '$P($G(^AMHREC(AMHR,11)),U,12) S DR="[AMH EDIT RECORD]",DA=AMHR,DDSFILE=9002011 D ^DDS
 I $P($G(^AMHREC(AMHR,11)),U,12) S DR="[AMHSV EDIT RECORD]",DA=AMHR,DDSFILE=9002011 D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ** NOTIFY PROGRAMMER **" S AMHQUIT=1 K DIMSG Q
 S AMHERROR=0 D RECCHECK^AMHLE2 I AMHERROR D PAUSE
 D PCCLINK^AMHLEA
 D EXIT
 Q
ADDPT ;
 ;add a new patient to the group
 ;update 51 multiple
 D FULL^VALM1
 ;get patient
 D ^XBFMK
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"No patient selected." D PAUSE,EXIT Q
 S (AMHPAT,DFN)=+Y
 I AMHPAT,'$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL D PAUSE G ADDPT
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 D ^XBFMK
 S DA(1)=AMHNG,DIC="^AMHGROUP("_AMHNG_",51,",DIC(0)="AELQ",DIC("P")=$P(^DD(9002011.67,5101,0),U,2)
 D ^DIC
 I Y=-1 W !!,"adding patient to group failed." D PAUSE,EXIT Q
 D ADDREC^AMHEGR
 ;D UPDACT  ;update activity time on all records to new activity time based on new patient added and call pcc link
 D EXIT
 Q
DISP ;EP - called from protocol
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHX=0 S AMHX=^TMP($J,"AMHEGS","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,51,AMHX,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DFN=$P(^AMHGROUP(AMHNG,51,AMHX,0),U)
 S AMHR=$$REC(DFN,AMHNG)
 I 'AMHR W !!,"There is no record/visit on file yet for this patient." K AMHR,DFN,AMHG D PAUSE,EXIT Q
DGSECD ;
 I '$P(^AMHREC(AMHR,0),U,8) G DISP9
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,1)
 I '$G(AMHRESU(1)) G DISP9
 I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D DISPDG^AMHLE,PAUSE^AMHLEA,EXIT Q
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to display this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
DISP9 ;
 D ^AMHDVD
 D EXIT
 Q
DEL ;EP - called from protocol
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a VISIT.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT Q
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHG=0 S AMHG=^TMP($J,"AMHEGS","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,51,AMHG,0)) W !,"Not a valid patient." K AMHRDEL,R,AMHG,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 S DFN=$P(^AMHGROUP(AMHNG,51,AMHG,0),U)
 S AMHR=$$REC(DFN,AMHNG)
 I 'AMHR W !!,"There is no record/visit on file yet for this patient." K AMHR,DFN,AMHG D PAUSE,EXIT Q
 I '$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)),$P($G(^AMHREC(AMHR,11)),U,12)]"" D  D PAUSE,EXIT Q
 .W !!,$$VAL^XBDIQ1(9002011,AMHR,.01),?20,$$VAL^XBDIQ1(9002011,AMHR,.08)
 .W !!,"The progress note associated with this visit has been signed.  You cannot"
 .W !,"delete this visit.  Please see your supervisor or program manager.",!
DGSECX ;
 I '$P(^AMHREC(AMHR,0),U,8) G DGSECXX
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,1)
 I '$G(AMHRESU(1)) G DGSECXX
 I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D DISPDG^AMHLE,PAUSE^AMHLEA,EXIT Q
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to display this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
DGSECXX ;
 S AMHACTN=4
 D EN^AMHRDSP
 W !
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this Patient's Visit",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE,EXIT Q
 I 'Y D EXIT Q
 ;D ^AMHLEIN
 S AMHPAT=DFN
 D DEL^AMHLEA
 D PCCLINK^AMHLEA
 ;D UPDACT
 D EXIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
EXIT ; -- exit code
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=AMHLINE
 D HDR
 K X,Y,Z,I
 K AMHRESU
 Q
DISPDG ;EP
 W !!,"One of the patients in the group is a sensitive patient:",!
 W !?5,$P(^DPT(AMHPAT,0),U,1),?40,"DOB: ",$$FMTE^XLFDT($$DOB^AUPNPAT(AMHPAT)),?65,"HRN: ",$$HRN^AUPNPAT(AMHPAT,DUZ(2))
 S X=1 F  S X=$O(AMHRESU(X)) Q:X'=+X  W !,$$CTR^AMHLEIN(AMHRESU(X))
 Q
ADDNS ;EP
 S APCDOVRR=""
 D FULL^VALM1
 S AMHADPTV=1
 S AMHQUIT=0,AMHACTN=1
 W !,"Creating new record..." K DD,D0,DO,DINUM,DIC,DA,DR
 S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".08////^S X=$G(AMHPAT);.02///"_AMHPTYPE_";.03///^S X=DT;.19////"_DUZ_";.33////"_AMHVTYPE_";.28////"_DUZ_";.22///A;.21///^S X=DT"_";1111////1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 ;update multiple of user last update/date edited
 S AMHR=+Y
 S DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 S DA=AMHR,DIE="^AMHREC(",DR=".02///"_AMHPTYPE_$S($P(^AMHGROUP(AMHG,0),U,5):";.04///`"_$P(^AMHGROUP(AMHG,0),U,5),1:"")_$S($P(^AMHGROUP(AMHG,0),U,6):";.05///`"_$P(^AMHGROUP(AMHG,0),U,6),1:"")
 S DR=DR_$S($P(^AMHGROUP(AMHG,0),U,14):";.25///`"_$P(^AMHGROUP(AMHG,0),U,14),1:"")
 S DR=DR_";.11///"_$$GETAWI^AMHLEIN(DUZ(2))_$S($P(^AMHGROUP(AMHG,0),U,8):";.07///`"_$P(^AMHGROUP(AMHG,0),U,8),1:"")
 D ^DIE I $D(Y) W !!,"Error updating record......" H 5
 K DR,DA,DIE
 D GETPROV^AMHLEP2 I '$$PPINT^AMHUTIL(AMHR) W !,"No PRIMARY PROVIDER entered!! - Required element" D DEL,EXIT Q
 ;
ADD1 ;
 S DA=AMHR,DDSFILE=9002011,DR="[AMH ADD RECORD]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 ;CHECK RECORD
CHK ;  
 D CHECK^AMHLEA
 I AMHZDEL Q
 I AMHZED G ADD1
 I AMHVTYPE="R" D REGULAR^AMHLEP2
 I $G(AMHNAVR) Q
 D SUIC^AMHLEA,OTHER^AMHLEP2
 D PCCLINK^AMHLEP2
 Q
