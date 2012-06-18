ABMDF27D ; IHS/ASDST/DMJ - Set HCFA1500 (08/05) Print Array - Part 4 ;  
 ;;2.6;IHS Third Party Billing;**1,2,4,6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;   Put taxonomy code if NPI ONLY
 ; IHS/SD/SDR,AML - v2.5 p13 - NO IM
 ; IHS/SD/SDR - v2.5 p13 - IM26203
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT5612 - modifier wasn't printing
 ; IHS/SD/SDR - abm*2.6*2 - FIXPMS10006 - check for print date (FL31)
 ; IHS/SD/SDR - abm*2.6*4 - HEAT12115 - made change to allow 8 DX codes to print
 ; *********************************************************************
 ;
DX ; Diagnosis Info
 K ABMP("DX")
 ;S ABM="" F ABM("I")=31:1:34 S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM)) Q:'ABM  D  ;abm*2.6*4 HEAT12115
 S ABM="" F ABM("I")=31:1:38 S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM)) Q:'ABM  D  ;abm*2.6*4 HEAT12115
 .S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM,""))
 .S ABM(9)=$P(^AUTNPOV($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM("X"),0),U,3),0),U)
 .S ABM(9)=$S(ABM(9)["*ICD*":$P(ABM(9),"  "),1:ABM(9))
 .;S ABM("ID")=$S(ABM("I")=32:33,ABM("I")=34:33,1:31)  ;abm*2.6*4 HEAT12115
 .S ABM("ID")=$S(ABM("I")=32:33,ABM("I")=34:33,ABM("I")=36:33,ABM("I")=38:33,1:31)  ;abm*2.6*4 HEAT12115
 .;S ABM("TB")=$S(ABM("I")<33:1,1:2)  ;abm*2.6*4 HEAT12115
 .S ABM("TB")=$S(ABM("I")<33:1,ABM("I")<35:3,ABM("I")<37:2,1:4)  ;abm*2.6*4 HEAT12115
 .S ABM(9)=""
 .S ABM("DIAG")=$P($$DX^ABMCVAPI(ABM("X"),ABMP("VDT")),U,2)  ; CSV-c
 .S ABM("DIAG")=$S(ABM("I")=35:"5. "_ABM("DIAG"),ABM("I")=36:"6. "_ABM("DIAG"),ABM("I")=37:"7. "_ABM("DIAG"),ABM("I")=38:"8. "_ABM("DIAG"),1:ABM("DIAG"))  ;abm*2.6*4 HEAT12115
 .I ABMP("ITYPE")'="R",(ABM("I")>34) Q  ;abm*2.6*6 HEAT12115
 .S $P(ABMF(ABM("ID")),U,ABM("TB"))=ABM("DIAG")_" "_ABM(9)
 .S ABMP("DX",ABM("DIAG"))=ABM("I")-30
 ;
ST S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 S ABMPRINT=1 D ^ABMDESM1
 I $P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U,2)="A3" D
 .S ABMI=0
 .F  S ABMI=$O(ABMS(ABMI)) Q:'ABMI  D
 ..I $P($P(ABMS(ABMI),U,4),"-",2)="QL" S ABMQLFLG=1
 ..S ABMODMOD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,14)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,16)
 .S ABMI=0
 .F  S ABMI=$O(ABMS(ABMI)) Q:'ABMI  D
 ..I $G(ABMQLFLG)=1,($P($P(ABMS(ABMI),U,4)," ",2)'="QL") S $P(ABMS(ABMI),U,4)=$P($P(ABMS(ABMI),U,4)," ")
 ..;I $G(ABMQLFLG)'=1 S $P(ABMS(ABMI),U,4)=$P($P(ABMS(ABMI),U,4)," ")_$P($P(ABMS(ABMI),U,4)," ",2)_"  "_ABMODMOD  ;abm*2.6*1 HEAT5612
 ..I $G(ABMQLFLG)'=1 S $P(ABMS(ABMI),U,4)=$P(ABMS(ABMI),U,4)_"  "_ABMODMOD  ;abm*2.6*1 HEAT5612
 K ABMQLFLG
HCFA ;
 I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U)=0 S ABMS("TOT")=0
 D EMG^ABMDF27E  ;set EMG flag
 S ABMS=0
 F  S ABMS=$O(ABMS(ABMS)) Q:+ABMS=0  D
 .S ABMLN=2
 .D PROC^ABMDF27E
 .S ABMLN=ABMLN+1
 S ABMLN=0,ABMPRT=0
 F ABMS("I")=37:2:47 D  Q:$G(ABM("QUIT"))
 .S ABMLN=$O(ABMR(ABMLN))
 .Q:+ABMLN=0
 .S ABMPRT=0
 .I (($O(ABMR(ABMLN,9),-1))+(ABMS("I")))>49 Q
 .F  S ABMPRT=$O(ABMR(ABMLN,ABMPRT)) Q:+ABMPRT=0  D
 ..M ABMF($S(ABMPRT=1:(ABMS("I")-1),1:ABMS("I")))=ABMR(ABMLN,ABMPRT)
 ..K ABMR(ABMLN,ABMPRT)
 ;
 D PREV^ABMDFUTL
 S ABM("RATIO")=+^ABMDBILL(DUZ(2),ABMP("BDFN"),2)/$S($P(^(2),U,3):$P(^(2),U,3),1:1)
 S:ABM("RATIO")>1 ABM("RATIO")=1
 S ABM("W")=+$FN(ABMP("WO")*ABM("RATIO"),"",2)
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,17)="DO" D
 .S $P(ABMF(49),U,8)=+$FN(ABMP("PD")*ABM("RATIO"),"",2)+ABM("W")
 S ABM("OB")=ABMS("TOT")-$P(ABMF(49),U,8)
 S:ABM("OB")<0 ABM("OB")=0
 S ABM("YTOT")=ABM("OB")
 D YTOT^ABMDFUTL
 S $P(ABMF(49),U,7)=ABMS("TOT")    ; Total Charges
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,17)="DO" D
 .S $P(ABMF(49),U,8)=+$FN(ABMP("PD"),"",2)
 ; Amount Due
 I $D(ABMP("BILL")) S $P(ABMF(49),U,9)=+$FN(ABMP("BILL"),"",2)
 E  S $P(ABMF(49),U,9)=+$FN(ABMS("TOT")-ABMP("PD"),"",2)-$G(ABMP("PENS"))-$G(ABMP("NONC"))
 K ABMS
 I $D(ABMR) D
 .S ABMR("TOT")=$P(ABMF(49),U,7,9)
 .S $P(ABMF(49),U,7)="",$P(ABMF(49),U,8)="",$P(ABMF(49),U,9)=""
 ;
