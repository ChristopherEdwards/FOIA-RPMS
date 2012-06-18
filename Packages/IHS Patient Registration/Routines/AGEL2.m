AGEL2 ; IHS/ASDS/EFG - Add/Edit Eligibility Info PAGE 2 ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
D14 K DIC,AGELP("RELSH") S DIC="^DPT(",DIC(0)="QEAM",DIC("A")="Select Member to ADD..: "
 D ^DIC I +Y<1 Q
 I $D(AGELP(+Y)) W *7 Q
DENT S X=+Y,DIC(0)="L",DIC="^AUPNMCD("
 S AGEL("IDFN")=$O(^AUTNINS("B","MEDICAID",""))
 I AGEL("IDFN")="" Q
 S AGEL("ST")=$O(^AUTNINS(AGEL("IDFN"),13,"C",AGELP("INS"),"")) Q:AGEL("ST")=""
 I $D(AGELP("MODE")),AGELP("MODE")="A",$D(AG("NUM")) S AGEL("POL")=AG("NUM")
 E  S AGEL("POL")=$P(^AUPN3PPH(AGELP("PH"),0),U,4),AGEL("COV")=$P(^(0),U,5)
 I AGEL("POL")]"" S AGEL("X")=$O(^AUPNMCD("AB",+Y,AGEL("ST"),AGEL("POL"),"")) I AGEL("X")]"" G DEDIT
 S DIC("DR")=".02////"_AGEL("IDFN")_";.03////"_AGEL("POL")
 S DIC("DR")=DIC("DR")_";.04////"_$O(^AUTNINS(AGEL("IDFN"),13,"C",AGELP("INS"),""))
 S DIC("DR")=DIC("DR")_";.05////"_$P($P(AGV("X2"),U),";",2)
 I AGELP("SAME") S DIC("DR")=DIC("DR")_";.06///SELF"
 E  I $D(AGELP("RELSH")) S DIC("DR")=DIC("DR")_";.06////"_AGELP("RELSH")
 E  S DIC("DR")=DIC("DR")_";.06R~Relationship to Insured..: "
 S DIC("DR")=DIC("DR")_";.09////"_AGELP("PH")
 K DD,DO D FILE^DICN K DIC Q:+Y<1
 S AGEL("X")=+Y
 S AGEL("DFN")=$S($D(DFN):DFN,1:""),AGEL("MCD")=$S($D(AG("MCD")):AG("MCD"),1:""),DFN=X,AG("MCD")=+Y D UPDATE^AGED5 S:AGEL("DFN")]"" DFN=AGEL("DFN") S:AGEL("MCD")]"" AG("MCD")=AGEL("MCD")
DMULT I '$D(^AUPNMCD(AGEL("X"),11)) S ^AUPNMCD(AGEL("X"),11,0)="^9000004.11D^^"
 S AGEL("BDT")=$P(^AUPN3PPH(AGELP("PH"),0),U,17) Q:AGEL("BDT")=""
 S DA(1)=AGEL("X"),DIC="^AUPNMCD("_DA(1)_",11,"
 S (X,DINUM)=AGEL("BDT"),DIC(0)="L"
 K DD,DO S DIC("DR")=".02////"_$P(^AUPN3PPH(AGELP("PH"),0),U,18)
 S AGEL("COV")=$P(^AUPN3PPH(AGELP("PH"),0),U,5)
 I AGEL("COV")]"" S DIC("DR")=DIC("DR")_".03////"_$S($D(^AUTTPIC(AGEL("COV"),0)):$P(^(0),U),1:"")_";.04////"_AGEL("COV")
 K DD,DO D FILE^DICN K DIC,DINUMA
 Q
DEDIT S DIE="^AUPNMCD(",DA=AGEL("X")
 S DR=".02////"_AGEL("IDFN")
 S DR=DR_";.03////"_AGEL("POL")
 S DR=DR_";.04////"_AGEL("ST")
 S DR=DR_";.05////"_$P($P(AGV("X2"),U),";",2)
 I AGELP("SAME") S DR=DR_";.06///SELF"
 E  I $D(AGELP("RELSH")) S DR=DR_";.06////"_AGELP("RELSH")
 E  S DR=DR_";.06R~Relationship to Insured..: "
 S DR=DR_";.09////"_AGELP("PH")
 D ^DIE
 I $D(X),X>0 S AGEL("DFN")=$S($D(DFN):DFN,1:""),AGEL("MCD")=$S($D(AG("MCD")):AG("MCD"),1:""),DFN=X,DA=AGEL("X") D UPDATE^AGED5 S:AGEL("DFN")]"" DFN=AGEL("DFN") S:AGEL("MCD")]"" AG("MCD")=AGEL("MCD")
DEDML ;EP
 S AGEL("BDT")=$P(^AUPN3PPH(AGELP("PH"),0),U,17) Q:AGEL("BDT")=""
 I '$D(^AUPNMCD(AGEL("X"),11)) G DMULT
 S (AGEL("DT"),AGEL("DUP"))=0 F AGZ("I")=1:1 S AGEL("DT")=$O(^AUPNMCD(AGEL("X"),11,AGEL("DT"))) Q:'+AGEL("DT")  S AGEL("DT0")=^(AGEL("DT"),0) D
 .I $P(AGEL("DT0"),U,2)=""&($P(AGEL("DT0"),U,3)="") D DKILL Q
 .I $P(AGEL("DT0"),U,2)="",$P(AGEL("DT0"),U,3)=AGEL("COV") D @($S(AGEL("DUP")=0:"DUP",1:"DKILL")) Q
 .I AGEL("BDT")<$P(AGEL("DT0"),U,2),$P(AGEL("DT0"),U,3)=AGEL("COV")!(AGEL("COV")="")!($P(AGEL("DT0"),U,3)="") D DUP
 I AGEL("DUP")=0 G DMULT
 Q
DUP I AGEL("DUP") D DKILL Q
 S DA(1)=AGEL("X"),DA=AGEL("DT"),DIE="^AUPNMCD("_DA(1)_",11,"
 S DR=".02////"_$P(^AUPN3PPH(AGELP("PH"),0),U,18)
 I AGEL("COV")]"" S DR=DR_";.03////"_$S($D(^AUTTPIC(AGEL("COV"),0)):$P(^(0),U),1:"")_";.04////"_AGEL("COV")
 D ^DIE S AGEL("DUP")=1
 Q
DKILL S DA(1)=AGEL("X"),DA=AGEL("DT"),DIK="^AUPNMCD("_DA(1)_",11," D ^DIK
 Q
