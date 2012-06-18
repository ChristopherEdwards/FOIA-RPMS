BCHEGP1 ; IHS/CMI/LAB - GROUP FORM DATA ENTRY CREATE RECORD ; [ 01/30/2007  1:41 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**16**;OCT 28, 1996
 ;
 ;PATCH #16 Populates all Travel Time to one patient
 ;rather than deviding among all pts in group
 ;
 ;loop and get patients until BCHNUM
START ;EP - called from BCHLEGP
 S (BCHQUIT,BCHHIT)=0
START1 ;
 F BCHLEGPI=1:1 D PROCESS Q:$G(BCHQUIT)  Q:BCHHIT=BCHNUM
 I BCHNUM'=BCHHIT D ERROR I 'BCHSTOP G START1
 D EXIT
 Q
PROCESS ;
 D GETPAT
 Q
GETPAT ;
 W !
 ;W:$D(IOF) @IOF
 W !!?15,"******   P A T I E N T   I N F O R M A T I O N   ******",!!
 W !,"If this encounter involved a particular patient, please enter the patient's",!,"chart # or name now.  If this is not a single patient encounter,",!,"but a group encounter, simply HIT the RETURN key to continue.",!
 W !,"Please enter the patient information now.",!
 S DFN=""
 S DIR(0)="FO^1:30",DIR("A")="Enter PATIENT NAME or CHART #"
 S DIR("?",1)="     To find a patient, you can enter the patient's chart number;"
 S DIR("?",2)="     lastname,firstname; SSN; or DOB."
 S DIR("?",3)=" "
 S DIR("?",4)="     If the patient cannot be found in the Patient Registration"
 S DIR("?",5)="     database and you would like to capture demographic information"
 S DIR("?",6)="     for this patient into the CHR database, answer NO when asked"
 S DIR("?",7)="     if you would like to try another lookup.  You will then be"
 S DIR("?",8)="     given the opportunity to capture the patient's demographic"
 S DIR("?",9)="     data on the following screen."
 S DIR("?",10)=""
 S DIR("?",11)="     Registered patient demographic data can only be edit via the"
 S DIR("?")="     Patient Registration system."
 W !,"So far you have entered ",BCHHIT," patient records out of a total of ",BCHNUM,".",!
 I BCHHIT W "You have entered records for: " D  W !!
 .S X=0 F  S X=$O(^BCHGROUP(BCHFID,21,X)) Q:X'=+X  W !?5,$P($G(^BCHR(X,11)),U)
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No patient entered!! - Required",! G GETPAT
 I $D(DIRUT) W !,"No patient entered!! - Required." S BCHQUIT=1 Q
 S (X,BCHNAME)=Y,DIC="^AUPNPAT(",DIC(0)="MQE" D ^DIC K DIC
 I Y=-1 D NOREG G:$G(BCHAGAIN) GETPAT Q
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 W !!,"Try again.",! G GETPAT
 S DFN=+Y
 D GENREC
 Q
 ;
NOREG ;
 S DFN=""
 K BCHAGAIN
 W !,"That patient cannot be found in the Registration database."
 W ! S DIR(0)="Y",DIR("A")="Do you want to try to lookup the patient in registration again",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Exiting..." S BCHAGAIN=1 Q
 I Y S BCHAGAIN=1 Q
 D GENREC
 Q
GENREC ;create CHR record
 S BCHEV("TYPE")="A"
 D ^XBFMK
 S APCDOVRR=1
 S BCHOVRR=1
 I DFN W !!,"Creating new record for ",$P(^DPT(DFN,0),U),"."
 I 'DFN W !!,"Creating CHR record."
 K DD,D0,DO,DIC,DA,DR S DIC(0)="EL",DIC="^BCHR(",DLAYGO=90002,DIADD=1,X=$P(^BCHGROUP(BCHFID,0),U,4)
 S BCHG0=^BCHGROUP(BCHFID,0)
 S DIC("DR")=".02////"_$P(BCHG0,U,2)_";.03////"_$P(BCHG0,U,3)_";.04////"_DFN_";.05////"_$P(BCHG0,U,5)_";.06////"_$P(BCHG0,U,6)_";.07////"_$P(BCHG0,U,7)_";.08////"_$P(BCHG0,U,8)_";.12///1"
 S DIC("DR")=DIC("DR")_";.16////"_DUZ_";.17////"_DT_";.22////"_DT_";.26////H"
 S DIC("DR")=DIC("DR")_";.11////"_$S(BCHHIT=1:$P(BCHG0,U,11),1:0) ;IHS/CMI/TMJ PATCH #16 Travel time to one patient
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"ERROR generating CHR record!!  Deleting Record.",! D ^XBFMK Q
 S BCHR=+Y
 I 'DFN S DA=BCHR,DDSFILE=90002,DR="[BCH ENTER PATIENT DATA]" D ^DDS
 K DR,DA,DDSFILE,DIC,DIE
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" K DIMSG Q
POV ;create pov records
 S BCHOVRR=1
 S BCHX=0 F  S BCHX=$O(^BCHGROUP(BCHFID,91,BCHX)) Q:BCHX'=+BCHX  D
 .S BCHG0=^BCHGROUP(BCHFID,91,BCHX,0)
 .D ^XBFMK
 .S BCHPOVM=$P(BCHG0,U,3)/BCHNUM S BCHPOVM=(BCHPOVM+.5)\1
 .K DD,D0,DO,DIC,DA,DR S DIC="^BCHRPROB(",DIC(0)="EL",DLAYGO=90002.01,DIADD=1,X=$P(BCHG0,U)
 .S DIC("DR")=".02////"_DFN_";.03////"_BCHR_";.04////"_$P(BCHG0,U,2)_";.05///"_BCHPOVM_";.06///"_$TR($P(BCHG0,U,4),";",":")
 .D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating pov record failed.!!  Notify PROGRAMMER!",!!
 D ^XBFMK
 ;M ^BCHR(BCHR,51)=^BCHGROUP(BCHFID,51)
 ;M ^BCHR(BCHR,61)=^BCHGROUP(BCHFID,61)
 ;M ^BCHR(BCHR,71)=^BCHGROUP(BCHFID,71)
SOAP ;
 ;W ! S DIE="^BCHR(",DR="5101;6101;7101",DA=BCHR D ^DIE D ^XBFMK
 D GETMEAS
EDITR ;
 S DIR(0)="Y",DIR("A")="Do you wish to edit anything in this record",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y D EDIT
 ;DO PCC LINK
 D PROTOCOL^BCHUADD1
 S BCHHIT=BCHHIT+1
 ;update 2101 multiple
 D ^XBFMK K DIADD,DLAYGO
 S DIC="^BCHGROUP("_BCHFID_",21,",DIC(0)="L",DIC("P")=$P(^DD(90002.97,2101,0),U,2),DA(1)=BCHFID,X="`"_BCHR D ^DIC
 I Y=-1 W !!,"adding visit to group file entry failed.  Notify supervisor." H 2
 D ^XBFMK K DIADD,DLAYGO
 Q
GETMEAS ;
 I '$G(DFN),'$G(^BCHR(BCHR,11))="" Q  ;no patient so no measurements
 W !
 S DIR(0)="Y",DIR("A")=$S('$G(BCHUABFO):"Any MEASUREMENTS, TESTS or REPRODUCTIVE FACTORS",1:"Any MEASUREMENTS/TESTS"),DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S DA=BCHR,DDSFILE=90002,DR=$S('$G(BCHUABFO):"[BCH ENTER MEASUREMENTS/TESTS]",1:"[BCHB ENTER MEASUREMENTS/TESTS") D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG D ^XBFMK Q
 D ^XBFMK
 Q
EDIT ;
 W !
 S DA=BCHR,DDSFILE=90002,DR="[BCH EDIT RECORD DATA]" D ^DDS
 K DR,DA,DDSFILE,DIC,DIE
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 S BCHPAT=$P(^BCHR(BCHR,0),U,4)
 Q:BCHPAT=""
 ;backfill pt ptr in CHR POV
 S BCHX=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPROB(",DA=BCHX,DR=".02////"_BCHPAT,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating pov's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 ;backfill pt ptr in CHR EDUC
 S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPED(",DA=BCHX,DR=".02////"_BCHPAT,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating educ's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 Q
EXIT ;clean up and exit
 K DIC,DR,DA,X,Y,DIU,DIU,D0,DO,DI
 K BCHHIT,BCHX
 K DIR,X,Y,DIC,DR,DA,D0,DO,DIZ,D
 Q
ERROR ;
 W !!,$C(7),$C(7),"You have NOT completed entry of all of the ",BCHNUM," patients!!"
 W !,"This means that you MUST enter each of the remaining visits individually,",!,"using ",($P(^BCHGROUP(BCHFID,0),U,11)\BCHNUM)," minutes activity time for each patient.",!!!
 ;really want to quit?
 K DIR S DIR(0)="Y",DIR("A")="Are you sure you wish to stop",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHSTOP=1 Q
 I Y S BCHSTOP=1 Q
 S BCHSTOP=0
 Q
PAUSE ;
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DEL ;
 S DIK="^BCHR(",DA=BCHR D ^DIK K DA,DIK
 W !,"Record deleted."
 D PAUSE
 Q
