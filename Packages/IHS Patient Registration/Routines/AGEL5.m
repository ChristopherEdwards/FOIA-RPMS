AGEL5 ; IHS/ASDS/EFG - Add/Edit Eligibility PART 5 ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
V14 S (AGEL("HIT"),AGEL("PT"))=0 F AGZ("I")=1:1 S AGEL("PT")=$O(AGELP(AGEL("PT"))) Q:'+AGEL("PT")  I +AGELP(AGEL("PT"))=AGEL S AGEL("HIT")=AGEL("PT") Q
 I AGEL("HIT") W !!,"Policy Member: ",$P(^DPT(AGEL("PT"),0),U)
 Q:'AGEL("HIT")
 NEW AGBILL
 S AGBILL=$$USED^AGED51(AGEL("PT"),"",8,+$P(AGELP(AGEL("HIT")),U,2))
 I $L(AGBILL) S X="IORVON;IORVOFF" D ENDR^%ZISS,HELP^XBHELP("USED","AGED51"),KILL^%ZISS
 I $L(AGBILL) Q:'$$DIR^XBDIR("Y","Proceed with edit of Date Record","N")
 I AGEL("HIT")
 I  S DA(1)=AGEL("HIT"),DIE="^AUPNPRVT("_DA(1)_",11,",DA=+$P(AGELP(AGEL("HIT")),U,2),DR=".05R~Relationship to Insured..: ;.06Starting Date.. : ;.07Expiration Date...:  ;.12Person Code...: ;21Member Number: " D ^DIE
 Q
D14 S (AGEL("HIT"),AGEL("PT"))=0
 F AGZ("I")=1:1 S AGEL("PT")=$O(AGELP(AGEL("PT"))) Q:'+AGEL("PT")  I +AGELP(AGEL("PT"))=AGEL S AGEL("HIT")=AGELP(AGEL("PT")) Q
 Q:AGEL("HIT")=0
 W !!,"Policy Member: ",$P(^DPT(AGEL("PT"),0),U)
 S DA=$P(AGEL("HIT"),U,2)
 S DIE="^AUPNMCD(",DR=".06R~Relationship to Insured..: "
 D ^DIE
 I '$D(^AUPNMCD(DA,11)) S ^AUPNMCD(DA,11,0)="^9000004.11D^^"
 S DA(1)=$P(AGEL("HIT"),U,2)
 S DIE="^AUPNMCD("_DA(1)_",11,"
 S DA=$P(AGEL("HIT"),U,3)
 S DR=".02Expiration Date..: "
 I DA]"" D ^DIE Q
 K DIC
 S DIC(0)="QEAL",DIC=DIE,DIC("DR")=".02Expiration Date..: "
 S DIC("A")="  Effective Date...: "
 D ^DIC
 K DIC
 Q
UPDT ;EP - UPDATE FLDS IN ELIGIBILITY FILE
 S AGEL("U0")=^AUPN3PPH(AGELP("PH"),0),AGEL("U")=""
 G:AGELP("TYPE")="MCD" UMCD
 F AGZ("I")=1:1 S AGEL("U")=$O(^AUPNPRVT("C",AGELP("PH"),AGEL("U"))) Q:'+AGEL("U")  D
 .S AGEL("U1")=""
 .F AGZ("I")=1:1 S AGEL("U1")=$O(^AUPNPRVT("C",AGELP("PH"),AGEL("U"),AGEL("U1"))) Q:'+AGEL("U1")  D
 ..S DR=".02////"_$P(AGEL("U0"),U,4)_";.03////"_$P(AGEL("U0"),U,5)_";.04////"_$P(AGEL("U0"),U)
 ..S AGX0=^AUPNPRVT(AGEL("U"),11,AGEL("U1"),0)
 ..S AGEL("U0BD")=$P(AGEL("U0"),U,17),AGEL("U0ED")=$P(AGEL("U0"),U,18)
 ..S AGEL("X0BD")=$P(AGX0,U,6),AGEL("X0ED")=$P(AGX0,U,7)
 ..I (AGEL("X0BD")<AGEL("U0BD")) S DR=DR_";.06////"_AGEL("U0BD")
 ..I AGEL("U0ED"),(AGEL("X0BD")>AGEL("U0ED")) D
 ...S DR=DR_";.06////"_AGEL("U0BD")
 ..I AGEL("X0ED"),(AGEL("X0BD")'<AGEL("X0ED")) D
 ...S DR=DR_";.06////"_AGEL("U0BD")
 ..I AGEL("U0ED"),(AGEL("X0ED")>AGEL("U0ED")) D
 ...S DR=DR_";.07////"_AGEL("U0ED")
 ..I AGEL("U0ED"),'AGEL("X0ED") S DR=DR_";.07////"_AGEL("U0ED")
 ..I AGEL("X0ED"),(AGEL("X0ED")<AGEL("U0BD")) D
 ...S DR=DR_";.07////"_AGEL("U0ED")
 ..I AGEL("X0ED"),(AGEL("X0ED")'>AGEL("X0BD")) D
 ...S DR=DR_";.07////"_AGEL("U0ED")
 ..I ($P(AGX0,U,5)=25) D
 ...S DR=DR_";.06////"_AGEL("U0BD")_";.07////"_AGEL("U0ED") ;self
 ..S DA(1)=AGEL("U"),DIE="^AUPNPRVT("_DA(1)_",11,",DA=AGEL("U1") D ^DIE
 ..S AGEL("DFN")=$S($D(DFN):DFN,1:""),DFN=DA("1")
 ..D UPDATE^AGED
 ..S:AGEL("DFN")]"" DFN=AGEL("DFN")
 ..K AGX0,AGEL("U0BD"),AGEL("U0ED"),AGEL("X0BD"),AGEL("X0ED")
 Q
UMCD F AGZ("I")=1:1 S AGEL("U")=$O(^AUPNMCD("C",AGELP("PH"),AGEL("U"))) Q:'+AGEL("U")  D
 .S DR=".03////"_$P(AGEL("U0"),U,4)_";.05////"_$P(AGEL("U0"),U)
 .S DIE="^AUPNMCD(",DA=AGEL("U") D ^DIE
 .S AGEL("COV")=$P(AGEL("U0"),U,5),AGEL("X")=AGEL("U") D DEDML^AGEL2
 .S AGEL("DFN")=$S($D(DFN):DFN,1:"")
 .S AGEL("MCD")=$S($D(AG("MCD")):AG("MCD"),1:"")
 .S DFN=$P(^AUPNMCD(AGEL("U"),0),U)
 .S AG("MCD")=AGEL("U")
 .D UPDATE^AGED5
 .S:AGEL("DFN")]"" DFN=AGEL("DFN")
 .S:AGEL("MCD")]"" AG("MCD")=AGEL("MCD")
 Q
