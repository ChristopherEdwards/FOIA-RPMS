ABMDLCK2 ; IHS/ASDST/DMJ - check visit for elig - PART 2 ;   
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;;;IHS/PIMC/JLG  1/16/02
 ;Original;TMD;
 ;
 ; IHS/ASDS/LSL - 03/28/2001 - V2.4 Patch 9 - NOIS XAA-0301-200051
 ;     Allow claims to generate properly for KIDSCARE for AHCCCS.
 ;     Also allow KIDSCARE plan name on Medicaid INS regardless of
 ;     use of plan name field.
 ;
 ; IHS/ASDS/LSL - 06/27/2001 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;     Modified to expand No Eligibility Found. Reasons 39, 36, 40,
 ;     and 37 can be found in this routine.
 ;
 ; IHS/ASDS/LSL - 11/26/2001 - V2.4 Patch 10 - NOIS BXX-1101-150084
 ;     Resolve <UNDEF>53+8^ABMDLCK2
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13854
 ;   <UNDEF>43+2^ABMDLCK2 during A/R rollback
 ;
 ; *********************************************************************
4 ;EP - Medicaid Elig Chk
 S ABM("PRI")=4
 S ABM("TYP")="D"
 D PRIO
 S ABM("INS")=$O(^AUTNINS("B","MEDICAID",""))
 I '+ABM("INS") S ABME(167)="" Q
 S ABM("MDFN")=""
 F  S ABM("MDFN")=$O(^AUPNMCD("B",DFN,ABM("MDFN"))) Q:'ABM("MDFN")  D 43
 Q
 ;
43 ;
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U)=""
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U,2)=""
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U,4)=""
 N ABMINS
 S ABM("REC")=$G(^AUPNMCD(ABM("MDFN"),0))
 S ABMINS=$P(ABM("REC"),U,2)
 D  Q:'ABM("INS")
 .Q:'$P(ABM("REC"),U,4)
 .S ABM("STATE")=$P(ABM("REC"),U,4)
 .I '$D(^AUTNINS(ABMINS,13,ABM("STATE"),0)) S ABME(101)=$P(^DIC(5,ABM("STATE"),0),U) Q
 .S ABM("INS")=$P(^AUTNINS(ABMINS,13,ABM("STATE"),0),U,2)
 .Q:'$P(ABM("REC"),"^",10)
 .S ABMPLAN=$$GET1^DIQ(9000004,ABM("MDFN"),.11)   ; Plan name
 .I ABMINS=3,ABM("STATE")=3,ABMPLAN["KIDS" S ABM("INS")=$P(ABM("REC"),U,10)
 .I ABMINS=3,ABM("STATE")=3,ABMPLAN["CHIP" S ABM("INS")=$P(ABM("REC"),U,10)
 .; Piece 5 in the 3P ins file is USE PLAN NAME? field
 .Q:'$P($G(^ABMNINS(DUZ(2),ABM("INS"),0)),"^",5)
 .; Piece 10 of Medicaid eligible file is Plan Name
 .S ABM("INS")=$P(ABM("REC"),U,10)
 ;If the insurer has been merged to another insurer use the one merged
 ;to.
 I $P($G(^AUTNINS(ABM("INS"),2)),U,7)]"" S ABM("INS")=$P(^(2),U,7)
 K ABM("SUB")
 S ABM("NDFN")=""
 ;If subfile 11 does not exist then no elig start and end date
 ; 39 ; Medicaid coverage; no eligibility date
 I '+$O(^AUPNMCD(ABM("MDFN"),11,0)) D   Q
 .D CHK^ABMDLCK1
 .S ABM("XIT")=1
 .S $P(ABML(99,ABM("INS")),U,6)=39
 .D UNCHK
 .K ABM("XIT")
 S ABMELGDT=0
 S ABM("NDFN")=0
 F  S ABM("NDFN")=$O(^AUPNMCD(ABM("MDFN"),11,ABM("NDFN"))) Q:'ABM("NDFN")  D
 .S ABM("SUB")=^AUPNMCD(ABM("MDFN"),11,ABM("NDFN"),0)
 .D 44
 I 'ABMELGDT D  Q
 .I '$D(ABML(ABM("PRI"),ABM("INS"))) D
 ..I '$D(ABML(99,ABM("INS"))) D
 ...S $P(ABML(99,ABM("INS")),U)=$G(ABM("MDFN"))
 ...S $P(ABML(99,ABM("INS")),U,2)=$G(ABM("NDFN"))
 ...S $P(ABML(99,ABM("INS")),U,3)="D"
 ..S $P(ABML(99,ABM("INS")),U,6)=36
 E  I $D(ABML(ABM("PRI"),ABM("INS"))),ABM("PRI")<97 D
 .K ABML(99,ABM("INS"))
 Q
 ;
44 ;
 ;ABM("NDFN") is the start date.  2nd piece of ABM("SUB") is end date
 Q:ABM("NDFN")>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1)
 I $P(ABM("SUB"),U,2)]"",$P(ABM("SUB"),U,2)<$P(ABMVDT,".",1) Q
 S ABMELGDT=1
 S ABM("COV")=$P(ABM("SUB"),U,3)
 ;This is the coverage type from the 11 multiple from Medicaid elg file
 ;This must match the plan code in coverage type file.
 I ABM("COV")]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),ABM("COV"),0))
 K ABM("XIT")
 D CHK^ABMDLCK1
 I $G(ABM("XIT")) D UNCHK
 Q
 ;
