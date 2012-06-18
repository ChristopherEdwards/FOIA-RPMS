ABMDFUTL ; IHS/ASDST/DMJ - Export Forms Utility ;     
 ;;2.6;IHS Third Party Billing System;**2,6,8**;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/ASDS/DMJ - 05/15/00 - V2.4 Patch 1 - NOIS HQW-0500-100032
 ;     Modified to allow population of the PIN number for KIDSCARE
 ;     as well as visit type 999.
 ;
 ; IHS/ASDS/SDH - 08/14/01 - V2.4 Patch 9 - NOIS NDA-1199-180065
 ;     Modified routine to get grouper allowance, non-covered, and
 ;     penalties.
 ;
 ; IHS/ASDS/SDH - 11/20/01 - V2.4. Patch 10 - NOIS QXX-1101-130059
 ;     Modified to get billed amount even if there are no payments
 ;
 ; IHS/SD/SDR - 10/10/02 V2.5 P2 - NGA-0902-180106
 ;      Modified to put provider number in 24k if Medicare/Railroad insurer
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    utility to return provider for line item
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p12 - IM24799 - Made change for <UNDEF>K24N+9^ABMDFUTL
 ; IHS/SD/SDR - v2.5 p12 - IM25017 - Made changes for 1st line of block 24J
 ; IHS/SD/SDR - v2.5 p13 - IM26203 - Print loc NPI in block 33A
 ; IHS/SD/SDR - v2.5 p13 - IM26299 - Fix if insurer type is <UNDEF>
 ; IHS/SD/SDR - v2.5 p13 - NO IM - Change to use LDFN instead of DUZ(2)
 ; IHS/SD/SDR - abm*2.6*2 - HEAT10900 - ck if Medicare and primary
 ;
 ; *********************************************************************
 ;
TXST ;EP for obtaining or adding 3P TX STATUS entry
 ;    - input variables: ABMP("EXP") - export form
 ;                       ABMY("INS") - insurer      (optional)
 ;                       ABMY("TYP") - insurer type (optional)
 ;    - output variable: ABMP("XMIT") - export batch
 ;
 N ABMX
 S ABMX="",ABMP("XMIT")=0
 F  S ABMX=$O(^ABMDTXST(DUZ(2),"B",DT,ABMX)) Q:'ABMX  D  Q:ABMP("XMIT")
 .Q:'$D(^ABMDTXST(DUZ(2),ABMX,0))  Q:$P(^(0),U,2)'=ABMP("EXP")
 .I $D(ABMY("TYP")),$P(^ABMDTXST(DUZ(2),ABMX,0),U,3)=ABMY("TYP") S ABMP("XMIT")=ABMX
 .I $D(ABMY("INS")),$P(^ABMDTXST(DUZ(2),ABMX,0),U,4)=ABMY("INS") S ABMP("XMIT")=ABMX
 Q:ABMP("XMIT")
 S DIC="^ABMDTXST(DUZ(2),",DIC(0)="L",X=DT
 S DIC("DR")=".02////"_ABMP("EXP")_";.07////1;.08////1;"_$S($D(ABMY("TYP")):".03////"_$P(ABMY("TYP"),U),$D(ABMY("INS")):".04////"_ABMY("INS"),1:".03////A")_";.05////"_DUZ
 K DD,DO,DINUM D FILE^DICN S:Y>0 ABMP("XMIT")=+Y
 Q
 ;
YTOT ;EP for updating ABMY("TOT") variable
 ;    - input variables: ABM("YTOT") = $ amount of each bill
 ;    - output variable: ABMY("TOT") = # bills ^ $ amount ^ # insurers
 ;
 S $P(ABMY("TOT"),U)=$P($G(ABMY("TOT")),U)+1
 S $P(ABMY("TOT"),U,2)=$P(ABMY("TOT"),U,2)+$G(ABM("YTOT"))
 I '$D(ABMY("TINS",$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8))) S ABMY("TINS",$P(^(0),U,8))="",$P(ABMY("TOT"),U,3)=$P(ABMY("TOT"),U,3)+1
 Q
 ;
