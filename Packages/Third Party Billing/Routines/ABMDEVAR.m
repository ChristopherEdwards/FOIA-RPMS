ABMDEVAR ; IHS/ASDST/DMJ - SET UP CLAIM VARIABLES ;      
 ;;2.6;IHS Third Party Billing;**1,4,6,7**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - v2.4 p7 - 9/7/01 NOIS HQW-0701-100066
 ;     Modifications done related to Medicare Part B.
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;   Added code for new pages 3A and 8K
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;    Add page 9F to selection
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - Allow page9 for any 837 (not just 837P)
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7884 - display page7 if visit type 731
 ; IHS/SD/SDR - abm*2.6*4 - HEAT15368 - <SUBSCR>PAGE+11^ABMDEVAR
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added page 3B
 ;
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMP("PDFN")=$P(ABMP("C0"),U)
 S ABMP("VDT")=$P(ABMP("C0"),U,2)
 S ABMP("VISTDT")=$$SDT^ABMDUTL(ABMP("VDT"))
 S ABMP("DDT")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,3)]"":$P(^(6),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,2))
 S ABMP("LDFN")=$P(ABMP("C0"),U,3)
 S ABMP("INS")=$P(ABMP("C0"),U,8)
 I ABMP("INS")]"",'$D(^AUTNINS(ABMP("INS"),0)),'$G(ABMP("DERP OPT")) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".08///@"
 .D ^DIE
 .S ABMP("INS")=""
 S ABMP("DOB")=$P(^DPT(ABMP("PDFN"),0),U,3) I $G(^(.35)) S ABMP("DOD")=$P(^(.35),U)
 ;
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 D BTYP
 D ^ABMDE2X1
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMP("CLN")=$S($P(ABMP("C0"),U,6):$P(ABMP("C0"),U,6),1:1)
 I $G(ABMP("PX"))="" S ABMP("PX")="C"
 D PAGE
 D AFFL
 D EXP
 ;
XIT K ABMX,ABMV
 Q
 ;
BTYP ;EP - SET BILL TYPE
 I '$G(^ABMDCLM(DUZ(2),+$G(ABMP("CDFN")),0)) D  Q
 .S:$D(ABMP("B0")) ABMP("BTYP")=$P(ABMP("B0"),U,2) Q
 .S:$D(ABMP("C0")) ABMP("BTYP")=$P(ABMP("C0"),U,2) Q
 .S ABMP("BTYP")=ABMP("VTYP")
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMP("BTYP")=$P(ABMP("C0"),U,12)
 S:'$G(ABMP("INS")) ABMP("INS")=$P(ABMP("C0"),U,8)
 Q:ABMP("INS")=""
 S:$P(ABMP("C0"),U,7)'="" ABMP("VTYP")=$P(ABMP("C0"),U,7)
 I ABMP("VTYP")=121,ABMP("BTYP")'=121 S ABMP("BTYP")=""
 I ABMP("BTYP")=121,$P($G(^AUTNINS(ABMP("INS"),2)),U)'="R" S ABMP("BTYP")=""
 I ABMP("BTYP")="" D
 .I $P($G(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0)),U,11) D
 ..S ABMP("BTYP")=$P(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0),U,11)
 ..S ABMP("BTYP")=$P($G(^ABMDCODE(ABMP("BTYP"),0)),U)
 .S:ABMP("BTYP")<110!(ABMP("BTYP")>999) ABMP("BTYP")=""
 .S:ABMP("BTYP")="" ABMP("BTYP")=$S(ABMP("VTYP")=111:111,ABMP("VTYP")=121:121,ABMP("VTYP")=831:831,1:131)
 .I ABMP("VTYP")=111,$P($G(^AUTNINS(ABMP("INS"),2)),U)="R" S ABMP("BTYP")=121 D
 ..N I
 ..S I=0
 ..F  S I=$O(^AUPNMCR(ABMP("PDFN"),11,I)) Q:'I  D
 ...Q:$P(^AUPNMCR(ABMP("PDFN"),11,I,0),U)>ABMP("VDT")
 ...I $P(^AUPNMCR(ABMP("PDFN"),11,I,0),U,2)<ABMP("VDT"),$P(^(0),U,2)'="" Q
 ...Q:$P(^AUPNMCR(ABMP("PDFN"),11,I,0),U,3)'="A"
 ...S ABMP("BTYP")=111
 ..I ABMP("BTYP")=121 D
 ...N I
 ...S I=0
 ...F  S I=$O(^AUPNRRE(ABMP("PDFN"),11,I)) Q:'I  D
 ....Q:$P(^AUPNRRE(ABMP("PDFN"),11,I,0),U)>ABMP("VDT")
 ....I $P(^AUPNRRE(ABMP("PDFN"),11,I,0),U,2)<ABMP("VDT"),$P(^(0),U,2)'="" Q
 ....Q:$P(^AUPNRRE(ABMP("PDFN"),11,I,0),U,3)'="A"
 ....S ABMP("BTYP")=111
 I ABMP("BTYP")'=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,12) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".12///"_ABMP("BTYP")
 .D ^DIE
 Q
 ;
