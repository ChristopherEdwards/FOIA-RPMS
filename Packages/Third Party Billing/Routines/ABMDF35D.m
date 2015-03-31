ABMDF35D ; IHS/SD/SDR - Set HCFA1500 (02/12) Print Array - Part 4 ;  
 ;;2.6;IHS Third Party Billing;**13**;NOV 12, 2009;Build 213
 ;
 ; *********************************************************************
 ;
DX ; Diagnosis Info
 K ABMP("DX")
 S ABM=""
 S ABM("ID")=31
 S ABM("TB")=1
 S ABMDXQ=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM)) Q:'ABM!(ABM>12)  D  Q:ABMDXQ=1
 .S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM,""))
 .S ABM("DIAG")=$P($$DX^ABMCVAPI(ABM("X"),ABMP("VDT")),U,2)  ; CSV-c
 .S $P(ABMF(30),U)=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM("X"),0)),U,6)=1:0,1:9)  ;ICD indicator
 .S $P(ABMF(ABM("ID")),U,ABM("TB"))=ABM("DIAG")
 .S ABM("TB")=ABM("TB")+1
 .I (ABM("TB")>4) D
 ..S ABM("TB")=1
 ..S ABM("ID")=ABM("ID")+1
 .I ABM("ID")>33 S ABMDXQ=1 Q
 .S ABMP("DX",ABM("DIAG"))=ABM("ID")-30
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,13)="N" D  ;remove decimal from DX?
 .F ABM("ID")=31:1:33 D
 ..Q:'$D(ABMF(ABM("ID")))
 ..S ABMF(ABM("ID"))=$TR(ABMF(ABM("ID")),".")
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
 ..I $G(ABMQLFLG)'=1 S $P(ABMS(ABMI),U,4)=$P(ABMS(ABMI),U,4)_"  "_ABMODMOD
 K ABMQLFLG
HCFA ;
 I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U)=0 S ABMS("TOT")=0
 D EMG^ABMDF35E  ;set EMG flag
 S ABMS=0
 F  S ABMS=$O(ABMS(ABMS)) Q:+ABMS=0  D
 .S ABMLN=2
 .D PROC^ABMDF35E
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
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,23)'=0 S $P(ABMF(49),U,8)=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,23)  ;abm*2.6*13
 S ABM("OB")=ABMS("TOT")-$P(ABMF(49),U,8)
 S:ABM("OB")<0 ABM("OB")=0
 S ABM("YTOT")=ABM("OB")
 D YTOT^ABMDFUTL
 S $P(ABMF(49),U,7)=ABMS("TOT")    ; Total Charges
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,17)="DO" D
 .S $P(ABMF(49),U,8)=+$FN(ABMP("PD"),"",2)
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,23)'=0 S $P(ABMF(49),U,8)=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,23)  ;abm*2.6*13
 ; Amount Due
 K ABMS
 I $D(ABMR) D
 .S ABMR("TOT")=$P(ABMF(49),U,7,8)
 .S $P(ABMF(49),U,7)="",$P(ABMF(49),U,8)=""
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
PDT ;
 S $P(ABMF(54),U)=$S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,7),0)),U),$G(ABMP("PRINTDT"))="A":$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,5),1:DT)
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
