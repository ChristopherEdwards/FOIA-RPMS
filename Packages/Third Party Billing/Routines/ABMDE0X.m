ABMDE0X ; IHS/ASDST/DMJ - Set Summary Display Variables ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Modified to check for replacement insurer to display
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; *********************************************************************
IDEN ; EP
 S ABM(1)=$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)
 S ABM("CLN")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,6)
 S ABM(2)=$S(ABM("CLN")]"":$P($G(^DIC(40.7,ABM("CLN"),0)),U,1),1:"")
 S ABM(3)=$E($P(^ABMDVTYP($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,7),0),U),1,26)
 S ABM(4)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U)
 S ABM(5)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,2)
 S ABM(4)=$$HDT^ABMDUTL(ABM(4))
 S ABM(5)=$$HDT^ABMDUTL(ABM(5))
 ;
INS ;
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D
 .S Y=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,0))
 .S ABM("I"_ABM("I")_"S")="  "_$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,Y,0),U,3)="I":"ACTIVE",$P(^(0),U,3)="C":"COMPLETE",$P(^(0),U,3)="B":"BILLED",$P(^(0),U,3)="U":"UNBILABL",1:"PENDING")
 .S Y=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,Y,0)),U,11)'="":$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,Y,0),U,11),1:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,Y,0),U))
 .S ABM("I"_ABM("I"))=$P(^AUTNINS(Y,0),U)
 ;
QUES ;
 S ABM("CNT1")=7+ABM("I")
 D W1^ABMDE30
 D W2^ABMDE30
 S ABM("RELS")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,4)="Y":"YES",1:"NO")
 S ABM("ASGN")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)="Y":"YES",1:"NO")
 S ABM("EMRG")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,5)="Y":"YES",1:"NO")
 S ABM("EMPL")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,1)="Y":"YES",1:"NO")
 S ABM("PROG")="NO"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),59))=10 D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0))
 .I ABM("X")]"" D
 ..S ABM("X")=^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),0)
 ..I $D(^ABMDCODE(ABM("X"),0)) D
 ...S ABM("PROG")="YES"
 ...S ABM("CNT1")=ABM("CNT1")+.5
 S ABM("ACC")="NO"
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)]""!($P($G(^(8)),U,3)]"") D
 .S ABM("ACC")="YES"
 .S ABM("CNT1")=ABM("CNT1")+.5
 I ABM("EMRG")="YES" S ABM("CNT1")=ABM("CNT1")+.5
 I ABM("EMPL")="YES" S ABM("CNT1")=ABM("CNT1")+.5
 S ABM("CNT1")=ABM("CNT1")+.5
 S ABM("CNT1")=$P(ABM("CNT1"),".")
 ;
PRV ;
 K ABM("A"),ABM("O")
 S (ABM("CNT2"),ABM("CNT3"))=1
 S ABM=""
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM)) Q:ABM=""  S ABM("X")=$O(^(ABM,"")),ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABM("X"),0) Q:$P(ABM("X0"),U,2)=""  D
 .I '$D(^VA(200,+ABM("X0"),0)) D  Q
 ..S DA(1)=ABMP("CDFN")
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",41,"
 ..S DA=ABM("X")
 ..D ^DIK
 .S ABM($P(ABM("X0"),U,2))=$P(^VA(200,$P(ABM("X0"),U),0),U)
 S ABM("OPRV")=$S($D(ABM("O")):ABM("O"),1:"")
 I ABM("OPRV")]"" D
 .S ABM("CNT2")=ABM("CNT2")+1
 .S ABM("CNT3")=ABM("CNT3")+1
 S ABM("APRV")=$S($D(ABM("A")):ABM("A"),1:"")
 I ABM("OPRV")]"" D
 .S ABM("CNT2")=ABM("CNT2")+1
 .S ABM("CNT3")=ABM("CNT3")+1
 ;
DX ;
 G DDS:ABMP("VTYP")=998&'$D(ABMP("FLAT"))
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABM)) Q:ABM=""  S Y=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,$O(^(ABM,"")),0)),U,3) I Y]"" S ABM("D"_ABM("I"))=$E($G(^AUTNPOV(Y,0)),1,34)
 S ABM("CNT2")=ABM("CNT2")+ABM("I")
 ;
 D ^ABMDE0X1
 Q
 ;
 ; *********************************************************************
DDS ;
 S ABM=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM)) Q:'ABM  D
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM,0),U)
 .S ABM("P"_ABM("I"))=$E($P($G(^AUTTADA(Y,0)),U,2),1,34)
 S ABM("CNT2")=ABM("CNT2")+ABM("I")
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
 ;
XIT ;
 Q
