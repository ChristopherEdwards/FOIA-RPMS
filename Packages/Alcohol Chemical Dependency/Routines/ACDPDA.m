ACDPDA ;IHS/ADC/EDE/KML - DATA ENTRY/EDIT/DELETE FOR PREVENTION;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;Add prevention days
 ;//[ACD 1PSADD]
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Records that may be added are: THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"ADDING CDMIS PREVENTION RECORDS...",!!
 K ACDVISP S DIC("DR")=""
 S DIE="^ACDF5PI("
 K DTOUT S DR="[ACD PREVENTION DAY]",DIE("NO^")="BACK",DA=DUZ(2) D ^DIE K DIE,DIC,DR,DA I $D(DTOUT)!('$D(ACDVISP)) D CHK G K
 ; Above input template shifts to the CDMIS PREVENTION file and does
 ; a forced add.  No lock required.
 ;
EN1 ;ASK DAYS OVER AND OVER
 K ACDM,X
 K DIR,X,Y S DIR(0)="9002170.75,.01" D ^DIR G:X["^"!($D(DTOUT))!(X="") CHK S ACDM(1)=Y
 K DIR,X,Y S DIR(0)="P^9002170.9:AEQM" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(2)=+Y
 K DIR,X,Y S DIR(0)="P^9002170.8:AEQM" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(3)=+Y
 K DIR,X,Y S DIR(0)="9002170.75,3" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(4)=Y
 K DIR,X,Y S DIR(0)="9002170.75,4" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(5)=Y
 K DIR,X,Y S DIR(0)="9002170.75,5" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(6)=Y
 K DIR,X,Y S DIR(0)="9002170.75,8" D ^DIR G:X["^"!($D(DTOUT)) CHK S ACDM(7)=Y
 F ACDLP=1:1:7 I '$D(ACDM(ACDLP)) D CHK G K
 ;
 S DA(1)=ACDVISP
 S DIC="^ACDPD("_DA(1)_",1,",DIE=DIC
 I '$D(@(DIC_"0)")) S @(DIC_"0)")="^9002170.75AI"
 S X=ACDM(1)
 S DIC("DR")="1////"_ACDM(2)_";2////"_ACDM(3)_";3////"_ACDM(4)_";4////"_ACDM(5)_";5////"_ACDM(6)_";8////"_ACDM(7)
 S DIC(0)="L"
 D FILE^ACDFMC
 ;
PV ;
 ;Ask user for secondary providers
 S DA(1)=ACDVISP
 S DIE="^ACDPD("_DA(1)_",1,"
 S DA=+Y,DR=6,DIE("NO^")="BACK" D DIE^ACDFMC
 ;
 W !,"Day entry filed......" D K
 W !! G EN1
 ;
EN2 ;EP Edit Prevention days
 ;//[ACD 1PSEDIT]
 W @IOF,"Signon Program is   : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Editable Records are: THOSE NOT EXTRACTED."
 W !,"                      THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"EDITING CDMIS PREVENTION RECORDS...",!!
 S DIE="^ACDF5PI(",DA=DUZ(2),DR="[ACD PREVENTION EDIT]" D ^DIE
 L
 G CHK
 ;
CHK ;Check for valid entry
 Q:'$D(ACDVISP)
 I $D(^ACDPD(+ACDVISP,0)),'$O(^ACDPD(+ACDVISP,1,0)) D DEL
 I $D(ACDVISP),$D(^ACDPD(+ACDVISP,0)) F  D CHK2 Q:ACDQ
 S ACDQ=0
 I $D(ACDM) G K
 Q
 ;
CHK2 ;Allow display/edit
 S ACDQ=1
 W !!,"You may now display or edit the CDMIS PREVENTION record just created or edited."
 S DIR(0)="S^0:Continue;1:Display record;2:Edit record" S DIR("B")="0" K DA D ^DIR K DIR
 S ACDY=Y
 Q:'ACDY
 W !
 I ACDY=1 S DIC="^ACDPD(",DA=+ACDVISP,ACDQ=0 K DR D DIQ^ACDFMC,PAUSE^ACDDEU Q
 ; must be 2 edit
 S DIE="^ACDPD(",DA=+ACDVISP,DR="[ACD PREVENTION EDIT]"
 D DIE^ACDFMC
 S ACDQ=0
 Q
 ;
DEL ;Delete incomplete/incorrect entries
 Q:'$D(ACDVISP)
 S:'$D(ACDH(1)) $P(ACDH(1),"=",79)="=" W !!!,ACDH(1)
 S DA=+ACDVISP,DIK="^ACDPD(" D ^DIK W !,"** INCOMPLETE or INCORRECT ** PREVENTION LINK deleted from prevention file. **",!,ACDH(1)
 W !!?4,"Prevention Deletion Complete...."
 Q
 ;
EN3 ;EP Delete a prevention entry - interactive
 ;//[ACDDIK1]
 W @IOF,"Signon Program is               : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Prevention records to Delete are: THOSE NOT EXTRACTED."
 W !,"                                  THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"DELETING CDMIS PREVENTION RECORDS...",!!
 S DIC("S")="I $P(^(0),U,4)=DUZ(2),'$P(^(0),U,25)"
 S:'$D(ACDH(1)) $P(ACDH(1),"=",79)="=" S DIC(0)="AEQ",DIC="^ACDPD(" D ^DIC G:Y<0 K S ACDVISP=+Y
 S:'$D(ACD80) $P(ACD80,"=",79)="=" W !,ACD80
 F  S %=2 W !,"Are You Sure You wish to DELETE this ENTRY" D YN^DICN W:%=0 " Answer Yes or No" Q:%=2!(%=-1)  I %=1 D DEL G K
 W " No action taken...."
K ;
 K DIC,DIK,DIE,DR,DA,ACDLP,ACDH,ACDM,ACDAY,ACD80
 Q
