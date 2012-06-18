ABMAROL1 ; IHS/ASDST/DMJ - A/R ROLL OVER ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
START(X,Y,Z,ZZ) ;EP - FROM A/R
 ;X:BILL INTERNAL ENTRY NUMBER^VISIT LOCATION, Y:TOTAL PAYMENT AMT
 ;Z = Bill Name (passed by 1.1, but not 1.0)
 ;ZZ = Msg from A/R  (not used by 
 ; This rtn is called from A/R ^BARROLL.  The purpose is to file
 ;payment information into the Payment multiple of 3P BILL.
 ;After filing this data, the bill is marked as completed.
 ;Variables are then set in preparation of calling the Eligibility
 ;Checker.  This is done to find other billable sources that have
 ;not yet been billed in relation to this claim.  If other billable
 ;sources exist and the user holds the 3PB key, they are asked if
 ;the calim should be re-opened for future billing.  Otherwise the 
 ;claim is automatically reopened.         
 S ABMP("BDFN")=+X           ; 3P Bill File IEN
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",1),ABM("AMT")=Y
 D FILE
 D SET
 D REST
 Q
REST ;DO REST
 S ABMP("CDFN")=+ABMP("BILL")
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)) W !,"CLAIM #",ABMP("CDFN")," HAS BEEN CANCELLED.",! Q
 N I S I=0,DA=0 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I",$P(^(0),"^",1)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8) S DA=I
 I DA S DA(1)=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,",DR=".03////C" D ^DIE K DR
 I +ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U) Q
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",4)="E" D  Q
 .W !,"Claim is already in edit status.",!
UNBILL ;LOOK FOR UNBILLED SOURCES
 W !!,"CHECKING FOR UNBILLED SOURCES.",!
 S (ABM("HIT"),ABM("CNT"))=0
 D ELG^ABMDLCK("",.ABML,ABMP("PDFN"),ABMP("VDT"))
 N I S I=0 F  S I=$O(ABML(I)) Q:'I  D
 .N J S J=0 F  S J=$O(ABML(I,J)) Q:'J  D
 ..S ABM("PRI")=I,ABM("INS")=J
 ..D ADDCHK^ABMDE2E
 S ABM="" F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,0))
 .I "PIFL"[$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0),U,3) D
 ..S ABM("INSCO")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0),"^",1)
 ..Q:$P($G(^AUTNINS(ABM("INSCO"),2)),U)="I"  Q:$P($G(^(1)),U,7)=4
 ..W:ABM("CNT") ! S ABM("CNT")=ABM("CNT")+1
 ..W ?18,"[",ABM("CNT"),"]  ",$P(^AUTNINS(ABM("INSCO"),0),U) S ABM(ABM("CNT"))=ABM("X")
 I ABM("CNT")=0 D  K ABM,ABMP Q
 .D CCLM
 .W "NONE",!!,"Since there are no unbilled sources no further billing is possible."
 S ABM("HIT")=ABM(1)
 S Y=1
 I $D(^XUSEC("ABMDZ EDIT CLAIM AND EXPORT",DUZ)) D
 .W ! S DIR(0)="Y",DIR("A")="Re-open claim for further billing? (Y/N)" D ^DIR K DIR Q:$D(DIRUT)
 I Y'=1 D CCLM K ABM,ABMP Q
 S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".24////"_Y D ^DIE
 D OCLM
 S DA(1)=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,",DA=ABM("HIT"),DR=".03////I" D ^DIE
 K ABM,ABMP
 Q
ADD ;ADD BILL NOT IN BILL FILE
 ;MAYBE WILL DO LATER
 Q
FILE ;FILE PAYMENT INFORMATION
 S:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),3)) ^(3,0)="^9002274.403D^^"
 S DA(1)=ABMP("BDFN")
 S X="T"
 S DIC="^ABMDBILL(DUZ(2),DA(1),3,",DIC(0)="LE"
 S DIC("DR")=".02///"_ABM("AMT")
 D ^DIC Q:Y<0
 D CBIL
 Q
SET ;SET UP NEEDED VARIABLES
 S ABMP("PDFN")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5),ABMP("INS")=$P(^(0),"^",8)
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),"^",1)
 Q
OCLM S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".04////E;.08////"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("HIT"),0),"^",1) D ^DIE
 W !!,"Claim Number: ",+ABMP("BILL")," is now Open for Editing!",!
 Q
CCLM S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".04////C" D ^DIE
 Q
CBIL ;EP for Closing Bill
 S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////C;.17///@" D ^DIE K DR
 Q
 ;
OBIL S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////P" D ^DIE K DR
 Q
