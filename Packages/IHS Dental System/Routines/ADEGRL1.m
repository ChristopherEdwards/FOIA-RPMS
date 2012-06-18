ADEGRL1 ; IHS/HQT/MJL - DENTAL ENTRY PART 2 ;12:36 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;IHS/MFD FAC SUBRTN REDONE FOR MULTI-FACILITY LOOKUP PER DG/OHPRD
FAC ;EP
 W !,"Select Location of Encounter: ",$S($D(ADEFAC):ADEFAC_"// ",1:"") R X:DTIME
 K DIC,Y S DIC="^ADEPARAM(DUZ(2),1,",DIC(0)="EZMQ" D ^DIC K DIC Q:"^"[X
 I Y<0 W !,*7,"Only facilities entered into the LOCAL FACILITY field of the DENTAL SITE",!,"PARAMETERS file may be selected." G FAC
 S ADETMP=+Y(0)
 K AUPNLK("ALL") D UNIV^ADEGRL0 G:'Y FAC
 S (ADEFACD,DUZ(2))=+Y(0),ADEFAC=Y(0,0)
 Q
REPD K DIC,Y S DIC=6,DIC("A")="Select Attending Dentist: ",DIC(0)="MAEZQ"
 S DIC("S")="D SCRN1^ADEGRL1"
 S:$D(ADEREP) DIC("B")=ADEREP D ^DIC K DIC Q:Y=-1
 S (ADEREPD)=$P(Y,U),(ADEREP)=Y(0,0)
 Q
 ;I $D(^DIC(6,Y,9999999)),$P(^DIC(6,Y,9999999),U)=$S(ADECON:"2",1:"1"),$P(^DIC(6,Y,0),U,4)]"",^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)=52,$P(^DIC(16,Y,0),U,9)]""
SCRN1 I $D(^DIC(6,Y,9999999)),$S(ADECON:"2",1:"138")[$P(^DIC(6,Y,9999999),U),$P(^DIC(6,Y,0),U,4)]"",+^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)=52,$P(^DIC(16,Y,0),U,9)]""
 E  Q
 I $S('$D(^DIC(6,Y,"I")):1,^DIC(6,Y,"I")']"":1,1:0)
 Q
 ;
SCRN2 I $P(^DIC(6,Y,0),U,4)]"",$D(^DIC(7,$P(^DIC(6,Y,0),U,4),9999999)),+^(9999999)=46
 E  Q
 I $S('$D(^DIC(6,Y,"I")):1,^DIC(6,Y,"I")']"":1,1:0)
 Q
LINE W $E(ADELIN,1,40-($L(ADETITL)/2)),ADETITL,$E(ADELIN,1,39-($L(ADETITL)/2)) Q
RESET ;EP
 D ^ADECLS
 S:'$D(ADEPRO) (ADEPRO,ADEPROD)=""
 S:'$D(ADEREP) (ADEREP,ADEREPD)=""
 S:ADEDIR&(ADEREP="") ADEREPD=$P(^ADEPARAM($P(^AUTTSITE(1,0),U),0),U,3)
 I ADEDIR,ADEREPD]"" S Y=ADEREPD D SCRN1 S:'$T (ADEREPD,ADEREP)=""
 S:ADEREPD]"" ADEREP=$P(^DIC(16,ADEREPD,0),U)
RESET3 N DIR
 S ADEFACD=$O(^ADEPARAM(0))
 S DIR(0)="PO^ADEPARAM(ADEFACD,1,:QEMZ"
 S DIR("A")="Select Location of Encounter"
 ;     ENTER A LOCATION
 S DIR("A",1)="DENTAL VISIT DATA ENTRY STARTUP SCREEN"
 S DIR("A",2)=""
 S DIR("A",3)="The LOCATION OF ENCOUNTER selected from those listed below"
 S DIR("A",4)="applies to every dental visit until you change it to another location.  You"
 S DIR("A",4.1)="may change the LOCATION before selecting the patient name for each visit."
 S DIR("A",5)=""
 S DIR("A",6)="DENTAL CARE PROVIDERS are selected from the CURRENT VISIT"
 S DIR("A",7)="ENTRIES TABLE.  Provider names can be edited to apply only to the"
 S DIR("A",8)="current visit data or to subsequent visits entered during this session."
 S DIR("A",9)=""
RESET4 D ^DIR
 I $$HAT()!(X="")!(X[U) K DIR Q  ;S Y=-1 Q
 I Y<1 G RESET4
 S ADEFACD=$P(Y,U,2),ADEFAC=Y(0,0) ;Q  ;,Y=1 Q
 I '$$UNIV^ADEGRL0(ADEFACD) G RESET3
 Q
 ;
HAT() ;EP - Returns 1 if dtout,duout,dirout
 I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q 1
 Q 0
PTLOOK ;EP
 K DIC,Y,ADEPAT
 W !,"Enter the Health Record Number of a Patient: "
 R X:DTIME
 I '$T!(X="")!(X["^") S Y=-1 Q
 I X["?" S XQH="ADE-DVIS-PATIENT" D EN^XQH K XQH G PTLOOK
 S DIC="^AUPNPAT(",DIC(0)="MEZQ" D ^DIC K DIC
 G:Y<1 PTLOOK
 S ADEPAT=$P(Y,U)
 I $D(^ADEUTL("ADELOCK",ADEPAT)) W !!,"PATIENT'S RECORD CURRENTLY BEING EDITED.  TRY LATER." H 3 K ADEPAT,X G PTLOOK
 S ^ADEUTL("ADELOCK",ADEPAT)=""
 S Y=1 Q
