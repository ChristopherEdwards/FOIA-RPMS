ABMDE0X1 ; IHS/ASDST/DMJ - Set Summary Display Variables ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 05/18/98 -  NOIS QBA-0598-130045
 ;               Get error 004 - Claim has no charges or procedures to
 ;               bill when items exist only on page 8J (Charge Master).
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for new ambulance multiple (47)
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 ; *********************************************************************
 I ABMP("PX")="C" D CPT
 I ABMP("PX")="I" D PX
 D 72
 N I
 F I=1:1 Q:'$D(ABM("P"_I))  S ABM("P"_I)=$TR(ABM("P"_I),"""","'")
 Q
 ;
 ; *********************************************************************
PX ;
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM)) Q:ABM=""  D
 .S Y=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM,0))
 .S ABMICD0=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,Y,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$ICDOP^ABMCVAPI(ABMICD0,ABMP("VDT")),U,5),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")
 Q
 ;
 ; *********************************************************************
CPT ;EP - Entry Point for setting up display array
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,"C",ABM)) Q:ABM=""  D
 .S Y=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,"C",ABM,""))
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,Y,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")
 S ABM=0
 F ABM("I")=ABM("I"):1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(+Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")-1
 S ABM=0
 F ABM("I")=ABM("I"):1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")-1
 S ABM=0
 F ABM("I")=ABM("I"):1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")-1
 S ABM=0
 F ABM("I")=ABM("I"):1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")-1
 S ABM=0
 F ABM("I")=ABM("I"):1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($$CPT^ABMCVAPI(Y,ABMP("VDT")),U,3),1,34)  ;CSV-c
 S ABM("CNT2")=ABM("CNT2")+ABM("I")-1
 I '$D(ABM("P1")) D
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0))
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,0))
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,0))
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),45,0))
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,0))
 .S ABME(4)=""
 Q
72 ;check 72 hour rule
 Q:'$$IN72H^ABMDVCK0(ABMP("CDFN"))
 S ABME(191)=""
 Q