WTOT ;EP for writing Summary totals
 Q:$D(ZTQUEUED)
 W !!?16,"(All Print-outs are Complete)"
 I $G(ABMP("XMIT")) W !!?5,"For Printing Mailing Labels, Worksheets or a Transmittal Listing...",!?5,"...refer to EXPORT BATCH: ",ABMP("XMIT") D
 .S:'$D(ABMY("TOT")) ABMY("TOT")="0^0^0"
 W !?17,"==========================="
 W !?17,"Number of Records Exported: ",$P(ABMY("TOT"),U)
 W !?17,"Number of Insurers........: ",$P(ABMY("TOT"),U,3)
 W !?17,"Total Amount Billed.......: ",$FN($P(ABMY("TOT"),U,2),",",2),!
 K DIR S DIR(0)="E" D ^DIR K DIR
 Q
 ;
TXUPDT ;EP for updating the TXST file
 Q:'ABMP("XMIT")
 S DA=ABMP("XMIT")
 Q:'$D(^ABMDTXST(DUZ(2),ABMP("XMIT"),0))  S ABM(0)=^(0),ABM(1)=$G(^(1))
 S DIE="^ABMDTXST(DUZ(2),"
 S DR=".09////"_(ABMY("TOT")+$P(ABM(0),U,9))_";.11////"_($P(ABMY("TOT"),U,2)+ABM(1))_";.12////"_($P(ABMY("TOT"),U,3)+$P(ABM(1),U,2))
 D ^ABMDDIE
 Q
 ;
PREV ;EP for obtaining previous payment info
 ;
 ; output vars: ABMP("PD") - amount of payments
 ;              ABMP("WO") - amount of write-offs
 ;
 S (ABMP("GRP"),ABMP("NONC"),ABMP("PENS"),ABMP("COI"),ABMP("DED"),ABMP("REF"))=0
 K ABMP("BILL")
 N ABM
 I $D(ABMPM) M ABMP=ABMPM K ABMPM Q
 S (ABMP("PD"),ABMP("WO"))=0
 S ABM("CLM")=$S($G(ABMP("BDFN")):+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U),1:ABMP("CDFN"))
 S ABM("BIL")=$S($G(ABMP("BDFN")):ABMP("BDFN"),1:0)
 S ABM("A")="" F  S ABM("A")=$O(^ABMDBILL(DUZ(2),"AS",ABM("CLM"),ABM("A"))) Q:ABM("A")=""  D
 .F ABM=0:0 S ABM=$O(^ABMDBILL(DUZ(2),"AS",ABM("CLM"),ABM("A"),ABM)) Q:'ABM  D
 ..Q:$D(ABM(ABM))
 ..Q:$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)'=ABMP("PDFN")
 ..Q:$P($G(^ABMDBILL(DUZ(2),ABM,0)),"^",4)="X"
 ..;Q:($P($G(^AUTNINS(ABMP("INS"),2)),U)="R")  ;abm*2.6*2 HEAT10900
 ..Q:(($P($G(^AUTNINS(ABMP("INS"),2)),U)="R")&($G(ABMR("SBR",30))="P"))  ;abm*2.6*2 HEAT10900
 ..S ABM("W")=0,ABM(ABM)=""
 ..F ABM("J")=0:0 S ABM("J")=$O(^ABMDBILL(DUZ(2),ABM,3,ABM("J"))) Q:'ABM("J")  D
 ...S ABMP("PD")=$P(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0),U,2)+ABMP("PD"),ABM("W")=ABM("W")+$P(^(0),U,6)
 ...S ABMP("WO")=ABM("W")
 ...S ABMP("GRP")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,12)
 ...S ABMP("NONC")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,7)
 ...S ABMP("PENS")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,9)
 ...S ABMP("COI")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,4)
 ...S ABMP("DED")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,3)
 ...S ABMP("REF")=$P($G(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0)),U,13)
 ..I $D(ABMP("BDFN")) S ABMP("BILL")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)
 ..I $P($G(^ABMDBILL(DUZ(2),ABM,2)),U,4)=0 S ABMP("WO")=ABMP("WO")+ABM("W")
 Q