5 ; Private Ins chk
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:3,ABM("EMPLOYED")=1:1,1:2)
 S ABM("TYP")="P"
 Q:'$D(^AUPNPRVT(DFN))
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNPRVT(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D 53
 Q
 ;
53 ;
 K ABM("XIT")
 Q:$P($G(^AUPNPRVT(DFN,11,ABM("MDFN"),0)),U)=""
 Q:'$D(^AUTNINS($P(^AUPNPRVT(DFN,11,ABM("MDFN"),0),U),0))
 ; 40 ; POV is accident related; but insurer is not
 S ABM("REC")=^AUPNPRVT(DFN,11,ABM("MDFN"),0)
 S ABM("INS")=$P(ABM("REC"),U)
 I 'ACCDENT,$$ACCREL^ABMDLCK(ABM("MDFN")) D  ;Q:ABMVDFN
 .S ABM("XIT")=1
 .S $P(ABML(99,ABM("INS")),U,6)=40
 D PRIO
 I $P(ABM("REC"),U,6)>$P(ABMVDT,".",1) D  Q
 .S $P(ABML(99,ABM("INS")),U,2)=ABM("MDFN")
 .S $P(ABML(99,ABM("INS")),U,3)="P"
 .S $P(ABML(99,ABM("INS")),U,6)=37
 I $P(ABM("REC"),U,7)]"",$P(ABM("REC"),U,7)<$P(ABMVDT,".",1) D  Q
 .S $P(ABML(99,ABM("INS")),U,2)=ABM("MDFN")
 .S $P(ABML(99,ABM("INS")),U,3)="P"
 .S $P(ABML(99,ABM("INS")),U,6)=37
 Q:$P(ABM("REC"),U,8)=""  ;abm*2.6*2 quit if no policy holder
 S ABM("COV")=$P($G(^AUPN3PPH($P(ABM("REC"),U,8),0)),U,5)
 ;ABM("COV") is the ien of the coverage type file
 I ABM("COV"),$P($G(^AUTTPIC(ABM("COV"),0)),U,5) D
 .S ABM("MSUP",ABM("INS"))=""
 .S ABM("OPRI")=ABM("PRI")
 .S ABM("PRI")=4
 D CHK^ABMDLCK1
 I $D(ABM("OPRI")) D
 .S ABM("PRI")=ABM("OPRI")
 .K ABM("OPRI")
 I $G(ABM("XIT")) D UNCHK
 Q
 ;
6 ; Non-beneficiary Patient
 K ABM("XIT")
 S ABM("PRI")=5
 S ABM("TYP")="N"
 D PRIO
 S ABM("INS")=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",""))
 I '+ABM("INS") S ABME(169)="" Q
 ;Piece 12 of node 11 is indian eligibility status.  I means ineligible
 G 7:'$D(^AUPNPAT(DFN,11)),7:($P(^(11),U,12)'="I")
 S (ABM("COV"),ABM("MDFN"))=""
 D CHK^ABMDLCK1
 I $G(ABM("XIT")) D UNCHK
 Q
 ;
7 ; Beneficiary Patient
 K ABM("XIT")
 ;Piece 18 of 0 node is the "bill all pats" field
 N ABMBBENP,ABMPRI
 S ABMBBENP=$P($G(^ABMDPARM(DUZ(2),1,0)),U,18),ABMBDISP=$P($G(^(0)),"^",10)
 Q:'ABMBBENP
 S ABMPRI=$O(ABML(0))
 Q:ABMPRI>0&(ABMPRI<97)&('ABMBDISP)      ;Quit if other insurer found
 ;Don't put an entry in ABML for bene pat if there another entry
 ;If bill all inpats check for visit type
 Q:ABMBBENP=2&$D(SERVCAT)&("HID"'[$G(SERVCAT))
 Q:ABMBBENP=2&$D(ABMP("VTYP"))&($G(ABMP("VTYP"))'=111)
 S ABM("PRI")=6
 S ABM("TYP")="I"
 D PRIO
 S ABM("INS")=$O(^AUTNINS("B","BENEFICIARY PATIENT (INDIAN)",""))
 I '+ABM("INS") Q
 S (ABM("COV"),ABM("MDFN"))=""
 D CHK^ABMDLCK1
 I $G(ABM("XIT")) D UNCHK
 Q
 ;
PRIO ;SET PRIORITY
 F  D  Q:'$D(ABML(ABM("PRI")))
 .Q:'$D(ABML(ABM("PRI")))
 .S ABM("PRI")=ABM("PRI")+1
 Q
 ;
 ;ABM("XIT") serves as a flag that the priority needs to be 99
 ;
UNCHK ;EP-Instead of deleting the coverage for insurer represented by ien
 ;ABM("INS") the subroutine changes the priority for this insurer to
 ;99
 I ABM("XIT") D  Q
 .N P
 .S P=$S($D(ABM("BEFSD"))=0:99,1:97)
 .S REASON=$P($G(ABML(P,ABM("INS"))),U,6)
 .M ABML(P,ABM("INS"))=ABML(ABM("PRI"),ABM("INS"))
 .S:+REASON $P(ABML(P,ABM("INS")),U,6)=REASON
 .K REASON
 .K ABML(ABM("PRI"),ABM("INS"))
 I $D(ABML(99,ABM("INS"))),ABM("PRI")'=99 D
 .S:ABM("CV")]"" ABML(ABM("PRI"),ABM("INS"),"COV",ABM("CV"))=""
 .K ABML(99,ABM("INS"))
 Q