PAGE ;EP - SET  SELECTABLE PAGES
 S ABMP("PAGE")="0,1,2,3"
 I $G(ABMP("CCLN"))="" D
 .I $G(ABMP("CDFN"))'="" S ABMP("CLN")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,6)
 .E  S ABMP("CLN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10)
 ;I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="AMBULANCE" S ABMP("PAGE")=ABMP("PAGE")_",31"  ;abm*2.6*7
 I +$G(ABMP("CLN"))'=0,$P($G(^DIC(40.7,ABMP("CLN"),0)),U)="AMBULANCE" S ABMP("PAGE")=ABMP("PAGE")_",31"  ;abm*2.6*7
 ;start new code abm*2.6*6 5010
 I $G(ABMP("CDFN"))'="" D
 .S ABMI=0
 .F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI)) Q:'ABMI  D
 ..Q:(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI,0)),U)=0)  ;abm*2.6*7 HEAT40762
 ..I "^T^W^"[("^"_$P($G(^AUTNINS($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI,0)),U),2)),U)_"^")&(ABMP("PAGE")'["32") S ABMP("PAGE")=ABMP("PAGE")_",32"
 ;end new code 5010
 S ABMP("PAGE")=ABMP("PAGE")_",4,5"
 S:ABMP("PX")="A" ABMP("PAGE")=ABMP("PAGE")_",6"
 ;I ABMP("VTYP")=111!($G(ABMP("BTYP"))=111)!($G(ABMP("BTYP"))=121)!(ABMP("VTYP")=831)!($G(ABMP("BTYP"))=181) S ABMP("PAGE")=ABMP("PAGE")_",7"  ;IHS/SD/SDR 7/24/08
 ;I ABMP("VTYP")=111!($G(ABMP("BTYP"))=111)!($G(ABMP("BTYP"))=121)!(ABMP("VTYP")=831)!($G(ABMP("BTYP"))=181)!($G(ABMP("BTYP"))=731) S ABMP("PAGE")=ABMP("PAGE")_",7"  ;IHS/SD/SDR 7/24/08
 ;start new code abm*2.6*1 HEAT7884
 ;I (ABMP("VTYP")=111!($G(ABMP("BTYP"))=111)!($G(ABMP("BTYP"))=121)!(ABMP("VTYP")=831)!($G(ABMP("BTYP"))=181)!(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))) S ABMP("PAGE")=ABMP("PAGE")_",7"
 ;abm*2.6*4 HEAT15368 - added + to ABMP("INS") to stop <SUBSCR>PAGE+11^ABMDEVAR
 I (ABMP("VTYP")=111!($G(ABMP("BTYP"))=111)!($G(ABMP("BTYP"))=121)!(ABMP("VTYP")=831)!($G(ABMP("BTYP"))=181)!(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(+ABMP("INS"),0)),U)["MONTANA MEDICAID"))) S ABMP("PAGE")=ABMP("PAGE")_",7"
 ;end new code HEAT7884
 S:$G(ABMP("PX"))'="I"!(ABMP("VTYP")=831) ABMP("PAGE")=ABMP("PAGE")_",8"
 ;I $P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["UB"!($P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["ADA")!($P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["837 P") S ABMP("PAGE")=ABMP("PAGE")_",9"  ;abm*2.6*1 HEAT6439
 I $P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["UB"!($P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["ADA")!($P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)["837") S ABMP("PAGE")=ABMP("PAGE")_",9"  ;abm*2.6*1 HEAT6439
 Q
 ;
AFFL ;EP - for determining Affiliation
 S ABMX("AFFL")=""
 S ABMX("I")=0
 F  S ABMX("I")=$O(^AUTTLOC(ABMP("LDFN"),11,ABMX("I"))) Q:'ABMX("I")  S ABMX("IDT")=$S($P(^(ABMX("I"),0),U,2)]"":$P(^(0),U,2),1:9999999) I ABMP("VDT")>$P(^(0),U)&(ABMP("VDT")<ABMX("IDT")) S ABMX("AFFL")=$P(^(0),U,3)
 I ABMX("AFFL")'=1 S ABMP(638)=""
 K ABMX("AFFL"),ABMX("I")
 Q
 ;
EXP ;EP for setting up Export Array
 Q:'$G(ABMP("VTYP"))
 F ABM=0:0 S ABM=$O(ABMP("VTYP",ABM)) Q:'ABM  K ABMP("VTYP",ABM)
 I '$G(ABMP("EXP")) D SET
 I (^ABMDEXP(ABMP("EXP"),0)["HCFA")!(^ABMDEXP(ABMP("EXP"),0)["CMS") S ABMP("HCFA")=1
 I ^ABMDEXP(ABMP("EXP"),0)["UB-92" S ABMP("UB92")=1
 S ABMP("EXP",ABMP("EXP"))=""
 S ABMP("VTYP",ABMP("VTYP"))=ABMP("EXP")
 Q:'$G(ABMP("CDFN"))
 I $P($G(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0)),U,6)="Y" D
 .Q:$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,999,0)),"^",7)="N"
 .S ABMP("VTYP",999)=$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,999,0)),"^",4):$P(^(0),U,4),1:14)
 .F ABMPC=1,2 D
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),70)),U,ABMPC)
 ..S $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),70),U,ABMPC)=ABMP("VTYP",999)
 .K ABMPC
 N I F I=1:1:11 D
 .N J S J="8"_$C(64+I)
 .S ABMP(J)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),70)),U,I)
 .S:ABMP(J)="" ABMP(J)=ABMP("EXP")
 .S ABMP("EXP",ABMP(J))=""
 Q
SET ;SET ABMP("EXP")
 I $G(ABMP("CDFN")),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,14) S ABMP("EXP")=$P(^(0),U,14) Q
 I $P($G(^ABMNINS(DUZ(2),+$G(ABMP("INS")),1,ABMP("VTYP"),0)),U,4) S ABMP("EXP")=$P(^(0),U,4)
 E  S ABMP("EXP")=$S(ABMP("BTYP")=111:11,ABMP("BTYP")=831:11,ABMP("VTYP")=998&$P($G(^ABMDPARM(DUZ(2),1,3)),U,2):$P(^(3),U,2),1:3)
 Q
