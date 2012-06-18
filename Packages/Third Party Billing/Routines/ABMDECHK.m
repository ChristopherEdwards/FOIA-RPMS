ABMDECHK ; IHS/ASDST/DMJ - Looping Utility to Check Parms ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM13359
 ;    Added check for range of patients
 ;
CLM ;EP for checking Claim file data parameters
 Q:'$D(^ABMDCLM(DUZ(2),ABM,0))
 S ABM("V")=$P(^ABMDCLM(DUZ(2),ABM,0),U,7)  ;visit type
 S ABM("L")=$P(^ABMDCLM(DUZ(2),ABM,0),U,3)  ;visit location
 S ABM("I")=$P(^ABMDCLM(DUZ(2),ABM,0),U,8)  ;active insurer
 S ABM("P")=$P(^ABMDCLM(DUZ(2),ABM,0),U)  ;patient
 S ABM("D")=$P(^ABMDCLM(DUZ(2),ABM,0),U,2)  ;encounter date
 S ABM("C")=$P(^ABMDCLM(DUZ(2),ABM,0),U,6)  ;clinic
 Q:ABM("L")=""!(ABM("P")="")!(ABM("D")="")!(ABM("V")="")!(ABM("C")="")
 I $D(ABMY("PRV")),'$D(^ABMDCLM(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("CLN")),ABMY("CLN")'=ABM("C") Q
 I $D(ABMY("VTYP")),ABMY("VTYP")'=ABM("V") Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("TYP")) Q:ABM("I")=""  S:ABMY("TYP")="P" ABMY("TYP")="PFHM" Q:ABMY("TYP")'[$P($G(^AUTNINS(+ABM("I"),2)),U)
 I $D(ABMY("DT")),ABM("D")<ABMY("DT",1)!(ABM("D")>ABMY("DT",2)) Q
 K ABMQFLG
 I $D(ABMY("RNG")) D  ;range of patients--are you in...or out?
 .K ABMPTST,ABMPCE,ABMPTST("TST")
 .S ABMPTST=$E($P($G(^DPT(ABM("P"),0)),U),1,3)  ;first three letters
 .F ABMI=1,2 D
 ..F ABMJ=1:1:3 D
 ...S ABMPCE(ABMI)=$G(ABMPCE(ABMI))_$A($E(ABMY("RNG",ABMI),ABMJ))
 .F ABMJ=1:1:3 S ABMPTST("TST")=$G(ABMPTST("TST"))_$A($E(ABMPTST,ABMJ))
 .I (ABMPTST("TST")<ABMPCE(1))!(ABMPTST("TST")>ABMPCE(2)) S ABMQFLG=1
 Q:$G(ABMQFLG)=1
 S ABMP("HIT")=1
 Q