PRV ; Provider Info
 I $P($G(^ABMDPARM(DUZ(2),1,0)),"^",17)=3 D  G PDT
 .S ABM("SIGN")=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",7)
 .I ABM("SIGN")="" D
 ..S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) D
 ...Q:'ABM("X")
 ...D SELBILL^ABMDE4X
 ...S ABM("SIGN")=$P(ABM("A"),U,2)
 .E  D
 ..S ABM("A")=$P($G(^VA(200,+ABM("SIGN"),20)),"^",2)_"^"_+ABM("SIGN")
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,17)=2 D  G PDT
 S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) D
 .Q:'ABM("X")
 .D SELBILL^ABMDE4X
 .S $P(ABMF(52),U)=$P($G(^VA(200,+$P(ABM("A"),"^",2),20)),"^",2)
 .S:$P(ABMF(52),U)="" $P(ABMF(52),U)=$P(ABM("A"),U)
PDT ;S $P(ABMF(54),U)=DT  ;abm*2.6*2 FIXPMS10006
 ;S $P(ABMF(54),U)=$S($G(ABMPDT)="O":$P($G(^ABMDTXST(DUZ(2),+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,7),0)),U),1:DT)  ;abm*2.6*2 FIXPMS10006  ;abm*2.6*4 HEAT17615
 S $P(ABMF(54),U)=$S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,7),0)),U),1:DT)  ;abm*2.6*2 FIXPMS10006  ;abm*2.6*4 HEAT17615
 I $D(ABM("A")) D
 .S ABM("PRO")=$P(ABM("A"),U,2)
 .S $P(ABMF(54),U,4)=$S($P($$NPI^XUSNPI("Individual_ID",ABM("PRO")),U)>0:$P($$NPI^XUSNPI("Individual_ID",ABM("PRO")),U),1:"")
 .S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 .S $P(ABMF(54),U,4)=$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)
 .S ABMPQ=$S(ABMP("ITYPE")="R":"1C",ABMP("ITYPE")="D":"1D",$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U)'="":$P($G(^ABMREFID($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U),0)),U),1:"0B")
 .S:$G(ABMPQ)="" ABMPQ="G2"
 .S:($G(ABMP("NPIS"))'="")&($G(ABMP("NPIS"))'="N") $P(ABMF(54),U,5)=$G(ABMPQ)_$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 .I ($G(ABMP("NPIS"))'="")&($G(ABMP("NPIS"))'="N") S $P(ABMF(54),U,5)="ZZ"_$$PTAX^ABMEEPRV(ABM("PRO"))
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["ALASKA MEDICAID" D
 .Q:$P($G(ABMF(37)),U,3)'=22  ;only change for POS 22
 .S $P(ABMF(54),U,4)="982808978",$P(ABMF(54),U,5)="1DCL461"
 ;
XIT K ABM,ABMV,ABMX,ABMPRINT
 Q
