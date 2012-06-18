ABMERINS ; IHS/ASDST/DMJ - UB92 EMC Set up Insurer Information ;   
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ;Original;DMJ;06/25/96 12:43 PM
 ; IHS/SD/SDR - V2.5 P3 - 1/24/03 - NEA-0301-180044
 ;     Modified to display patient info when workers comp
 ; IHS/SD/SDR - v2.5 p8 - IM14799
 ;    Modified BCBS line tag to kill possible pre-existing calue of
 ;    ABME("LOC")
 ; IHS/SD/SDR - v2.5 p9 - IM18990
 ;    Correction for <UNDEFINED>PH+9^ABMERINS
 ; IHS/SD/SDR - v2.5 p10 - IM19963
 ;   Changed relationship code to use X12 code
 ; IHS/SD/SDR - v2.5 p10 - IM20000
 ;   Added code to look at CARD NAME in Policy Holder file
 ; IHS/SD/SDR - v2.5 p10 - IM21619
 ;   Made change to print worker's comp claim number
 ; IHS/SD/SDR v2.5 p11 - IM24315
 ;   Added check for new parameter for UB Relationship code
 ; IHS/SD/SDR - abm*2.6*3 - HEAT8996 - get group name/# for Medicaid
 ;
 ; *********************************************************************
 ;
START ;START HERE
 ;
ISET ;SET UP DEPENDING ON INSURER
 K ABME("BCBS")
 S ABME("ITYPE")=$P(^AUTNINS(ABME("INS"),2),U) ; Type of insurer
 Q:"I"[ABME("ITYPE")
 S ABME("INM")=$P(^AUTNINS(ABME("INS"),0),U)  ; Ins name
 K ABME("PH"),ABME("PHNM"),ABME("PPP")
 S:'$G(ABME("INSIEN")) ABME("INSIEN")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABME("INS"),0))
 D @$S(ABME("INS")=1:"RR",ABME("ITYPE")="R":"MCR",ABME("ITYPE")="D"!(ABME("ITYPE")="K"):"MCD",ABME("ITYPE")="N":"NON",1:"PRVT")
 S ABME("ID#")=$G(ABMR(30,70))
 Q
 ;
RR ;RAILROAD RETIREMENT
 S DIQ="ABM("
 S DIQ(0)="E"
 S DIC="^AUPNRRE("
 S DA=ABMP("PDFN")
 S DR=".01;.03;.04;2101"
 D EN^DIQ1
 K DIQ
 S ABME("PHNM")=$G(ABM(9000005,DA,2101,"E"))  ; Railroad patient name
 S:ABME("PHNM")="" ABME("PHNM")=$G(ABM(9000005,DA,.01,"E")) ; Pat IEN
 S ABME("PPP")=ABMP("PDFN")  ; Patient IEN
 S ABMR(30,70)=$G(ABM(9000005,DA,.03,"E"))_$G(ABM(9000005,DA,.04,"E"))  ; Prefix IEN_rr#
 Q
 ;
MCR ;MEDICARE INSURER
 S DIQ="ABM("
 S DIQ(0)="E"
 S DIC="^AUPNMCR("
 S DA=ABMP("PDFN")
 S DR=".01;.03;.04;2101"
 D EN^DIQ1
 K DIQ
 S ABME("PHNM")=$G(ABM(9000003,DA,2101,"E"))
 S:ABME("PHNM")="" ABME("PHNM")=$G(ABM(9000003,DA,.01,"E"))
 S ABME("PPP")=ABMP("PDFN")
 S ABMR(30,70)=$G(ABM(9000003,DA,.03,"E"))_$G(ABM(9000003,DA,.04,"E"))
 Q
 ;
MCD ;MEDICAID INSURER
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPNMCD("
 S DA=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,+ABME("INSIEN"),0)),"^",6)
 ;S DR=".03;.05;.06;.09;.11;2101;2102"  ;abm*2.6*3 HEAT8996
 S DR=".03;.05;.06;.09;.11;.17;2101;2102"  ;abm*2.6*3 HEAT8996
 I ABME("INSIEN"),$P($G(^AUPNMCD(+DA,0)),U)'=ABMP("PDFN") D
 .D DBFX^ABMDEFIP(ABMP("BDFN"),ABME("INSIEN"))
 .S DA=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABME("INSIEN"),0)),U,6)
 D:DA EN^DIQ1
 S ABME("GRP")=$G(ABM(9000004,+DA,.17,"I"))  ;abm*2.6*2 HEAT8996
 S ABME("REL")=$G(ABM(9000004,+DA,.06,"I"))
 S ABME("REL")=$P($G(^AUTTRLSH(+ABME("REL"),0)),U,5)
 S:$G(ABMP("VTYP"))'="" ABMRELC=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,18)
 S ABME("REL")=$S($G(ABMRELC)="U":$P($G(^AUTTRLSH(+ABME("REL"),0)),U,3),1:$P($G(^AUTTRLSH(+ABME("REL"),0)),U,5))
 I ABME("REL")="" S ABME("REL")=$S($G(ABMRELC)="U":"01",1:18)
 I +ABME("REL")=18!($G(ABMRELC)="U"&(ABME("REL")=1)) D
 .S ABME("PHNM")=$G(ABM(9000004,+DA,2101,"E"))
 .S:ABME("PHNM")="" ABME("PHNM")=$P(^DPT(ABMP("PDFN"),0),U)
 .S ABME("PPP")=ABMP("PDFN")
 .S ABME("DOB")=$G(ABM(9000004,+DA,2102,"I"))
 .Q
 I +ABME("REL")'=18 D
 .S ABME("PH")=$G(ABM(9000004,+DA,.09,"I"))
 .I ABME("PH") D PH Q
 .S ABME("PHNM")=$G(ABM(9000004,+DA,2101,"E"))
 .Q
 S ABMR(30,70)=$G(ABM(9000004,+DA,.03,"E"))
 S ABME("MCD#")=ABMR(30,70)
 Q
 ;
