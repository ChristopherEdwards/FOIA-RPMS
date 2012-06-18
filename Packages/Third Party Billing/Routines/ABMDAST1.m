ABMDAST1 ; IHS/ASDST/DMJ - APC VISIT STUFF - PART 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 I $O(^DIC(40.7,"B","EMERGENCY MEDICINE",""))=ABMP("CLN") S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0) D ASET^ABMDE3B
 I $O(^DIC(40.7,"B","EPSDT",""))=ABMP("CLN") S Y=67 D SP^ABMDE3B
 I $O(^DIC(40.7,"B","FAMILY PLANNING",""))=ABMP("CLN") S Y=70 D SP^ABMDE3B
 I $P($G(^AAPCRCDS(ABMP("VDFN"),2)),U,28)]"" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),ABM("Y")=$S(+$P(^(2),U,28)=1:1,1:5),DR=".82////"_ABMP("VDT")_";.83////"_ABM("Y"),ABM("X")=ABMP("VDT") D ^DIE K DR D ACCODE^ABMDE3A
 ;
 S ABM=0,ABM("P")=1
 F ABM("P")=ABM("P"):1 S ABM=$O(^AAPCRCDS(ABMP("VDFN"),3,ABM)) Q:'ABM  S ABM("X")=+^AAPCRCDS(ABMP("VDFN"),3,ABM,0) D
 .Q:'$D(^AAPCRECD(ABM("X"),0))  S ABM("CD")=$E($P(^AAPCRECD(ABM("X"),0),U,2),3,99)
 .S ABM("Y")="UNK"
 .S ABM("SAVE")=ABM("CD") I $D(^ICD9("B")) D
 ..D LOOK1
 ..S:$D(^ICD9(+X,0)) ABM("Y")=+X
 .I ABM("Y")="UNK" S ABM("CD")=ABM("SAVE") D
 ..D LOOK2
 ..S:$D(^ICD9(+X,0)) ABM("Y")=+X
 .I ABM("Y") D POVCK
 G ^ABMDAST2
 ;
POVCK ; SCREEN OUT E CODES AND INACTIVE CODES
SEX I $P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,11)]"",$P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,11)'=$P(^DPT(ABMP("PDFN"),0),U,2) Q  ;CSV-c
AGE S X1=ABMP("VDT"),X2=$P(^DPT(ABMP("PDFN"),0),U,3) D ^%DTC
 I $D(^ICD9(ABM("Y"),9999999)) Q:$P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,15)]""&(X>($P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,15)))  Q:$P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,16)]""&(X>($P($$DX^ABMCVAPI(ABM("Y"),ABMP("VDT")),U,16)))  ;CSV-c
 ;
POVOK Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM("Y"),0))
 S X=$P(^AAPCRECD(ABM("X"),0),U,3)
 S DIC=9999999.27,DIC(0)="XL" D ^DIC Q:Y<0  S ABM("NAR")=+Y
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABM("P")))=10 S ABMR="" F  S ABMR=$O(^(ABMR)) Q:ABMR=""  S ABM("P")=ABMR+1
 S (DINUM,X)=ABM("Y")
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",17,",DIC(0)="LE" K DD,DO
 S DIC("P")=$P(^DD(9002274.3,17,0),U,2)
 S DIC("DR")=".02////"_ABM("P")_";.03////"_ABM("NAR") K DD,DO D FILE^DICN
 Q
 ;
LOOK1 ; Lookup using "B" x-ref
 I $L(ABM("CD"))>3 S ABM("CD")=$E(ABM("CD"),1,3)_"."_$E(ABM("CD"),4,5)
 S X=$O(^ICD9("B",ABM("CD"),"")) Q:X
 I $E(ABM("CD"),$L(ABM("CD")))=0 D
 .S ABM("ZCD")=""""_""""_ABM("CD")_""""_"""",X=$O(^ICD9("B",ABM("ZCD"),"")) K ABM("ZCD") Q:X
 I $L(ABM("CD"))>3 S ABM("CD")=ABM("CD")_" ",X=$O(^ICD9("B",ABM("CD"),"")) Q:X
 I $L(ABM("CD"))<4 S ABM("ZCD")=ABM("CD")_".",X=$O(^ICD9("B",ABM("ZCD"),"")) K ABM("ZCD") Q:X
 I $L(ABM("CD"))<4 S ABM("CD")=ABM("CD")_". ",X=$O(^ICD9("B",ABM("CD"),""))
 Q
 ;
LOOK2 ; Lookup using "BA" x-ref
 S ABM("Y")="UNK"
 I $L(ABM("CD"))>3 S ABM("CD")=$E(ABM("CD"),1,3)_"."_$E(ABM("CD"),4,5)
 S X=$O(^ICD9("BA",ABM("CD"),"")) Q:X
 I $E(ABM("CD"),$L(ABM("CD")))=0 D
 .S ABM("ZCD")=""""_""""_ABM("CD")_""""_"""",X=$O(^ICD9("BA",ABM("ZCD"),"")) K ABM("ZCD") Q:X
 I $L(ABM("CD"))>3 S ABM("CD")=ABM("CD")_" ",X=$O(^ICD9("BA",ABM("CD"),"")) Q:X
 I $L(ABM("CD"))<4 S ABM("ZCD")=ABM("CD")_".",X=$O(^ICD9("BA",ABM("ZCD"),"")) K ABM("ZCD") Q:X
 I $L(ABM("CD"))<4 S ABM("CD")=ABM("CD")_". ",X=$O(^ICD9("BA",ABM("CD"),""))
 Q
