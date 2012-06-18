BCHUADD1 ; IHS/TUCSON/LAB - NO DESCRIPTION PROVIDED ;  [ 05/06/04  10:55 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**9,14,16**;OCT 28, 1996
 ;IHS/CMI/LAB - fixed dir call to allow 1-30 characters
 ;
 ;
GETPAT ;EP
 W:$D(IOF) @IOF W !!!!!?15,"******   P A T I E N T   I N F O R M A T I O N   ******",!!
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
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No patient entered.",! Q
 I $D(DIRUT) W !,"No patient entered!! - Required." G ASK
 S (X,BCHNAME)=Y,DIC="^AUPNPAT(",DIC(0)="MQE" D ^DIC K DIC
 I Y=-1 D NOREG Q
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 W !!,"Try again.",! G GETPAT
 S DFN=+Y D DIRX^BCHUADD S BCHF=".04",BCHV=""
 S DIE="^BCHR(",DA=BCHR,DR=".04///`"_DFN D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"PATIENT NOT VALID!  TRY AGAIN" K Y G GETPAT
 ;backfill pt ptr in CHR POV
 S BCHX=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPROB(",DA=BCHX,DR=".02////"_DFN,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating pov's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 K BCHX
 S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPED(",DA=BCHX,DR=".02////"_DFN,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating education's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 Q
 ;
NOREG ;
 W !,"That patient cannot be found in the Registration database."
 W ! S DIR(0)="Y",DIR("A")="Do you want to try to lookup the patient in registration again",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Exiting..." S BCHQUIT=1 Q
 I Y G GETPAT
 ;SCREENMAN CALL
 S DIE="^BCHR(",DA=BCHR,DR="1101///"_BCHNAME D ^DIE K DIE,DR,DA,DIU,DIV,DIW
 S DA=BCHR,DDSFILE=90002,DR="[BCH ENTER PATIENT DATA]" D ^DDS
 K DR,DA,DDSFILE,DIC,DIE
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 Q:$G(^BCHR(BCHR,11))]""
 W !!,"No patient name entered!! This is required!! "
ASK ;
 S DIR(0)="Y",DIR("A")="Do you wish to EXIT and DELETE this record",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 I Y S BCHQUIT=1 Q
 G GETPAT
 Q
 ;
RECCHECK ;EP 
 K BCHOKAY,BCHERROR
 S BCHR0=^BCHR(BCHR,0)
 I $P(BCHR0,U,2)="" W !,"PROGRAM Missing!  " S BCHERROR=1
 I $P(BCHR0,U,3)="" W !,"PROVIDER Missing!  " S BCHERROR=1
 I $P(BCHR0,U,6)="" W !,"Activity Location Missing!  " S BCHERROR=1
 I '$D(^BCHRPROB("AD",BCHR)) W !!,"POV MISSING!  " S BCHERROR=1
 Q
PROTOCOL ;PEP - announce chr record has been added
 D SETARRAY
 S X=+$O(^ORD(101,"B","BCH CHR RECORD EVENT",0))_";ORD(101,"
 D EN^XQOR
 K BCHEV ;kill event array
 Q
SETARRAY ;set up array for pcc protocol call
 S BCHEV("PKG")=$O(^DIC(9.4,"C","BCH","")),BCHPKG=BCHEV("PKG") ;apcdpkg - system wide, required by pcc link
 S BCHEV("SITE")=^BCHSITE(DUZ(2),0) ;pass site parameters
 S BCHEV("CHR IEN")=BCHR ;record in CHR RECORD FILE
 S BCHEV("DATA0")=^BCHR(BCHR,0)
 S BCHEV("DATA12")=$G(^BCHR(BCHR,12))
 S BCHEV("DATA13")=$G(^BCHR(BCHR,13))
 I $P(BCHEV("DATA0"),U,6) S BCHEV("ACTLOC")=^BCHTACTL($P(BCHEV("DATA0"),U,6),0)
 S (X,C)=0 F  S X=$O(^BCHRPROB("AD",BCHR,X)) Q:X=""  D
 .Q:'$D(^BCHRPROB(X,0))
 .Q:$P(^BCHRPROB(X,0),U)=""
 .Q:$P(^BCHRPROB(X,0),U,4)=""
 .Q:$P(^BCHRPROB(X,0),U,6)=""
 .S C=C+1,BCHEV("POV",C)=^BCHRPROB(X,0),BCHEV("POV",C,"ICD9")=$P(^BCHTPROB($P(^BCHRPROB(X,0),U),0),U,5),BCHEV("POV",C,"SRV")=^BCHTSERV($P(^BCHRPROB(X,0),U,4),0)
 S (X,C)=0 F  S X=$O(^BCHRPED("AD",BCHR,X)) Q:X=""  D
 .Q:'$D(^BCHRPED(X,0))
 .Q:$P(^BCHRPED(X,0),U)=""
 .S C=C+1,BCHEV("EDUC",C)=^BCHRPED(X,0)
 K C,X
 Q