PRVT ; EP
 ; Private Insurer
 S:'$G(ABME("INSIEN")) ABME("INSIEN")=ABMP("INS")
 S DIQ="ABM("
 S DIQ(0)="IE"
 S DIC="^AUPNPRVT("  ; Private Insurance Eligible (9000006.11)
 S DA=ABMP("PDFN")
 S DR=1101
 S ABME("DA")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,+ABME("INSIEN"),0)),"^",8)
 S DA(9000006.11)=ABME("DA")
 S DR(9000006.11)=".05;.08"
 D:ABME("DA") EN^DIQ1
 S ABME("PH")=$G(ABM(9000006.11,+ABME("DA"),.08,"I"))  ; Policy Holder
 S ABME("REL")=$G(ABM(9000006.11,+ABME("DA"),.05,"I")) ; Relationship
 S:$G(ABMP("VTYP"))'="" ABMRELC=$P($G(^ABMNINS($S($G(ABMP("LDFN")):ABMP("LDFN"),1:DUZ(2)),ABME("INS"),1,$S($G(ABMP("VTYP")):ABMP("VTYP"),1:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)),0)),U,18)
 S ABME("REL")=$S($G(ABMRELC)="U":$P($G(^AUTTRLSH(+ABME("REL"),0)),U,3),1:$P($G(^AUTTRLSH(+ABME("REL"),0)),U,5))
 D PH,BCBS
 Q
 ;
NON ;NON-BEN PATIENT
 S ABME("PHNM")=$P(^DPT(ABMP("PDFN"),0),U)
 Q
 ;
PH ;POLICY HOLDER INFORMATION
 S DIC="^AUPN3PPH("  ; Policy holder (9000003.1)
 S DA=ABME("PH")
 S DR=".01:.19;2"
 D:DA EN^DIQ1
 S ABME("GRP")=$G(ABM(9000003.1,+DA,.06,"I"))   ; group name
 S ABME("PHNM")=$G(ABM(9000003.1,+DA,2,"E"))  ;CARD NAME of policy holder
 S:ABME("PHNM")="" ABME("PHNM")=$G(ABM(9000003.1,+DA,.01,"E"))  ; Name of policy holder
 S ABME("PPP")=$G(ABM(9000003.1,+DA,.02,"I"))   ; Patient pointer
 I $G(ABME("PHNM"))="",$G(ABME("ITYPE"))="W" D
 .S ABME("PHNM")=$TR($G(ABMP("PNAME"))," ")
 .S ABME("PPP")=ABMP("PDFN")
 S ABME("PHSEX")=$G(ABM(9000003.1,+DA,.08,"I")) ; Policy holder sex
 S ABME("DOB")=$G(ABM(9000003.1,+DA,.19,"I"))    ; Policy holder DOB
 I $G(ABMR(30,70))="" S ABMR(30,70)=$G(ABM(9000003.1,+DA,.04,"E")) ; Policy Number
 I $G(ABME("ITYPE"))="W" S ABMR(30,70)=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,8)'="":$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),4),U,8),1:$P($G(^DPT(ABMP("PDFN"),0)),U,9))  ;claim number or patient SSN
 Q
 ;
BCBS ;Check if Blue Cross and Blue Shield
 K ABME("LOC")
 K ABME("BCBS")
 S ABME("INM")=$P(^AUTNINS(ABME("INS"),0),U)  ; Insurer name
 N I
 F I="B","C","B","S" D  Q:'ABME("LOC")
 .S ABME("LOC")=$F(ABME("INM"),I,$G(ABME("LOC")))
 Q:'ABME("LOC")
 S ABME("BCBS")=1
 S ABMR(30,60)=$S($E($G(ABMR(30,70)))="R":"",1:$P($G(^AUTNEGRP(+ABME("GRP"),0)),"^",2))
 Q
 ;
DIQ1 ;PULL BILL DATA VIA DIQ1
 Q:$D(ABM(9002274.4,ABMP("BDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".66;.67;.68;.73;.74;.75;.99"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ2 ;POLICY HOLDER INFORMATION
 Q:$D(ABM(9000003.1,ABME("PH"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPN3PPH("
 S DA=ABME("PH")
 S DR=".02;.15"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ3 ;PATIENT IS INSURED    
 Q:$D(ABM(2,ABMP("PDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^DPT("
 S DA=ABMP("PDFN")
 S DR=".31115"
 D EN^DIQ1
 K DIQ
 Q