GETPRV() ;EP - get attending or rendering provider for line
 ; item if not one on indiv. page
 I $G(ABMP("GL"))="" Q 0
 S ABMPRV=0
 ;S ABMPRVT=ABMP("GL")_"41,"_"""C"""_","_"""A"""_","_"0)"  ;abm*2.6*6 NOHEAT
 S ABMPRVT=ABMP("GL")_"41,"_"""C"",""A"",0)"  ;abm*2.6*6 NOHEAT
 S ABMPRV=$O(@ABMPRVT)
 ;I ABMPRV="" S ABMPRVT=ABMP("GL")_"41,""C"",""R"","_"0)",ABMPRV=$O(@ABMPRVT)  ;abm*2.6*6 NOHEAT
 I ABMPRV="" S ABMPRVT=ABMP("GL")_"41,""C"",""R"",0)",ABMPRV=$O(@ABMPRVT)  ;abm*2.6*6 NOHEAT
 S ABMPRVT=ABMP("GL")_"41,"_ABMPRV_",0)"
 S ABMPRVT=$P(@ABMPRVT,"^")
 Q ABMPRVT
K24() ;EP - box 24k hcfa form
 I $G(ABMP("EXP"))'=27,($P($G(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0)),"^",15)="MD") Q 1
 I $G(ABMP("EXP"))=27 Q 1
 Q 0
K24N(X) ;EP - get payer assigned number (x=provider file 200 ien)
 N Y
 I '$G(ABMP("BDFN")) S Y="" Q Y
 I '$G(ABMP("INS")) S Y="" Q Y
 S Y=$P($G(^VA(200,+X,9999999.18,ABMP("INS"),0)),"^",2)
 I Y=""&($G(ABMP("VTYP"))=999)&($P($G(^AUTNINS(ABMP("INS"),0)),U)="OKLAHOMA MEDICAID") S Y=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,X,0)),U,2)
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["MEDICARE"!($P($G(^AUTNINS(ABMP("INS"),0)),U)["RAILROAD")!($P($G(^AUTNINS(ABMP("INS"),0)),U)["BLUE") D
 .I $G(ABMP("EXP"))=27 D
 ..S:+$G(ABMDUZ2)=0 ABMDUZ2=DUZ(2)
 ..S ABMPQ=$S(ABMP("ITYPE")="R":"1C"_" ",ABMP("ITYPE")="D":"1D"_" ",$P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U)'="":$P($G(^ABMREFID($P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U),0)),U),1:"0B"_" ")
 .S Y=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,X,0)),U,2)
 I $G(ABMP("EXP"))=27 D
 .S:+$G(ABMDUZ2)=0 ABMDUZ2=DUZ(2)
 .S ABMPQ=$S(ABMP("ITYPE")="R":"1C"_" ",ABMP("ITYPE")="D":"1D"_" ",$P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U)'="":$P($G(^ABMREFID($P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U),0)),U),1:"0B"_" ")
 I $G(ABMP("ITYPE"))'="",($G(ABMP("ITYPE"))'="R"),($G(ABMP("ITYPE"))'="D"),($G(ABMP("ITYPE"))'="K") D
 .S ABMIDCD=""
 .D PIREFID^ABME8L2
 .S:$G(ABMPQ)="" ABMPQ=ABMIDCD
 S:$G(ABMPQ)="" ABMPQ="G2"
 ;S Y=$S(ABMP("EXP")=27&($G(Y)'=""):$G(ABMPQ),1:"")_Y K ABMPQ  ;abm*2.6*8 HEAT31586
 Q Y
F54() ;EP - flag 54 HCFA BOX 33
 I $G(ABMP("ITYPE"))="K" Q 1
 I $G(ABMP("VTYP"))=999 Q 1
 I $$RCID^ABMERUTL(ABMP("INS"))=99999 Q 1
 Q 0
