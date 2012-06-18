AGEL3 ; IHS/ASDS/EFG - Add/Edit Eligibility Info PAGE 3 ;  
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
V14 K DIC,AGELP("RELSH")
 S TEMPDFN=DFN
 S DIC="^DPT(",DIC(0)="QEAM"
 S DIC("A")="Select Member to Add..: "
 D ^DIC
 S DFN=TEMPDFN
 I +Y<1 Q
 I $D(AGELP(+Y)) W *7 Q
VENT S AGEL("X")=+Y
 I '$D(^AUPNPRVT(+Y,0)) D  Q:Y<0
 .K DIC,DD,DO
 .S DIC="^AUPNPRVT(",DIC(0)="L",(X,DINUM)=+Y
 .D FILE^DICN
 .K X,DINUM
 G VADD
 S (AGEL("INX"),AGEL("IN"))=0
 F AGZ("I")=1:1 S AGEL("IN")=$O(^AUPNPRVT(AGEL("X"),11,AGEL("IN"))) Q:'+AGEL("IN")  S AGEL("IN0")=^(AGEL("IN"),0) D  Q:AGEL("INX")
 .I $P(AGEL("IN0"),U)=AGELP("INS"),$P(AGEL("IN0"),U,2)=""!($P(AGEL("IN0"),U,2)=$P(^AUPN3PPH(AGELP("PH"),0),U,4)) D
 ..S AGEL("INX")=1 Q
 I AGEL("INX") G VEDIT
VADD S X=AGELP("INS")
 ;I '$D(^AUPNPRVT(+Y,11)) S ^AUPNPRVT(+Y,11,0)="^9000006.11P^^"
 I '$D(^AUPNPRVT(+Y,11)) S DIC("P")=$P(^DD(9000006,1101,0),U,2)  ;AG*7.1*1 IMPROPER HARD SET OF SUBFILE
 K DD,DO,DIC,AGREC
 S DIC(0)="L",DA(1)=AGEL("X")
 S DIC="^AUPNPRVT("_DA(1)_",11,"
 D FILE^DICN
 K DIC Q:+Y<1
 S AGEL("IN")=+Y
 S AGREC=+Y
 S DR=".12   Person Code..: "
 S DR=DR_";.14   Primary Care Provider...: "
 S DR=DR_";21   Member Number..: "
 S DR=DR_";.15  Card Copy Obtained (Y/N)?..: "
 S DA=+Y,DA(1)=AGEL("X")
 S $P(AGINSREC,U,11)=DA(1)_",11,"_DA_",0"
 S DIE="^AUPNPRVT("_DA(1)_",11,"
 D ^DIE
 I $P($G(^AUPNPRVT(DFN,11,DA,0)),U,15)["Y" D
 .S DR=".16  Date CC Obtained..: "
 .D ^DIE
VEDIT S DR=".02////"_$P(^AUPN3PPH(AGELP("PH"),0),U,4)_";.03////"_$P(^(0),U,5)_";.06////"_$P(^(0),U,17)
 S DR=DR_";.07////"_$P(^(0),U,18)_";.08////"_AGELP("PH")_";.04////"_$P(^AUPN3PPH(AGELP("PH"),0),U)
 I AGELP("SAME") S DR=DR_";.05///SELF"
 E  I $D(AGELP("RELSH")) S DR=DR_";.05////"_AGELP("RELSH")
 E  S DR=DR_";.05R~Relationship to Insured..: "
 S DA=AGEL("IN"),DA(1)=AGEL("X")
 S DIE="^AUPNPRVT("_DA(1)_",11,"
 D ^DIE
 S AGEL("DFN")=$S($G(AGEL("IN")):AGEL("IN"),$D(DFN):DFN,1:"")
 S DFN=DA(1)
 D UPDATE1^AGED(DUZ(2),DA(1),7,DA)
 Q
